import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../router/app_router.dart';
import 'local_notification_service.dart';

class NotificationManager {
  final LocalNotificationService localNotificationService;

  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _notificationTapSubscription;

  NotificationManager({required this.localNotificationService});

  Future<void> initialize() async {
    await localNotificationService.initialize();

    _foregroundSubscription?.cancel();
    _notificationTapSubscription?.cancel();

    _foregroundSubscription = FirebaseMessaging.onMessage.listen((message) {
      //localNotificationService.showForegroundNotification(message);
    });

    _notificationTapSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleNotificationTap,
    );

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 600), () {
        _handleNotificationTap(initialMessage, fromTerminatedState: true);
      });
    }
  }

  void _handleNotificationTap(
    RemoteMessage message, {
    bool fromTerminatedState = false,
  }) {
    final auctionId = message.data['auctionId'];
    final type = message.data['type'];

    if (auctionId == null || auctionId.toString().isEmpty) return;

    AppRouter.openFromNotification(
      auctionId: auctionId.toString(),
      type: type?.toString() ?? '',
      fromTerminatedState: fromTerminatedState,
    );
  }

  Future<void> dispose() async {
    await _foregroundSubscription?.cancel();
    await _notificationTapSubscription?.cancel();
  }
}
