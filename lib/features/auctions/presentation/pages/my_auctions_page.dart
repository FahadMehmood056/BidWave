import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/sb.dart';
import '../../../../core/widgets/shimmer_skeletons/skeleton_lists.dart';
import '../../../auctions/domain/entities/auction.dart';
import '../bloc/my_auction_bloc/my_auctions_bloc.dart';
import '../bloc/my_auction_bloc/my_auctions_event.dart';
import '../bloc/my_auction_bloc/my_auctions_state.dart';
import '../widgets/auction_list_item.dart';

class MyAuctionsPage extends StatefulWidget {
  const MyAuctionsPage({super.key});

  @override
  State<MyAuctionsPage> createState() => _MyAuctionsPageState();
}

class _MyAuctionsPageState extends State<MyAuctionsPage> {
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyAuctionsBloc, MyAuctionsState>(
      listener: (context, state) {
        if (state is MyAuctionsError) {
          AppSnackbar.error(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const AppBackBar(title: 'My Auctions'),
            Expanded(
              child: BlocBuilder<MyAuctionsBloc, MyAuctionsState>(
                builder: (context, state) {
                  if (state is MyAuctionsInitial ||
                      state is MyAuctionsLoading) {
                    return const AuctionListSkeleton();
                  }

                  if (state is MyAuctionsError) {
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: ClampingScrollPhysics(),
                        ),
                        padding: EdgeInsets.all(
                          AppSizes.pagePadding.w(context),
                        ),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.32,
                          ),
                          AppEmptyState(
                            icon: AppIcons.search,
                            message: state.message,
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is! MyAuctionsLoaded) {
                    return const SizedBox.shrink();
                  }

                  if (state.auctions.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: ClampingScrollPhysics(),
                        ),
                        padding: EdgeInsets.all(
                          AppSizes.pagePadding.w(context),
                        ),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.28,
                          ),
                          const AppEmptyState(
                            icon: AppIcons.search,
                            message: 'You have not posted any auctions yet.',
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: ClampingScrollPhysics(),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSizes.pagePadding.w(context),
                        vertical: AppSizes.pagePadding.h(context),
                      ),
                      children: [
                        if (state.liveAuctions.isNotEmpty) ...[
                          _SectionTitle(title: 'Live Auctions'),
                          SB.h(12),
                          ..._auctionCards(state.liveAuctions),
                        ],
                        if (state.endedAuctions.isNotEmpty) ...[
                          SB.h(20),
                          _SectionTitle(title: 'Ended Auctions'),
                          SB.h(12),
                          ..._auctionCards(state.endedAuctions),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    context.read<MyAuctionsBloc>().add(const MyAuctionsRefreshRequested());
    await Future.delayed(const Duration(milliseconds: 300));
  }

  AuctionListStatus _auctionStatus(Auction auction) {
    if (auction.isLive) {
      return AuctionListStatus.live;
    }

    if (auction.winnerId != null && auction.winnerId!.isNotEmpty) {
      return AuctionListStatus.sold;
    }

    if (auction.totalBids == 0) {
      return AuctionListStatus.noBids;
    }

    return AuctionListStatus.ended;
  }

  List<Widget> _auctionCards(List<Auction> auctions) {
    final widgets = <Widget>[];

    for (final auction in auctions) {
      widgets.add(
        AuctionListItem(
          title: auction.title,
          totalBids: auction.totalBids,
          currentBid: AppCurrencies.formatAmount(
            code: auction.currencyCode,
            amount: auction.currentBid,
          ),
          imageUrl: auction.images.isNotEmpty ? auction.images.first : null,
          status: _auctionStatus(auction),
          onTap: () => context.push('${AppRoutes.auctionDetail}/${auction.id}'),
        ),
      );

      widgets.add(SB.h(AppSizes.cardGap));
    }

    return widgets;
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: AppColors.text,
      ),
    );
  }
}
