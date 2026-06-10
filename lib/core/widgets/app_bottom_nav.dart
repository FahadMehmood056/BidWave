import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../extensions/responsive_extension.dart';
import '../extensions/text_style_extension.dart';
import '../models/nav_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'sb.dart';

class AppBottomNav extends StatelessWidget {
  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int centerIndex;

  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.centerIndex = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(
          top: BorderSide(
            color: AppColors.muted.withValues(alpha: 0.2),
            width: 0.5,
          ),
        ),
      ),
      padding: EdgeInsets.only(
        top: 8.w(context),
        bottom: MediaQuery.paddingOf(context).bottom + 8.w(context),
      ),
      child: Row(
        children: List.generate(items.length, (index) {
          if (index == centerIndex) {
            return _buildCenterItem(context, index);
          }
          return _buildNavItem(context, index);
        }),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index) {
    final item = items[index];
    final isActive = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? item.activeIcon : item.icon,
              size: 24.w(context),
              color: isActive ? AppColors.emerald : AppColors.muted,
            ),
            SB.h(3),
            Text(
              item.label,
              style: AppTextStyles.labelMedium
                  .responsive(context)
                  .copyWith(
                    color: isActive ? AppColors.emerald : AppColors.muted,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterItem(BuildContext context, int index) {
    final item = items[index];

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(0, -16.w(context)),
              child: Container(
                width: 48.w(context),
                height: 48.w(context),
                decoration: BoxDecoration(
                  color: AppColors.emerald,
                  borderRadius: BorderRadius.circular(
                    AppSizes.radiusCard.w(context),
                  ),
                ),
                child: Icon(
                  item.icon,
                  size: 24.w(context),
                  color: AppColors.white,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -12.w(context)),
              child: Text(
                item.label,
                style: AppTextStyles.labelMedium
                    .responsive(context)
                    .copyWith(color: AppColors.emerald),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
