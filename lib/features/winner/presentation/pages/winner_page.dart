import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/contact_helper.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/sb.dart';
import '../../../../core/widgets/shimmer_skeletons/winner_skeleton.dart';
import '../bloc/winner_bloc/winner_bloc.dart';
import '../bloc/winner_bloc/winner_state.dart';
import '../widgets/winner_details.dart';
import '../widgets/winner_trophy.dart';

class WinnerPage extends StatelessWidget {
  final String auctionId;

  const WinnerPage({super.key, required this.auctionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const AppBackBar(title: AppStrings.auctionEnded),
          Expanded(
            child: BlocBuilder<WinnerBloc, WinnerState>(
              builder: (context, state) {
                if (state is WinnerInitial || state is WinnerLoading) {
                  return const WinnerSkeleton();
                }

                if (state is WinnerError) {
                  return AppEmptyState(
                    icon: Icons.error_outline,
                    message: state.message,
                  );
                }

                if (state is! WinnerLoaded) {
                  return const SizedBox.shrink();
                }

                final detail = state.detail;

                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.pagePadding.w(context),
                  ),
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  child: Column(
                    children: [
                      SB.h(40),
                      WinnerTrophy(
                        itemTitle: detail.title,
                        totalBids: detail.totalBids,
                      ),
                      SB.h(32),
                      WinnerDetails(
                        sellerName: detail.sellerName,
                        sellerPhone: detail.sellerPhone,
                        winningBid: detail.winningBidText,
                      ),
                      SB.h(32),
                      AppButton(
                        text: AppStrings.contactSeller,
                        onPressed: detail.sellerPhone.isEmpty
                            ? null
                            : () async {
                                final success = await ContactHelper.callPhone(
                                  detail.sellerPhone,
                                );

                                if (!context.mounted) return;

                                if (!success) {
                                  AppSnackbar.error(
                                    context,
                                    'Could not open phone dialer.',
                                  );
                                }
                              },
                      ),
                      SB.h(24),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
