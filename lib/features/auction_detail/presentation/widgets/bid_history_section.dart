import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';
import '../../../auctions/domain/entities/auction.dart';
import '../../domain/entities/bid.dart';
import 'bid_history_item.dart';

class BidHistorySection extends StatelessWidget {
  final Auction auction;
  final List<Bid> bids;
  final String? currentUserId;
  final String Function(Auction auction, double amount) formatPrice;

  const BidHistorySection({
    super.key,
    required this.auction,
    required this.bids,
    required this.currentUserId,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    if (bids.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.bidHistory,
            style: AppTextStyles.titleLarge.responsive(context),
          ),
          SB.h(8),
          Text(
            'No bids yet',
            style: AppTextStyles.labelLarge.responsive(context),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.bidHistory,
          style: AppTextStyles.titleLarge.responsive(context),
        ),
        SB.h(8),
        ...List.generate(bids.length, (index) {
          final bid = bids[index];
          final isMyBid = bid.bidderId == currentUserId;

          return BidHistoryItem(
            initials: isMyBid ? 'Y' : bid.initials,
            name: isMyBid ? 'You' : bid.bidderName,
            amount: formatPrice(auction, bid.amount),
            isHighest: index == 0,
          );
        }),
      ],
    );
  }
}
