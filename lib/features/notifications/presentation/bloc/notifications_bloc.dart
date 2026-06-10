import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/mark_notification_as_read_usecase.dart';
import '../../domain/usecases/watch_notifications_usecase.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final WatchNotificationsUseCase watchNotificationsUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;

  StreamSubscription? _subscription;

  NotificationsBloc({
    required this.watchNotificationsUseCase,
    required this.markNotificationAsReadUseCase,
  }) : super(const NotificationsInitial()) {
    on<NotificationsStarted>(_onStarted);
    on<NotificationsUpdated>(_onUpdated);
    on<NotificationsFailed>(_onFailed);
    on<NotificationOpened>(_onNotificationOpened);
  }

  void _onStarted(
    NotificationsStarted event,
    Emitter<NotificationsState> emit,
  ) {
    emit(const NotificationsLoading());

    _subscription?.cancel();

    _subscription = watchNotificationsUseCase(const NoParams()).listen(
      (notifications) => add(NotificationsUpdated(notifications)),
      onError: (_) =>
          add(const NotificationsFailed('Failed to load notifications.')),
    );
  }

  void _onUpdated(
    NotificationsUpdated event,
    Emitter<NotificationsState> emit,
  ) {
    emit(NotificationsLoaded(event.notifications));
  }

  void _onFailed(NotificationsFailed event, Emitter<NotificationsState> emit) {
    emit(NotificationsError(event.message));
  }

  Future<void> _onNotificationOpened(
    NotificationOpened event,
    Emitter<NotificationsState> emit,
  ) async {
    if (!event.notification.isRead) {
      await markNotificationAsReadUseCase(event.notification.id);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
