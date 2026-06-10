import 'package:flutter/material.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';

class BidHistoryItem extends StatelessWidget {
  final String initials;
  final String name;
  final String amount;
  final bool isHighest;

  const BidHistoryItem({
    super.key,
    required this.initials,
    required this.name,
    required this.amount,
    this.isHighest = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.w(context)),
      child: Row(
        children: [
          Container(
            width: 36.w(context),
            height: 36.w(context),
            decoration: BoxDecoration(
              color: isHighest ? AppColors.emeraldLight : AppColors.charcoal,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: AppTextStyles.labelMedium
                    .responsive(context)
                    .copyWith(
                      color: isHighest
                          ? AppColors.emeraldDark
                          : AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          SB.w(12),
          Expanded(
            child: Text(
              name,
              style: AppTextStyles.titleSmall.responsive(context),
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.titleSmall
                .responsive(context)
                .copyWith(
                  color: isHighest ? AppColors.emeraldDark : AppColors.text,
                ),
          ),
        ],
      ),
    );
  }
}
