import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';

class TimerSection extends StatelessWidget {
  final String timeRemaining;

  const TimerSection({super.key, required this.timeRemaining});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 20.w(context),
        horizontal: 16.w(context),
      ),
      decoration: BoxDecoration(
        color: AppColors.charcoal,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
      ),
      child: Column(
        children: [
          Text(
            timeRemaining,
            style: TextStyle(
              fontSize: 36.sp(context),
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              letterSpacing: 2,
            ),
          ),
          SB.h(4),
          Text(
            AppStrings.timeRemaining,
            style: AppTextStyles.labelLarge
                .responsive(context)
                .copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
