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

  Stream<AppUserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return AppUserModel.fromFirebaseUser(user);
    });
  }
}