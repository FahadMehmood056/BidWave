import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/duration_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/shimmer_skeletons/auction_detail_skeleton.dart';
import '../../../auctions/domain/entities/auction.dart';
import '../bloc/auction_detail_bloc.dart';
import '../bloc/auction_detail_event.dart';
import '../bloc/auction_detail_state.dart';
import '../widgets/auction_detail_content.dart';
import '../widgets/bid_input_bar.dart';

class AuctionDetailPage extends StatefulWidget {
  final String auctionId;

  const AuctionDetailPage({super.key, required this.auctionId});

  @override
  State<AuctionDetailPage> createState() => _AuctionDetailPageState();
}

class _AuctionDetailPageState extends State<AuctionDetailPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatPrice(Auction auction, double amount) {
    return AppCurrencies.formatAmount(
      code: auction.currencyCode,
      amount: amount,
    );
  }

  String _formatRemainingTime(Auction auction) {
    return auction.remainingDuration.formattedCountdown;
  }

  double _minimumBid(Auction auction) {
    if (auction.totalBids == 0) {
      return auction.startingPrice;
    }

    return auction.currentBid + auction.bidIncrement;
  }

  void _submitBid(BuildContext context, String value, Auction auction) {
    final amount = double.tryParse(value.trim());

    if (amount == null || amount <= 0) {
      AppSnackbar.error(context, 'Enter a valid bid amount.');
      return;
    }

    final minimumBid = _minimumBid(auction);

    if (amount < minimumBid) {
      AppSnackbar.error(
        context,
        'Bid must be at least ${_formatPrice(auction, minimumBid)}.',
      );
      return;
    }

    context.read<AuctionDetailBloc>().add(AuctionDetailBidSubmitted(amount));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuctionDetailBloc, AuctionDetailState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          AppSnackbar.error(context, state.errorMessage!);
        }

        if (state.successMessage != null) {
          AppSnackbar.success(context, state.successMessage!);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<AuctionDetailBloc, AuctionDetailState>(
          builder: (context, state) {
            if (state.isLoading && state.auction == null) {
              return const Column(
                children: [
                  AppBackBar(title: AppStrings.liveAuction),
                  Expanded(child: AuctionDetailSkeleton()),
                ],
              );
            }

            final auction = state.auction;

            if (auction == null) {
              return const Column(
                children: [
                  AppBackBar(title: AppStrings.liveAuction),
                  Expanded(child: Center(child: Text('Auction not available'))),
                ],
              );
            }

            final minimumBid = _minimumBid(auction);
            final isAuctionLive =
                auction.isLive && auction.remainingDuration > Duration.zero;

            return Column(
              children: [
                AppBackBar(
                  title: isAuctionLive
                      ? AppStrings.liveAuction
                      : AppStrings.auctionEnded,
                ),
                Expanded(
                  child: AuctionDetailContent(
                    auction: auction,
                    bids: state.bids,
                    currentUserId: state.currentUserId,
                    isAuctionLive: isAuctionLive,
                    timeRemaining: _formatRemainingTime(auction),
                    formatPrice: _formatPrice,
                  ),
                ),
                if (isAuctionLive)
                  BidInputBar(
                    minimumBid: _formatPrice(auction, minimumBid),
                    isLoading: state.isPlacingBid,
                    onBid: (amount) => _submitBid(context, amount, auction),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
