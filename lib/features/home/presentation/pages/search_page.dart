import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/duration_extension.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/auction_card.dart';
import '../../../../core/widgets/sb.dart';
import '../../../../core/widgets/shimmer_skeletons/skeleton_lists.dart';
import '../../../auctions/domain/entities/auction.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  Timer? _timer;
  String _query = '';

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppBackBar(title: 'Search Auctions'),
          SB.h(20),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.pagePadding.w(context),
            ),
            child: AppTextField(
              controller: _searchController,
              hint: 'Search by title or category',
              showBorder: true,
              onChanged: (value) {
                setState(() => _query = value);
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeInitial || state is HomeLoading) {
                  return const AuctionCardListSkeleton();
                }
                if (state is HomeError) {
                  return RefreshIndicator(
                    onRefresh: _refreshSearch,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(AppSizes.pagePadding.w(context)),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.28,
                        ),
                        AppEmptyState(
                          icon: AppIcons.search,
                          message: state.message,
                        ),
                      ],
                    ),
                  );
                }

                if (state is! HomeLoaded) {
                  return const SizedBox.shrink();
                }

                final results = _filterAuctions(state.auctions);

                if (results.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _refreshSearch,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.all(AppSizes.pagePadding.w(context)),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                        AppEmptyState(
                          icon: AppIcons.search,
                          message: _query.trim().isEmpty
                              ? AppStrings.noAuctions
                              : 'No matching auctions found.',
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _refreshSearch,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.pagePadding.w(context),
                      vertical: AppSizes.pagePadding.h(context),
                    ),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemCount: results.length,
                    separatorBuilder: (_, _) => SB.h(AppSizes.cardGap),
                    itemBuilder: (_, index) {
                      final auction = results[index];

                      return AuctionCard(
                        title: auction.title,
                        category: auction.category,
                        currentBid: AppCurrencies.formatAmount(
                          code: auction.currencyCode,
                          amount: auction.currentBid,
                        ),
                        timeRemaining:
                            auction.remainingDuration.formattedCountdown,
                        totalBids: auction.totalBids,
                        isLive: auction.isLive,
                        imageUrl: auction.images.isNotEmpty
                            ? auction.images.first
                            : null,
                        onTap: () => context.push(
                          '${AppRoutes.auctionDetail}/${auction.id}',
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Auction> _filterAuctions(List<Auction> auctions) {
    final query = _query.trim().toLowerCase();

    final liveAuctions = auctions.where((auction) => auction.isLive).toList();

    if (query.isEmpty) return liveAuctions;

    return liveAuctions.where((auction) {
      final title = auction.title.toLowerCase();
      final category = auction.category.toLowerCase();

      return title.contains(query) || category.contains(query);
    }).toList();
  }

  Future<void> _refreshSearch() async {
    context.read<HomeBloc>().add(const HomeRefreshRequested());
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
