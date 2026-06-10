import 'package:equatable/equatable.dart';
import '../../domain/entities/app_notification.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class NotificationsStarted extends NotificationsEvent {
  const NotificationsStarted();
}

class NotificationsUpdated extends NotificationsEvent {
  final List<AppNotification> notifications;

  const NotificationsUpdated(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationsFailed extends NotificationsEvent {
  final String message;

  const NotificationsFailed(this.message);

  @override
  List<Object?> get props => [message];
}

class NotificationOpened extends NotificationsEvent {
  final AppNotification notification;

  const NotificationOpened(this.notification);

  @override
  List<Object?> get props => [notification];
}
