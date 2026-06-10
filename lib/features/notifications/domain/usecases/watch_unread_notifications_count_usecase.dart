import '../../../../core/usecase/usecase.dart';
import '../repositories/notification_repository.dart';

class WatchUnreadNotificationsCountUseCase
    implements StreamUseCase<int, NoParams> {
  final NotificationRepository repository;

  WatchUnreadNotificationsCountUseCase(this.repository);

  @override
  Stream<int> call(NoParams params) {
    return repository.watchUnreadCount();
  }
}
