import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cross_file/cross_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ProfileRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  const ProfileRemoteDataSource(
    this._firebaseAuth,
    this._firestore,
    this._storage,
  );

  /// Uploads bytes to `users/{uid}/profile.jpg`, then writes the resulting
  /// download URL to both FirebaseAuth and Firestore in parallel.
  /// Returns the download URL on success.
  Future<String> uploadProfileImage({
    required String uid,
    required XFile imageFile,
  }) async {
    final bytes = await imageFile.readAsBytes();
    final ref = _storage.ref().child('users/$uid/profile.jpg');

    await ref.putData(
      bytes,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final downloadUrl = await ref.getDownloadURL();

    await Future.wait([
      _firebaseAuth.currentUser?.updatePhotoURL(downloadUrl) ?? Future.value(),
      _firestore.collection('users').doc(uid).set(
        {'photo_url': downloadUrl},
        SetOptions(merge: true),
      ),
    ]);

    // Force a server-side reload so FirebaseAuth.userChanges fires
    // reliably across platforms (updatePhotoURL alone often doesn't
    // trigger it on web/iOS).
    await _firebaseAuth.currentUser?.reload();

    return downloadUrl;
  }

  /// Deletes the Storage file and clears photo_url in FirebaseAuth + Firestore.
  /// Tolerates Storage delete throwing "object-not-found" so a Firestore-only
  /// record (out-of-band state) still cleans up.
  Future<void> removeProfileImage({required String uid}) async {
    final ref = _storage.ref().child('users/$uid/profile.jpg');

    try {
      await ref.delete();
    } on FirebaseException catch (e) {
      if (e.code != 'object-not-found') rethrow;
    }

    await Future.wait([
      _firebaseAuth.currentUser?.updatePhotoURL(null) ?? Future.value(),
      _firestore.collection('users').doc(uid).set(
        {'photo_url': FieldValue.delete()},
        SetOptions(merge: true),
      ),
    ]);

    // See uploadProfileImage above.
    await _firebaseAuth.currentUser?.reload();
  }
}
