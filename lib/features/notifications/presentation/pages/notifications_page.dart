import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/sb.dart';
import '../../../../core/widgets/shimmer_skeletons/notifications_skeleton.dart';
import '../../domain/entities/app_notification.dart';
import '../bloc/notifications_bloc.dart';
import '../bloc/notifications_event.dart';
import '../bloc/notifications_state.dart';
import '../widgets/notification_item.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  Future<void> _openNotification(
    BuildContext context,
    AppNotification notification,
  ) async {
    context.read<NotificationsBloc>().add(NotificationOpened(notification));

    if (notification.auctionId.isEmpty) return;

    final route = notification.type.name == 'won'
        ? '${AppRoutes.winner}/${notification.auctionId}'
        : '${AppRoutes.auctionDetail}/${notification.auctionId}';

    await context.push(route);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NotificationsBloc, NotificationsState>(
      listener: (context, state) {
        if (state is NotificationsError) {
          AppSnackbar.error(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const AppBackBar(title: AppStrings.notifications),
            Expanded(
              child: BlocBuilder<NotificationsBloc, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsInitial ||
                      state is NotificationsLoading) {
                    return const NotificationsSkeleton();
                  }

                  if (state is NotificationsError) {
                    return _NotificationsEmpty(message: state.message);
                  }

                  if (state is! NotificationsLoaded) {
                    return const SizedBox.shrink();
                  }

                  if (state.notifications.isEmpty) {
                    return const _NotificationsEmpty(
                      message: AppStrings.noNotifications,
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.all(AppSizes.pagePadding.w(context)),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    itemCount: state.notifications.length,
                    separatorBuilder: (_, _) => SB.h(AppSizes.cardGap),
                    itemBuilder: (_, index) {
                      final notification = state.notifications[index];
                      return NotificationItem(
                        type: notification.type,
                        title: notification.title,
                        subtitle: notification.body,
                        isRead: notification.isRead,
                        onTap: () => _openNotification(context, notification),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationsEmpty extends StatelessWidget {
  final String message;

  const _NotificationsEmpty({required this.message});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: ClampingScrollPhysics(),
      ),
      padding: EdgeInsets.all(AppSizes.pagePadding.w(context)),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.28),
        AppEmptyState(icon: AppIcons.notification, message: message),
      ],
    );
  }
}
