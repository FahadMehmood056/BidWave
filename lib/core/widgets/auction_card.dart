import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../constants/app_strings.dart';
import '../extensions/responsive_extension.dart';
import '../extensions/text_style_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_shimmer_image.dart';
import 'sb.dart';

class AuctionCard extends StatelessWidget {
  final String title;
  final String category;
  final String currentBid;
  final String timeRemaining;
  final int totalBids;
  final bool isLive;
  final String? imageUrl;
  final VoidCallback? onTap;

  const AuctionCard({
    super.key,
    required this.title,
    required this.category,
    required this.currentBid,
    required this.timeRemaining,
    required this.totalBids,
    this.isLive = true,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),
            _buildContentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAuctionImage(BuildContext context) {
    final radius = BorderRadius.only(
      topLeft: Radius.circular(AppSizes.radiusCard.w(context)),
      topRight: Radius.circular(AppSizes.radiusCard.w(context)),
    );

    return AppShimmerImage(
      imageUrl: imageUrl,
      height: 140.w(context),
      width: double.infinity,
      borderRadius: radius,
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Stack(
      children: [
        _buildAuctionImage(context),
        if (isLive)
          Positioned(
            top: 8.w(context),
            left: 8.w(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.w(context),
                vertical: 4.w(context),
              ),
              decoration: BoxDecoration(
                color: AppColors.emeraldLight,
                borderRadius: BorderRadius.circular(
                  AppSizes.radiusPill.w(context),
                ),
                border: Border.all(color: AppColors.emerald),
              ),
              child: Text(
                AppStrings.live,
                style: AppTextStyles.labelMedium
                    .responsive(context)
                    .copyWith(
                      color: AppColors.emeraldDark,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        Positioned(
          bottom: 8.w(context),
          right: 8.w(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 8.w(context),
              vertical: 4.w(context),
            ),
            decoration: BoxDecoration(
              color: AppColors.charcoal.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(
                AppSizes.radiusPill.w(context),
              ),
            ),
            child: Text(
              '$totalBids',
              style: AppTextStyles.labelMedium
                  .responsive(context)
                  .copyWith(color: AppColors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContentSection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSizes.paddingSmall.w(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category, style: AppTextStyles.labelMedium.responsive(context)),
          SB.h(4),
          Text(
            title,
            style: AppTextStyles.titleLarge.responsive(context),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SB.h(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentBid,
                style: AppTextStyles.headlineLarge
                    .responsive(context)
                    .copyWith(color: AppColors.text),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w(context),
                  vertical: 4.w(context),
                ),
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    AppSizes.radiusPill.w(context),
                  ),
                ),
                child: Text(
                  timeRemaining,
                  style: AppTextStyles.titleSmall
                      .responsive(context)
                      .copyWith(color: AppColors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
