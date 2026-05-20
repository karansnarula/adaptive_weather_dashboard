import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationRemoteDataSource {
  final FirebaseFirestore _firestore;

  const NotificationRemoteDataSource(this._firestore);

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  Future<String?> getNotificationCity(String uid) async {
    final doc = await _userDoc(uid).get();
    if (!doc.exists) return null;
    final data = doc.data();
    return data?['notification_city'] as String?;
  }

  Future<void> setNotificationCity(String uid, String cityName) async {
    await _userDoc(uid).set(
      {'notification_city': cityName},
      SetOptions(merge: true),
    );
  }

  Future<void> clearNotificationCity(String uid) async {
    await _userDoc(uid).update({
      'notification_city': FieldValue.delete(),
    });
  }
}