import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';

class AppUserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;

  const AppUserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  factory AppUserModel.fromFirebaseUser(User user) {
    return AppUserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  factory AppUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['display_name'],
      photoUrl: data['photo_url'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'display_name': displayName,
      'photo_url': photoUrl,
      'created_at': FieldValue.serverTimestamp(),
    };
  }

  AppUser toEntity() => AppUser(
    uid: uid,
    email: email,
    displayName: displayName,
    photoUrl: photoUrl,
  );
}