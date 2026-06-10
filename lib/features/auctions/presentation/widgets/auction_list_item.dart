import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_shimmer_image.dart';
import '../../../../core/widgets/sb.dart';

enum AuctionListStatus { live, sold, noBids, ended }

class AuctionListItem extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final int totalBids;
  final String currentBid;
  final AuctionListStatus status;
  final VoidCallback? onTap;

  const AuctionListItem({
    super.key,
    this.imageUrl,
    required this.title,
    required this.totalBids,
    required this.currentBid,
    required this.status,
    this.onTap,
  });

  bool get isLive => status == AuctionListStatus.live;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(12.w(context)),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            _buildThumbnail(context),
            SB.w(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.responsive(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SB.h(4),
                  Text(
                    '$totalBids ${AppStrings.bids.toLowerCase()}',
                    style: AppTextStyles.labelMedium.responsive(context),
                  ),
                ],
              ),
            ),
            SB.w(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currentBid,
                  style: AppTextStyles.titleMedium
                      .responsive(context)
                      .copyWith(
                        color: isLive ? AppColors.text : AppColors.muted,
                      ),
                ),
                SB.h(4),
                _buildStatusBadge(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    final radius = BorderRadius.circular(AppSizes.radiusButton.w(context));

    return AppShimmerImage(
      imageUrl: imageUrl,
      width: 48.w(context),
      height: 48.w(context),
      borderRadius: radius,
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final label = _statusLabel;
    final color = _statusColor;
    final backgroundColor = _statusBackgroundColor;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w(context),
        vertical: 3.w(context),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill.w(context)),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelMedium
            .responsive(context)
            .copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }

  String get _statusLabel {
    switch (status) {
      case AuctionListStatus.live:
        return AppStrings.live;
      case AuctionListStatus.sold:
        return 'Sold';
      case AuctionListStatus.noBids:
        return 'No bids';
      case AuctionListStatus.ended:
        return AppStrings.ended;
    }
  }

  Color get _statusColor {
    switch (status) {
      case AuctionListStatus.live:
        return AppColors.emeraldDark;
      case AuctionListStatus.sold:
        return AppColors.emeraldDark;
      case AuctionListStatus.noBids:
        return AppColors.red;
      case AuctionListStatus.ended:
        return AppColors.muted;
    }
  }

  Color get _statusBackgroundColor {
    switch (status) {
      case AuctionListStatus.live:
        return AppColors.emeraldLight;
      case AuctionListStatus.sold:
        return AppColors.emeraldLight;
      case AuctionListStatus.noBids:
        return AppColors.red.withValues(alpha: 0.1);
      case AuctionListStatus.ended:
        return AppColors.muted.withValues(alpha: 0.12);
    }
  }
}
