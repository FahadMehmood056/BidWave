import 'package:bid_wave/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';

class HomeAppBar extends StatelessWidget {
  final int liveCount;
  final int unreadNotificationCount;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const HomeAppBar({
    super.key,
    required this.liveCount,
    required this.unreadNotificationCount,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.w(context)),
          bottomRight: Radius.circular(20.w(context)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SB.h(8),
            _buildTopRow(context),
            if (categories.isNotEmpty) ...[
              SB.h(16),
              _buildCategoryFilter(context),
            ],
            SB.h(25),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.appName,
                  style: AppTextStyles.headlineMedium
                      .responsive(context)
                      .copyWith(color: AppColors.white),
                ),
                Text(
                  '$liveCount ${AppStrings.liveNow}',
                  style: AppTextStyles.labelLarge
                      .responsive(context)
                      .copyWith(color: AppColors.muted),
                ),
              ],
            ),
          ),
          _buildSearchButton(
            context,
            icon: AppIcons.search,
            onTap: () => context.push(AppRoutes.search),
          ),
          SB.w(8),
          _buildNotificationButton(
            context,
            unreadCount: unreadNotificationCount,
            onTap: () => context.push(AppRoutes.notifications),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationButton(
    BuildContext context, {
    required int unreadCount,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(8.w(context)),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              AppIcons.notification,
              size: 22.w(context),
              color: AppColors.white,
            ),
          ),
          if (unreadCount > 0)
            Positioned(
              right: -4.w(context),
              top: -4.w(context),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: 18.w(context),
                  minHeight: 18.w(context),
                ),
                padding: EdgeInsets.symmetric(horizontal: 5.w(context)),
                decoration: const BoxDecoration(
                  color: AppColors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    unreadCount > 9 ? '9+' : unreadCount.toString(),
                    style: AppTextStyles.labelMedium
                        .responsive(context)
                        .copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.w(context)),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 22.w(context), color: AppColors.white),
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return SizedBox(
      height: 40.w(context),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.pagePadding.w(context),
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, _) => SB.w(8),
        itemBuilder: (_, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return Center(
            child: GestureDetector(
              onTap: () => onCategorySelected(category),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w(context),
                  vertical: 8.w(context),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.emerald : Colors.transparent,
                  borderRadius: BorderRadius.circular(20.w(context)),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: AppColors.white.withValues(alpha: 0.2),
                        ),
                ),
                child: Text(
                  category,
                  style: AppTextStyles.labelMedium
                      .responsive(context)
                      .copyWith(
                        color: isSelected
                            ? AppColors.white
                            : AppColors.white.withValues(alpha: 0.7),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
