import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../constants/firestore_paths.dart';

class FcmTokenService {
  final FirebaseMessaging messaging;
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  bool _isListeningForTokenRefresh = false;

  FcmTokenService({
    required this.messaging,
    required this.firestore,
    required this.auth,
  });

  Future<bool> requestPermission() async {
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<bool> hasPermission() async {
    final settings = await messaging.getNotificationSettings();

    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<void> openNotificationSettings() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    }
  }

  Future<void> saveToken() async {
    final user = auth.currentUser;

    if (user == null) return;

    final allowed = await hasPermission();

    if (!allowed) return;

    final token = await messaging.getToken();

    if (token == null || token.isEmpty) return;

    await firestore.collection(FirestorePaths.users).doc(user.uid).set({
      UserFields.fcmToken: token,
    }, SetOptions(merge: true));
  }

  void listenForTokenRefresh() {
    if (_isListeningForTokenRefresh) return;

    _isListeningForTokenRefresh = true;

    messaging.onTokenRefresh.listen((token) async {
      final user = auth.currentUser;

      if (user == null || token.isEmpty) return;

      final allowed = await hasPermission();

      if (!allowed) return;

      await firestore.collection(FirestorePaths.users).doc(user.uid).set({
        UserFields.fcmToken: token,
      }, SetOptions(merge: true));
    });
  }
}
