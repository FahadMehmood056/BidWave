import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/sb.dart';
import '../../../../core/widgets/stat_item.dart';
import '../../../../core/widgets/stats_row.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String initials;
  final String email;
  final int wonCount;
  final int soldCount;
  final int bidsCount;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.initials,
    required this.email,
    required this.wonCount,
    required this.soldCount,
    required this.bidsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.w(context)),
          bottomRight: Radius.circular(20.w(context)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
          child: Column(
            children: [
              SB.h(16),
              AppAvatar(initials: initials),
              SB.h(12),
              Text(
                name,
                style: AppTextStyles.titleLarge
                    .responsive(context)
                    .copyWith(color: AppColors.white),
              ),
              SB.h(4),
              Text(
                email,
                style: AppTextStyles.labelLarge
                    .responsive(context)
                    .copyWith(color: AppColors.muted),
              ),
              SB.h(20),
              StatsRow(
                backgroundColor: AppColors.white.withValues(alpha: 0.1),
                dividerColor: AppColors.white.withValues(alpha: 0.2),
                stats: [
                  StatItem(
                    value: '$wonCount',
                    label: AppStrings.won,
                    valueColor: AppColors.white,
                  ),
                  StatItem(
                    value: '$soldCount',
                    label: AppStrings.sold,
                    valueColor: AppColors.white,
                  ),
                  StatItem(
                    value: '$bidsCount',
                    label: AppStrings.bids,
                    valueColor: AppColors.white,
                  ),
                ],
              ),
              SB.h(20),
            ],
          ),
        ),
      ),
    );
  }
}
