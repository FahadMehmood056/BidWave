import 'package:bid_wave/core/router/app_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        'bidwave_high_importance_channel',
        'BidWave Notifications',
        description: 'Notifications for bids, auctions, and winners.',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        showBadge: true,
      );

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
  }

  Future<void> showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;

    final title = notification?.title ?? message.data['title'] as String?;
    final body = notification?.body ?? message.data['body'] as String?;

    if (title == null && body == null) return;

    final auctionId = message.data['auctionId']?.toString() ?? '';
    final type = message.data['type']?.toString() ?? '';

    await _plugin.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
          channelShowBadge: true,
          fullScreenIntent: false,
          category: AndroidNotificationCategory.message,
          visibility: NotificationVisibility.public,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: '$auctionId|$type',
    );
  }

  void _onNotificationTapped(NotificationResponse response) {
    final payload = response.payload;

    if (payload == null || payload.isEmpty) return;

    final parts = payload.split('|');

    final auctionId = parts.isNotEmpty ? parts[0] : '';
    final type = parts.length > 1 ? parts[1] : '';

    if (auctionId.isEmpty) return;

    AppRouter.openFromNotification(auctionId: auctionId, type: type);
  }
}
