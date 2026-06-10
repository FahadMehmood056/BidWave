import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loader.dart';

class SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.w(context),
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.card,
          side: BorderSide(color: AppColors.muted.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppSizes.radiusButton.w(context),
            ),
          ),
        ),
        child: isLoading
            ? const AppLoader(color: AppColors.emerald)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  SizedBox(width: 12.w(context)),
                  Text(
                    label,
                    style: AppTextStyles.titleMedium
                        .responsive(context)
                        .copyWith(color: AppColors.text),
                  ),
                ],
              ),
      ),
    );
  }
}
