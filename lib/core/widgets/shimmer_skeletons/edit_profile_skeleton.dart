import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../../extensions/responsive_extension.dart';
import '../../theme/app_colors.dart';
import '../app_shimmer.dart';
import '../sb.dart';

class EditProfileSkeleton extends StatelessWidget {
  const EditProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.pagePadding.w(context),
      ),
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          SB.h(32),
          ShimmerBox.circle(size: 90.w(context)),
          SB.h(32),
          const _TextFieldSkeleton(),
          SB.h(16),
          const _TextFieldSkeleton(),
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

class _TextFieldSkeleton extends StatelessWidget {
  const _TextFieldSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.w(context),
      padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusButton.w(context)),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          ShimmerBox.circle(size: 22.w(context)),
          SB.w(12),
          const Expanded(child: ShimmerLine(width: 180, height: 14)),
        ],
      ),
    );
  }
}
