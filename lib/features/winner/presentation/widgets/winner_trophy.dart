import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';

class WinnerTrophy extends StatelessWidget {
  final String itemTitle;
  final int totalBids;

  const WinnerTrophy({
    super.key,
    required this.itemTitle,
    required this.totalBids,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90.w(context),
          height: 90.w(context),
          decoration: const BoxDecoration(
            color: AppColors.emeraldLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            AppIcons.trophyFilled,
            size: 44.w(context),
            color: AppColors.emerald,
          ),
        ),
        SB.h(16),
        Text(
          AppStrings.auctionEndedBanner,
          style: AppTextStyles.headlineMedium.responsive(context),
        ),
        SB.h(4),
        Text(
          '$itemTitle · $totalBids ${AppStrings.bids.toLowerCase()}',
          style: AppTextStyles.labelLarge.responsive(context),
        ),
      ],
    );
  }
}
