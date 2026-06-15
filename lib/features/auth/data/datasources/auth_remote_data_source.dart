import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../models/app_user_model.dart';

@lazySingleton
class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  const AuthRemoteDataSource(this._firebaseAuth, this._firestore);

  Future<AppUserModel> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (displayName != null) {
      await credential.user?.updateDisplayName(displayName);
    }

    final user = credential.user!;
    final userModel = AppUserModel(
      uid: user.uid,
      email: email,
      displayName: displayName,
    );

    // Store user data in Firestore
    await _firestore.collection('users').doc(user.uid).set(
      userModel.toFirestore(),
    );

    return userModel;
  }

  Future<AppUserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return AppUserModel.fromFirebaseUser(credential.user!);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// Uses [FirebaseAuth.userChanges] instead of [authStateChanges] so that
  /// profile mutations (e.g. updatePhotoURL after a profile-image upload)
  /// also propagate to listeners — not just sign-in/sign-out.
  Stream<AppUserModel?> get authStateChanges {
    return _firebaseAuth.userChanges().map((user) {
      if (user == null) return null;
      return AppUserModel.fromFirebaseUser(user);
    });
  }

  /// Forces a fresh fetch of the current user from the Firebase backend
  /// and returns the refreshed model. Used after profile mutations so
  /// the local user object stays in sync — `userChanges` alone doesn't
  /// reliably fire on `updatePhotoURL` calls on web/iOS.
  ///
  /// `photoUrl` is read from Firestore rather than FirebaseAuth because
  /// `updatePhotoURL(null)` is known to silently fail on the JS SDK,
  /// leaving Auth's local `photoURL` stale after a delete even though
  /// the Firestore write succeeded. Firestore is the source of truth.
  Future<AppUserModel?> refreshCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    try {
      await user.reload();
    } catch (_) {
      // Tolerate transient network errors — fall back to the last known
      // local state. The next reload (or sign-out) will catch up.
    }
    final refreshed = _firebaseAuth.currentUser;
    if (refreshed == null) return null;

    // Two distinct cases must be handled separately:
    //   (a) Firestore read succeeded → its photo_url is the truth, even
    //       when null (that's how a delete is represented).
    //   (b) Firestore read failed → fall back to FirebaseAuth's photoURL
    //       (best-effort).
    // Using `firestorePhotoUrl ?? auth.photoURL` would conflate these and
    // wrongly fall back on the post-delete case, hiding the deletion.
    String? photoUrl;
    bool firestoreSucceeded = false;
    try {
      final doc =
          await _firestore.collection('users').doc(refreshed.uid).get();
      firestoreSucceeded = true;
      if (doc.exists) {
        photoUrl = doc.data()?['photo_url'] as String?;
      }
    } catch (_) {
      // Network/permission error — fall through to the Auth fallback.
    }

    return AppUserModel(
      uid: refreshed.uid,
      email: refreshed.email ?? '',
      displayName: refreshed.displayName,
      photoUrl: firestoreSucceeded ? photoUrl : refreshed.photoURL,
    );
  }
}