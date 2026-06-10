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
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/auction_card.dart';
import '../../../../core/widgets/sb.dart';
import '../../../../core/widgets/shimmer_skeletons/skeleton_lists.dart';
import '../../../auctions/domain/entities/auction.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/home_app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refreshHome() async {
    context.read<HomeBloc>().add(const HomeRefreshRequested());
    await Future.delayed(const Duration(milliseconds: 300));
  }

  List<String> _categories(List<Auction> auctions) {
    final categorySet = auctions
        .map((auction) => auction.category.trim())
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();

    categorySet.sort();

    return ['All', ...categorySet];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is HomeError) {
          AppSnackbar.error(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const Column(
                children: [
                  _HomeHeaderSkeleton(),
                  Expanded(child: AuctionCardListSkeleton()),
                ],
              );
            }

            if (state is HomeError) {
              return RefreshIndicator(
                onRefresh: _refreshHome,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  padding: EdgeInsets.all(AppSizes.pagePadding.w(context)),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.32),
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

            final liveAuctions = state.auctions
                .where((auction) => auction.isLive)
                .toList();

            final filteredAuctions = state.selectedCategory == 'All'
                ? liveAuctions
                : liveAuctions
                      .where(
                        (auction) => auction.category == state.selectedCategory,
                      )
                      .toList();

            final categories = liveAuctions.isEmpty
                ? <String>[]
                : _categories(liveAuctions);

            return Column(
              children: [
                HomeAppBar(
                  liveCount: liveAuctions.length,
                  unreadNotificationCount: state.unreadNotificationCount,
                  categories: categories,
                  selectedCategory: state.selectedCategory,
                  onCategorySelected: (category) {
                    context.read<HomeBloc>().add(HomeCategoryChanged(category));
                  },
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refreshHome,
                    child: filteredAuctions.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: ClampingScrollPhysics(),
                            ),
                            padding: EdgeInsets.all(
                              AppSizes.pagePadding.w(context),
                            ),
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                              ),
                              AppEmptyState(
                                icon: AppIcons.search,
                                message: AppStrings.noAuctions,
                              ),
                            ],
                          )
                        : _HomeAuctionList(auctions: filteredAuctions),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HomeAuctionList extends StatelessWidget {
  final List<Auction> auctions;

  const _HomeAuctionList({required this.auctions});

  String _formatPrice(Auction auction) {
    return AppCurrencies.formatAmount(
      code: auction.currencyCode,
      amount: auction.currentBid,
    );
  }

  String _formatRemainingTime(Auction auction) {
    return auction.remainingDuration.formattedCountdown;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.pagePadding.w(context),
        vertical: AppSizes.pagePadding.h(context),
      ),
      physics: const AlwaysScrollableScrollPhysics(
        parent: ClampingScrollPhysics(),
      ),
      itemCount: auctions.length,
      separatorBuilder: (_, _) => SB.h(AppSizes.cardGap),
      itemBuilder: (_, index) {
        final auction = auctions[index];

        return AuctionCard(
          title: auction.title,
          category: auction.category,
          currentBid: _formatPrice(auction),
          timeRemaining: _formatRemainingTime(auction),
          totalBids: auction.totalBids,
          isLive: auction.isLive,
          imageUrl: auction.images.isNotEmpty ? auction.images.first : null,
          onTap: () => context.push('${AppRoutes.auctionDetail}/${auction.id}'),
        );
      },
    );
  }
}

class _HomeHeaderSkeleton extends StatelessWidget {
  const _HomeHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return HomeAppBar(
      liveCount: 0,
      unreadNotificationCount: 0,
      categories: const ['All', 'Loading', 'Loading'],
      selectedCategory: 'All',
      onCategorySelected: (_) {},
    );
  }
}
