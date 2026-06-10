import '../../../../core/usecase/usecase.dart';
import '../entities/app_notification.dart';
import '../repositories/notification_repository.dart';

class WatchNotificationsUseCase
    implements StreamUseCase<List<AppNotification>, NoParams> {
  final NotificationRepository repository;

  WatchNotificationsUseCase(this.repository);

  @override
  Stream<List<AppNotification>> call(NoParams params) {
    return repository.watchNotifications();
  }
}
