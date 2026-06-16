import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FcmService {
  final FirebaseMessaging _messaging;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  void Function(String cityName)? onNotificationTapped;

  FcmService(this._messaging, this._firestore, this._auth);

  Future<void> initialize() async {
    try {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (_) {
      // Permission prompts can throw on platforms / environments that
      // don't support FCM (iOS simulator, web in some configurations).
      // Token retrieval below will fail-soft on the same platforms.
    }

    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _saveToken(token);
      }
    } on FirebaseException catch (_) {
      // Tolerated cases:
      //  * iOS simulator: APNS token never arrives, getToken throws
      //    'apns-token-not-set'.
      //  * Real device, first-launch timing: APNS handshake hasn't
      //    completed yet — onTokenRefresh below will pick up the late
      //    arrival and save it.
      // Either way we don't want to crash app boot.
    }

    _messaging.onTokenRefresh.listen(_saveToken);

    // Initialize local notifications for foreground display
    await _initLocalNotifications();

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle notification tap when app was terminated
    try {
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage);
      }
    } catch (_) {
      // Same fail-soft rationale as getToken above.
    }

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  Future<void> _initLocalNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS and macOS use the Darwin code path. We don't request
    // permission here — FirebaseMessaging.requestPermission in
    // initialize() handles that and is what the OS actually checks.
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _localNotifications.initialize(
      onDidReceiveNotificationResponse: (response) {
        final city = response.payload;
        if (city != null && onNotificationTapped != null) {
          onNotificationTapped!(city);
        }
      },
      settings: initSettings,
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    final cityName = message.data['city'];
    if (cityName != null && onNotificationTapped != null) {
      onNotificationTapped!(cityName);
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'weather_notifications',
      'Weather Notifications',
      channelDescription: 'Daily weather notification for your city',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id : notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: details,
      payload: message.data['city'],
    );
  }

  Future<void> _saveToken(String token) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set(
      {'fcm_token': token},
      SetOptions(merge: true),
    );
  }
}