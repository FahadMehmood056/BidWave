import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';

class WinnerDetails extends StatelessWidget {
  final String sellerName;
  final String sellerPhone;
  final String winningBid;

  const WinnerDetails({
    super.key,
    required this.sellerName,
    required this.sellerPhone,
    required this.winningBid,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w(context)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _DetailRow(label: 'Seller', value: sellerName),
          SB.h(16),
          Container(height: 1, color: AppColors.border),
          SB.h(16),
          _DetailRow(
            label: 'Seller phone',
            value: sellerPhone.isEmpty ? 'Not available' : sellerPhone,
          ),
          SB.h(16),
          Container(height: 1, color: AppColors.border),
          SB.h(16),
          _DetailRow(
            label: AppStrings.winningBid,
            value: winningBid,
            valueColor: AppColors.emeraldDark,
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.labelLarge.responsive(context)),
        SB.h(4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineLarge
              .responsive(context)
              .copyWith(color: valueColor ?? AppColors.text),
        ),
      ],
    );
  }
}
