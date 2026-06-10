import 'package:flutter/material.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.muted.withValues(alpha: 0.3))),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
          child: Text(
            AppStrings.orContinueWith,
            style: AppTextStyles.labelLarge.responsive(context),
          ),
        ),
        Expanded(child: Divider(color: AppColors.muted.withValues(alpha: 0.3))),
      ],
    );
  }
}
