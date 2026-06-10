import 'package:flutter/material.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';

class AntiSnipeBanner extends StatelessWidget {
  const AntiSnipeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 10.w(context),
        horizontal: 12.w(context),
      ),
      decoration: BoxDecoration(
        color: AppColors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusButton.w(context)),
        border: Border.all(color: AppColors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(AppIcons.shield, size: 18.w(context), color: AppColors.amber),
          SB.w(8),
          Expanded(
            child: Text(
              AppStrings.antiSnipeInfo,
              style: AppTextStyles.labelMedium
                  .responsive(context)
                  .copyWith(color: AppColors.amber),
            ),
          ),
        ],
      ),
    );
  }
}
