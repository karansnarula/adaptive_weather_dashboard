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
    return AppUserModel.fromFirebaseUser(refreshed);
  }
}