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

class BidListItem extends StatelessWidget {
  final String title;
  final String currentBid;
  final String? imageUrl;
  final bool isWinning;
  final VoidCallback? onTap;

  const BidListItem({
    super.key,
    required this.title,
    required this.currentBid,
    this.imageUrl,
    required this.isWinning,
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
          color: isWinning
              ? AppColors.emeraldLight.withValues(alpha: 0.3)
              : AppColors.red.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
          border: Border.all(
            color: isWinning
                ? AppColors.emerald
                : AppColors.red.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            _BidThumbnail(imageUrl: imageUrl, isWinning: isWinning),
            SB.w(12),
            Expanded(
              child: _BidInfo(title: title, isWinning: isWinning),
            ),
            SB.w(12),
            _BidAmount(currentBid: currentBid, isWinning: isWinning),
          ],
        ),
      ),
    );
  }
}

class _BidThumbnail extends StatelessWidget {
  final String? imageUrl;
  final bool isWinning;

  const _BidThumbnail({required this.imageUrl, required this.isWinning});

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSizes.radiusButton.w(context));

    return AppShimmerImage(
      imageUrl: imageUrl,
      width: 48.w(context),
      height: 48.w(context),
      borderRadius: radius,
      errorWidget: _ImagePlaceholder(isWinning: isWinning),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final bool isWinning;

  const _ImagePlaceholder({required this.isWinning});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w(context),
      height: 48.w(context),
      color: isWinning
          ? AppColors.emeraldLight
          : AppColors.red.withValues(alpha: 0.1),
      child: Icon(
        AppIcons.image,
        size: 22.w(context),
        color: isWinning ? AppColors.emeraldDark : AppColors.red,
      ),
    );
  }
}

class _BidInfo extends StatelessWidget {
  final String title;
  final bool isWinning;

  const _BidInfo({required this.title, required this.isWinning});

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
              decoration: BoxDecoration(
                color: isWinning ? AppColors.emerald : AppColors.red,
                shape: BoxShape.circle,
              ),
            ),
            SB.w(6),
            Text(
              isWinning ? AppStrings.winning : AppStrings.outbid,
              style: AppTextStyles.labelMedium
                  .responsive(context)
                  .copyWith(
                    color: isWinning ? AppColors.emeraldDark : AppColors.red,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BidAmount extends StatelessWidget {
  final String currentBid;
  final bool isWinning;

  const _BidAmount({required this.currentBid, required this.isWinning});

  @override
  Widget build(BuildContext context) {
    return Text(
      currentBid,
      style: AppTextStyles.titleMedium
          .responsive(context)
          .copyWith(color: isWinning ? AppColors.emeraldDark : AppColors.text),
    );
  }
}
