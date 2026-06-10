import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.red : AppColors.text;
    final iconBg = isDestructive
        ? AppColors.red.withValues(alpha: 0.1)
        : AppColors.background;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w(context),
          vertical: 14.w(context),
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w(context)),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(
                  AppSizes.radiusButton.w(context),
                ),
              ),
              child: Icon(icon, size: 20.w(context), color: color),
            ),
            SB.w(12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.titleMedium
                    .responsive(context)
                    .copyWith(color: color),
              ),
            ),
            Icon(
              AppIcons.chevronRight,
              size: 20.w(context),
              color: isDestructive ? AppColors.red : AppColors.muted,
            ),
          ],
        ),
      ),
    );
  }
}
