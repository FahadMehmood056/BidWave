import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_shimmer_image.dart';
import '../../../../core/widgets/sb.dart';

class WonAuctionItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String winningBid;
  final VoidCallback? onTap;

  const WonAuctionItem({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.winningBid,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(12.w(context)),
        decoration: BoxDecoration(
          color: AppColors.emeraldLight.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
          border: Border.all(color: AppColors.emerald),
        ),
        child: Row(
          children: [
            _WonItemThumbnail(imageUrl: imageUrl),
            SB.w(12),
            Expanded(child: _WonItemInfo(title: title)),
            SB.w(12),
            _WonItemAmount(winningBid: winningBid),
          ],
        ),
      ),
    );
  }
}

class _WonItemThumbnail extends StatelessWidget {
  final String imageUrl;

  const _WonItemThumbnail({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSizes.radiusButton.w(context));

    if (imageUrl.isEmpty) {
      return Container(
        width: 48.w(context),
        height: 48.w(context),
        decoration: BoxDecoration(
          color: AppColors.emeraldLight,
          borderRadius: radius,
        ),
        child: Icon(
          AppIcons.trophy,
          size: 22.w(context),
          color: AppColors.emeraldDark,
        ),
      );
    }

    return AppShimmerImage(
      imageUrl: imageUrl,
      width: 48.w(context),
      height: 48.w(context),
      borderRadius: radius,
      errorWidget: Container(
        width: 48.w(context),
        height: 48.w(context),
        decoration: BoxDecoration(
          color: AppColors.emeraldLight,
          borderRadius: radius,
        ),
        child: Icon(
          AppIcons.trophy,
          size: 22.w(context),
          color: AppColors.emeraldDark,
        ),
      ),
    );
  }
}

class _WonItemInfo extends StatelessWidget {
  final String title;

  const _WonItemInfo({required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.titleMedium.responsive(context),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SB.h(4),
        Row(
          children: [
            Container(
              width: 8.w(context),
              height: 8.w(context),
              decoration: const BoxDecoration(
                color: AppColors.emerald,
                shape: BoxShape.circle,
              ),
            ),
            SB.w(6),
            Text(
              AppStrings.won,
              style: AppTextStyles.labelMedium
                  .responsive(context)
                  .copyWith(
                    color: AppColors.emeraldDark,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WonItemAmount extends StatelessWidget {
  final String winningBid;

  const _WonItemAmount({required this.winningBid});

  @override
  Widget build(BuildContext context) {
    return Text(
      winningBid,
      style: AppTextStyles.titleMedium
          .responsive(context)
          .copyWith(color: AppColors.emeraldDark),
    );
  }
}
