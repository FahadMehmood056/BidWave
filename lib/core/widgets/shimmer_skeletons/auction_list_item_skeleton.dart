import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../../extensions/responsive_extension.dart';
import '../../theme/app_colors.dart';
import '../app_shimmer.dart';
import '../sb.dart';

class AuctionListItemSkeleton extends StatelessWidget {
  const AuctionListItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w(context)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ShimmerBox(
            width: 48.w(context),
            height: 48.w(context),
            borderRadius: BorderRadius.circular(
              AppSizes.radiusButton.w(context),
            ),
          ),
          SB.w(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerLine(width: 130, height: 14),
                SB.h(8),
                const ShimmerLine(width: 70, height: 10),
              ],
            ),
          ),
          SB.w(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const ShimmerLine(width: 70, height: 14),
              SB.h(8),
              const ShimmerLine(width: 50, height: 18),
            ],
          ),
        ],
      ),
    );
  }
}
