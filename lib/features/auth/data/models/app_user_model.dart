import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/app_user.dart';

class AppUserModel {
  final String uid;
  final String email;
  final String? displayName;

  const AppUserModel({
    required this.uid,
    required this.email,
    this.displayName,
  });

  factory AppUserModel.fromFirebaseUser(User user) {
    return AppUserModel(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  factory AppUserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      displayName: data['display_name'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'display_name': displayName,
      'created_at': FieldValue.serverTimestamp(),
    };
  }

  AppUser toEntity() => AppUser(
    uid: uid,
    email: email,
    displayName: displayName,
  );
}