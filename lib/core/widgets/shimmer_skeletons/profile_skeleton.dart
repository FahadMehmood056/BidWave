import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../../extensions/responsive_extension.dart';
import '../../theme/app_colors.dart';
import '../app_shimmer.dart';
import '../sb.dart';

class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            AppSizes.pagePadding.w(context),
            58.w(context),
            AppSizes.pagePadding.w(context),
            28.w(context),
          ),
          decoration: BoxDecoration(
            color: AppColors.emerald,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28.w(context)),
              bottomRight: Radius.circular(28.w(context)),
            ),
          ),
          child: Column(
            children: [
              ShimmerBox.circle(size: 78.w(context)),
              SB.h(14),
              const ShimmerLine(width: 130, height: 16),
              SB.h(8),
              const ShimmerLine(width: 190, height: 12),
              SB.h(24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _ProfileStatSkeleton(),
                  _ProfileStatSkeleton(),
                  _ProfileStatSkeleton(),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.all(AppSizes.pagePadding.w(context)),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 3,
            separatorBuilder: (_, _) => SB.h(AppSizes.cardGap),
            itemBuilder: (_, _) => const _ProfileMenuSkeleton(),
          ),
        ),
      ],
    );
  }
}

class _ProfileStatSkeleton extends StatelessWidget {
  const _ProfileStatSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ShimmerLine(width: 35, height: 18),
        SB.h(8),
        const ShimmerLine(width: 55, height: 10),
      ],
    );
  }
}

class _ProfileMenuSkeleton extends StatelessWidget {
  const _ProfileMenuSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w(context)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ShimmerBox.circle(size: 36.w(context)),
          SB.w(12),
          const Expanded(child: ShimmerLine(width: 160, height: 14)),
          const ShimmerLine(width: 18, height: 18),
        ],
      ),
    );
  }
}
