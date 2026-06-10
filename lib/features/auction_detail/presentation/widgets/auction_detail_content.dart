import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/widgets/sb.dart';
import '../../../../core/widgets/stat_item.dart';
import '../../../../core/widgets/stats_row.dart';
import '../../../auctions/domain/entities/auction.dart';
import '../../domain/entities/bid.dart';
import 'anti_snipe_banner.dart';
import 'bid_history_section.dart';
import 'detail_image_section.dart';
import 'detail_info_section.dart';
import 'ended_auction_result_card.dart';
import 'timer_section.dart';

class AuctionDetailContent extends StatelessWidget {
  final Auction auction;
  final List<Bid> bids;
  final String? currentUserId;
  final bool isAuctionLive;
  final String timeRemaining;
  final String Function(Auction auction, double amount) formatPrice;

  const AuctionDetailContent({
    super.key,
    required this.auction,
    required this.bids,
    required this.currentUserId,
    required this.isAuctionLive,
    required this.timeRemaining,
    required this.formatPrice,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailImageSection(images: auction.images, isLive: isAuctionLive),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.pagePadding.w(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SB.h(16),
                DetailInfoSection(
                  category: auction.category,
                  title: auction.title,
                ),
                SB.h(16),
                TimerSection(timeRemaining: timeRemaining),
                SB.h(12),
                if (isAuctionLive) ...[
                  const AntiSnipeBanner(),
                  SB.h(16),
                ] else ...[
                  EndedAuctionResultCard(
                    auction: auction,
                    currentUserId: currentUserId,
                    formatPrice: formatPrice,
                  ),
                  SB.h(16),
                ],
                StatsRow(
                  stats: [
                    StatItem(
                      value: formatPrice(auction, auction.currentBid),
                      label: AppStrings.current,
                    ),
                    StatItem(
                      value: '${auction.totalBids}',
                      label: AppStrings.bids,
                    ),
                  ],
                ),
                SB.h(24),
                BidHistorySection(
                  auction: auction,
                  bids: bids,
                  currentUserId: currentUserId,
                  formatPrice: formatPrice,
                ),
                SB.h(16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
