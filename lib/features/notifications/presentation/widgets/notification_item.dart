import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/notification_type.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';

class NotificationItem extends StatelessWidget {
  final NotificationType type;
  final String title;
  final String subtitle;
  final bool isRead;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.isRead,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(14.w(context)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            _NotificationIcon(type: type),
            SB.w(12),
            _NotificationContent(
              title: title,
              subtitle: subtitle,
              isRead: isRead,
            ),
            if (!isRead) ...[SB.w(8), _UnreadDot(color: type.color)],
          ],
        ),
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  final NotificationType type;

  const _NotificationIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w(context),
      height: 44.w(context),
      decoration: BoxDecoration(
        color: type.backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(type.icon, size: 20.w(context), color: type.color),
    );
  }
}

class _NotificationContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isRead;

  const _NotificationContent({
    required this.title,
    required this.subtitle,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleSmall
                .responsive(context)
                .copyWith(
                  fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                ),
          ),
          SB.h(4),
          Text(subtitle, style: AppTextStyles.labelMedium.responsive(context)),
        ],
      ),
    );
  }
}

class _UnreadDot extends StatelessWidget {
  final Color color;

  const _UnreadDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8.w(context),
      height: 8.w(context),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
