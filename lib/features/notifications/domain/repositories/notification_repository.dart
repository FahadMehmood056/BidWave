import '../entities/app_notification.dart';

abstract class NotificationRepository {
  Stream<List<AppNotification>> watchNotifications();

  Stream<int> watchUnreadCount();

  Future<void> markAsRead(String notificationId);
}
