import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';
import '../../../auctions/domain/entities/auction.dart';

class EndedAuctionResultCard extends StatelessWidget {
  final Auction auction;
  final String? currentUserId;
  final String Function(Auction auction, double amount) formatPrice;

  const EndedAuctionResultCard({
    super.key,
    required this.auction,
    required this.currentUserId,
    required this.formatPrice,
  });

  bool get _hasWinner {
    return auction.winnerId != null && auction.winnerId!.isNotEmpty;
  }

  bool get _isWinner {
    return _hasWinner && auction.winnerId == currentUserId;
  }

  bool get _isSeller {
    return auction.sellerId == currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    final title = _title;
    final message = _message;
    final color = _color;
    final backgroundColor = _backgroundColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w(context)),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.titleLarge
                .responsive(context)
                .copyWith(color: color, fontWeight: FontWeight.w700),
          ),
          SB.h(6),
          Text(message, style: AppTextStyles.labelLarge.responsive(context)),
          if (_hasWinner) ...[
            SB.h(14),
            Container(height: 1, color: AppColors.border),
            SB.h(14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Final bid',
                  style: AppTextStyles.labelLarge.responsive(context),
                ),
                Text(
                  formatPrice(auction, auction.currentBid),
                  style: AppTextStyles.titleLarge
                      .responsive(context)
                      .copyWith(
                        color: AppColors.emeraldDark,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String get _title {
    if (_isWinner) {
      return 'You won this auction';
    }

    if (_isSeller && _hasWinner) {
      return 'Auction sold';
    }

    if (_isSeller && !_hasWinner) {
      return 'Auction ended with no bids';
    }

    if (_hasWinner) {
      return 'Auction ended';
    }

    return 'Auction ended';
  }

  String get _message {
    if (_isWinner) {
      return 'Congratulations! You are the winner. Open your Won Auctions page to contact the seller.';
    }

    if (_isSeller && _hasWinner) {
      return 'Your auction ended successfully with a winning bid.';
    }

    if (_isSeller && !_hasWinner) {
      return 'This auction ended without receiving any bids.';
    }

    if (_hasWinner) {
      return 'This auction has ended with a winning bid.';
    }

    return 'This auction has ended.';
  }

  Color get _color {
    if (_isWinner || (_isSeller && _hasWinner)) {
      return AppColors.emeraldDark;
    }

    if (_isSeller && !_hasWinner) {
      return AppColors.red;
    }

    return AppColors.muted;
  }

  Color get _backgroundColor {
    if (_isWinner || (_isSeller && _hasWinner)) {
      return AppColors.emeraldLight.withValues(alpha: 0.45);
    }

    if (_isSeller && !_hasWinner) {
      return AppColors.red.withValues(alpha: 0.08);
    }

    return AppColors.card;
  }
}
