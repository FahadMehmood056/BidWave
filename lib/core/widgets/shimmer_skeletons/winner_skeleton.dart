import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../../extensions/responsive_extension.dart';
import '../../theme/app_colors.dart';
import '../app_shimmer.dart';
import '../sb.dart';

class WinnerSkeleton extends StatelessWidget {
  const WinnerSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.pagePadding.w(context),
      ),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SB.h(40),
          ShimmerBox.circle(size: 96.w(context)),
          SB.h(20),
          const ShimmerLine(width: 170, height: 22),
          SB.h(10),
          const ShimmerLine(width: 120, height: 14),
          SB.h(32),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(18.w(context)),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(
                AppSizes.radiusCard.w(context),
              ),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                const ShimmerLine(width: 120, height: 14),
                SB.h(14),
                const ShimmerLine(width: 180, height: 22),
                SB.h(20),
                Container(height: 1, color: AppColors.border),
                SB.h(20),
                const ShimmerLine(width: 100, height: 14),
                SB.h(10),
                const ShimmerLine(width: 160, height: 18),
                SB.h(14),
                const ShimmerLine(width: 130, height: 14),
              ],
            ),
          ),
          SB.h(32),
          ShimmerBox(
            width: double.infinity,
            height: 52.w(context),
            borderRadius: BorderRadius.circular(
              AppSizes.radiusButton.w(context),
            ),
          ),
          SB.h(24),
        ],
      ),
    );
  }
}
