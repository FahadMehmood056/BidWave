import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/sb.dart';
import '../../../../core/widgets/shimmer_skeletons/skeleton_lists.dart';
import '../bloc/won_auctions_bloc/won_auctions_bloc.dart';
import '../bloc/won_auctions_bloc/won_auctions_state.dart';
import '../widgets/won_auction_item.dart';

class WonAuctionsPage extends StatelessWidget {
  const WonAuctionsPage({super.key});

  String _formatAmount(String currencyCode, double amount) {
    return '$currencyCode ${amount.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppBackBar(title: AppStrings.wonAuctions),
          Expanded(
            child: BlocBuilder<WonAuctionsBloc, WonAuctionsState>(
              builder: (context, state) {
                if (state is WonAuctionsInitial ||
                    state is WonAuctionsLoading) {
                  return const AuctionListSkeleton();
                }

                if (state is WonAuctionsError) {
                  return AppEmptyState(
                    icon: AppIcons.trophy,
                    message: state.message,
                  );
                }

                if (state is! WonAuctionsLoaded) {
                  return const SizedBox.shrink();
                }

                if (state.wonAuctions.isEmpty) {
                  return const AppEmptyState(
                    icon: AppIcons.trophy,
                    message: AppStrings.noWonAuctions,
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.all(AppSizes.pagePadding.w(context)),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  itemCount: state.wonAuctions.length,
                  separatorBuilder: (_, _) => SB.h(AppSizes.cardGap),
                  itemBuilder: (_, index) {
                    final auction = state.wonAuctions[index];

                    return WonAuctionItem(
                      title: auction.title,
                      imageUrl: auction.imageUrl,
                      winningBid: _formatAmount(
                        auction.currencyCode,
                        auction.currentBid,
                      ),
                      onTap: () => context.push(
                        '${AppRoutes.winner}/${auction.auctionId}',
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
