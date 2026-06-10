import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/sb.dart';
import '../../../../core/widgets/shimmer_skeletons/skeleton_lists.dart';
import '../../domain/entities/my_bid.dart';
import '../bloc/my_bids_bloc.dart';
import '../bloc/my_bids_event.dart';
import '../bloc/my_bids_state.dart';
import '../widgets/bid_list_item.dart';
import '../widgets/my_bids_header.dart';

class MyBidsPage extends StatelessWidget {
  const MyBidsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<MyBidsBloc, MyBidsState>(
      listener: (context, state) {
        if (state is MyBidsError) {
          final message = state.message.toLowerCase();

          final isAuthLogoutError =
              message.contains('not logged in') ||
              message.contains('unauthenticated') ||
              message.contains('logged out');

          if (isAuthLogoutError) return;

          AppSnackbar.error(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<MyBidsBloc, MyBidsState>(
          builder: (context, state) {
            final winningCount = state is MyBidsLoaded ? state.winningCount : 0;
            final losingCount = state is MyBidsLoaded ? state.losingCount : 0;

            return Column(
              children: [
                MyBidsHeader(
                  winningCount: winningCount,
                  losingCount: losingCount,
                ),
                Expanded(child: _MyBidsBody(state: state)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MyBidsBody extends StatelessWidget {
  final MyBidsState state;

  const _MyBidsBody({required this.state});

  Future<void> _refresh(BuildContext context) async {
    context.read<MyBidsBloc>().add(const MyBidsRefreshRequested());
    await Future.delayed(const Duration(milliseconds: 300));
  }

  String _formatPrice(MyBid bid) {
    return AppCurrencies.formatAmount(
      code: bid.currencyCode,
      amount: bid.currentBid,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (state is MyBidsInitial || state is MyBidsLoading) {
      return const AuctionListSkeleton();
    }

    if (state is MyBidsError) {
      final errorState = state as MyBidsError;

      return RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          padding: EdgeInsets.all(AppSizes.pagePadding.w(context)),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            AppEmptyState(icon: AppIcons.myBids, message: errorState.message),
          ],
        ),
      );
    }

    if (state is! MyBidsLoaded) {
      return const SizedBox.shrink();
    }

    final loadedState = state as MyBidsLoaded;

    if (loadedState.bids.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: ClampingScrollPhysics(),
          ),
          padding: EdgeInsets.all(AppSizes.pagePadding.w(context)),
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            const AppEmptyState(
              icon: AppIcons.myBids,
              message: AppStrings.noBidsPlaced,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: ListView.separated(
        padding: EdgeInsets.all(AppSizes.pagePadding.w(context)),
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        itemCount: loadedState.bids.length,
        separatorBuilder: (_, _) => SB.h(AppSizes.cardGap),
        itemBuilder: (_, index) {
          final bid = loadedState.bids[index];

          return BidListItem(
            title: bid.title,
            currentBid: _formatPrice(bid),
            imageUrl: bid.imageUrl,
            isWinning: bid.isWinning,
            onTap: () =>
                context.push('${AppRoutes.auctionDetail}/${bid.auctionId}'),
          );
        },
      ),
    );
  }
}
