import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../models/comment_model.dart';
import '../models/post_model.dart';

/// Thrown by [DiscussionRemoteDataSource] when no Firebase user is signed
/// in but a write was attempted. Caught by the repository and mapped to
/// a [Failure] so it never crosses the layer boundary.
class NotSignedInException implements Exception {
  const NotSignedInException();
}

/// Raw Firestore access for the discussion feature. Knows nothing about
/// `Either` or domain entities at the boundaries — returns
/// [DocumentSnapshot]s and lets the repository do the mapping.
@lazySingleton
class DiscussionRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  const DiscussionRemoteDataSource(this._firestore, this._auth);

  /// Firestore key on the user doc for "when did the user last open the
  /// discussion feed?". Null / missing = never opened.
  static const fLastDiscussionVisit = 'last_discussion_visit';

  CollectionReference<Map<String, dynamic>> get _posts =>
      _firestore.collection(PostModel.collection);

  CollectionReference<Map<String, dynamic>> _comments(String postId) =>
      _posts.doc(postId).collection(CommentModel.subcollection);

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection('users').doc(uid);

  /// Returns (uid, displayName) for the current user, falling back to
  /// 'Guest' when displayName is missing. Throws [NotSignedInException]
  /// when there's no signed-in user — every write path needs an identity.
  ({String uid, String name}) _requireIdentity() {
    final user = _auth.currentUser;
    if (user == null) throw const NotSignedInException();
    final name = (user.displayName == null || user.displayName!.trim().isEmpty)
        ? 'Guest'
        : user.displayName!.trim();
    return (uid: user.uid, name: name);
  }

  String? get currentUserId => _auth.currentUser?.uid;

  // ============ reads ============

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getPosts() async {
    final snap = await _posts
        .orderBy(PostModel.fCreatedAt, descending: true)
        .get();
    return snap.docs;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPost(String postId) =>
      _posts.doc(postId).get();

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getComments(
    String postId,
  ) async {
    final snap = await _comments(postId)
        .orderBy(CommentModel.fCreatedAt, descending: false)
        .get();
    return snap.docs;
  }

  // ============ writes ============

  /// Creates a post and immediately re-reads it so the caller gets the
  /// server-resolved timestamp and final document id.
  Future<DocumentSnapshot<Map<String, dynamic>>> createPost(
    Map<String, dynamic> payload,
  ) async {
    final identity = _requireIdentity();
    final ref = _posts.doc();
    await ref.set({
      ...payload,
      PostModel.fAuthorId: identity.uid,
      PostModel.fAuthorName: identity.name,
    });
    return ref.get();
  }

  /// Adds a comment AND bumps the parent's commentCount in one batch so
  /// either both writes succeed or neither does.
  Future<DocumentSnapshot<Map<String, dynamic>>> addComment({
    required String postId,
    required String text,
  }) async {
    final identity = _requireIdentity();
    final commentRef = _comments(postId).doc();
    final postRef = _posts.doc(postId);

    final batch = _firestore.batch();
    batch.set(commentRef, {
      ...CommentModel.toCreateMap(
        text: text,
        authorId: identity.uid,
        authorName: identity.name,
      ),
    });
    batch.update(postRef, {
      PostModel.fCommentCount: FieldValue.increment(1),
    });
    await batch.commit();

    return commentRef.get();
  }

  /// Atomically toggles the current user's uid in the post's `likedBy`
  /// array. The strict `arrayUnion` / `arrayRemove` semantics align
  /// exactly with what the security rules' `likedSelf` / `unlikedSelf`
  /// helpers accept.
  Future<DocumentSnapshot<Map<String, dynamic>>> toggleLike(
    String postId,
  ) async {
    final identity = _requireIdentity();
    final postRef = _posts.doc(postId);

    // Read first to decide which direction to toggle. A transaction would
    // be more correct under concurrent toggles but for a portfolio demo
    // with single-user-per-post-per-second toggling this is fine.
    final snap = await postRef.get();
    final data = snap.data() ?? const <String, dynamic>{};
    final liked = (data[PostModel.fLikedBy] as List?)
            ?.map((e) => e.toString())
            .contains(identity.uid) ??
        false;

    await postRef.update({
      PostModel.fLikedBy: liked
          ? FieldValue.arrayRemove([identity.uid])
          : FieldValue.arrayUnion([identity.uid]),
    });

    return postRef.get();
  }

  /// Cascade-delete: reads all comment ids under the post and batches
  /// (delete each comment + delete post) in a single atomic write.
  /// Permitted by the rules because the deleter is the post author.
  Future<void> deletePost(String postId) async {
    _requireIdentity();
    final postRef = _posts.doc(postId);
    final commentDocs = await _comments(postId).get();

    final batch = _firestore.batch();
    for (final c in commentDocs.docs) {
      batch.delete(c.reference);
    }
    batch.delete(postRef);
    await batch.commit();
  }

  /// Deletes a comment AND decrements the parent's `commentCount` in one
  /// batch. The rules accept the delete when the requester is either the
  /// comment author or the parent post's author.
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    _requireIdentity();
    final commentRef = _comments(postId).doc(commentId);
    final postRef = _posts.doc(postId);

    final batch = _firestore.batch();
    batch.delete(commentRef);
    batch.update(postRef, {
      PostModel.fCommentCount: FieldValue.increment(-1),
    });
    await batch.commit();
  }

  // ============ unread badge support ============

  /// Reads the user's `last_discussion_visit` timestamp from their user
  /// doc. Returns null when the field is missing — i.e. the user has
  /// never opened the discussion feed.
  Future<DateTime?> getLastDiscussionVisit() async {
    final identity = _requireIdentity();
    final snap = await _userDoc(identity.uid).get();
    final raw = snap.data()?[fLastDiscussionVisit];
    if (raw is Timestamp) return raw.toDate();
    return null;
  }

  /// Writes the current server time to the user's
  /// `last_discussion_visit`. Uses merge:true so other fields on the
  /// user doc (display_name, fcm_token, notification_city, etc.) are
  /// preserved untouched.
  Future<void> markDiscussionVisit() async {
    final identity = _requireIdentity();
    await _userDoc(identity.uid).set(
      {fLastDiscussionVisit: FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );
  }

  /// Cheap aggregation query — Firestore charges 1 read regardless of
  /// how many documents match. When [since] is null the user has never
  /// opened the feed; we count ALL posts so the badge nudges them to
  /// take a first look.
  Future<int> countPostsSince(DateTime? since) async {
    _requireIdentity();
    final query = since == null
        ? _posts
        : _posts.where(
            PostModel.fCreatedAt,
            isGreaterThan: Timestamp.fromDate(since),
          );
    final result = await query.count().get();
    return result.count ?? 0;
  }
}
