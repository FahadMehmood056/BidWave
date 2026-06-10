import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../../extensions/responsive_extension.dart';
import '../../theme/app_colors.dart';
import '../app_shimmer.dart';
import '../sb.dart';

class AuctionCardSkeleton extends StatelessWidget {
  const AuctionCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: double.infinity,
            height: 140.w(context),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.radiusCard.w(context)),
              topRight: Radius.circular(AppSizes.radiusCard.w(context)),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSizes.paddingSmall.w(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerLine(width: 60, height: 10),
                SB.h(8),
                const ShimmerLine(width: 120, height: 14),
                SB.h(14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ShimmerLine(width: 80, height: 16),
                    ShimmerLine(width: 50, height: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
