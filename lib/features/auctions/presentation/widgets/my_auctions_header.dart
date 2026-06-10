import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';
import '../../../../core/widgets/stat_item.dart';
import '../../../../core/widgets/stats_row.dart';

class MyAuctionsHeader extends StatelessWidget {
  final int activeCount;
  final int endedCount;
  final String totalEarned;

  const MyAuctionsHeader({
    super.key,
    required this.activeCount,
    required this.endedCount,
    required this.totalEarned,
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
              SB.h(12),
              Text(
                AppStrings.myAuctions,
                style: AppTextStyles.headlineMedium
                    .responsive(context)
                    .copyWith(color: AppColors.white),
              ),
              SB.h(20),
              StatsRow(
                backgroundColor: AppColors.white.withValues(alpha: 0.1),
                dividerColor: AppColors.white.withValues(alpha: 0.2),
                stats: [
                  StatItem(
                    value: '$activeCount',
                    label: AppStrings.active,
                    valueColor: AppColors.white,
                  ),
                  StatItem(
                    value: '$endedCount',
                    label: AppStrings.ended,
                    valueColor: AppColors.white,
                  ),
                  StatItem(
                    value: totalEarned,
                    label: AppStrings.earned,
                    valueColor: AppColors.emerald,
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
