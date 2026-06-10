import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<AppNotification>> watchNotifications() {
    return remoteDataSource.watchNotifications();
  }

  @override
  Stream<int> watchUnreadCount() {
    return remoteDataSource.watchUnreadCount();
  }

  @override
  Future<void> markAsRead(String notificationId) {
    return remoteDataSource.markAsRead(notificationId);
  }
}
