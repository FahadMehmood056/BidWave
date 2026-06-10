import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';
import '../../../../core/widgets/stat_item.dart';
import '../../../../core/widgets/stats_row.dart';

class MyBidsHeader extends StatelessWidget {
  final int winningCount;
  final int losingCount;

  const MyBidsHeader({
    super.key,
    required this.winningCount,
    required this.losingCount,
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
                AppStrings.myBidsTitle,
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
                    value: '$winningCount',
                    label: AppStrings.winning,
                    valueColor: AppColors.emerald,
                  ),
                  StatItem(
                    value: '$losingCount',
                    label: AppStrings.losing,
                    valueColor: AppColors.red,
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
