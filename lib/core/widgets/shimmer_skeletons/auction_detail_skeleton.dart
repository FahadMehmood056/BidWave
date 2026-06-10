import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../../extensions/responsive_extension.dart';
import '../../theme/app_colors.dart';
import '../app_shimmer.dart';
import '../sb.dart';

class AuctionDetailSkeleton extends StatelessWidget {
  const AuctionDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShimmerBox(
          width: double.infinity,
          height: 320.w(context),
          borderRadius: BorderRadius.zero,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.pagePadding.w(context),
            ),
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SB.h(16),
                const ShimmerLine(width: 90, height: 12),
                SB.h(10),
                const ShimmerLine(width: 240, height: 22),
                SB.h(18),
                ShimmerBox(
                  width: double.infinity,
                  height: 76.w(context),
                  borderRadius: BorderRadius.circular(
                    AppSizes.radiusCard.w(context),
                  ),
                ),
                SB.h(16),
                ShimmerBox(
                  width: double.infinity,
                  height: 64.w(context),
                  borderRadius: BorderRadius.circular(
                    AppSizes.radiusCard.w(context),
                  ),
                ),
                SB.h(16),
                Row(
                  children: [
                    Expanded(
                      child: ShimmerBox(
                        width: double.infinity,
                        height: 72.w(context),
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusCard.w(context),
                        ),
                      ),
                    ),
                    SB.w(12),
                    Expanded(
                      child: ShimmerBox(
                        width: double.infinity,
                        height: 72.w(context),
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusCard.w(context),
                        ),
                      ),
                    ),
                  ],
                ),
                SB.h(24),
                const ShimmerLine(width: 120, height: 18),
                SB.h(12),
                ...List.generate(
                  3,
                  (_) => Padding(
                    padding: EdgeInsets.only(bottom: 12.w(context)),
                    child: Container(
                      padding: EdgeInsets.all(12.w(context)),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(
                          AppSizes.radiusCard.w(context),
                        ),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          ShimmerBox.circle(size: 36.w(context)),
                          SB.w(12),
                          const Expanded(
                            child: ShimmerLine(width: 150, height: 14),
                          ),
                          const ShimmerLine(width: 70, height: 14),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
