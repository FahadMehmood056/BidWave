import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../extensions/responsive_extension.dart';
import '../extensions/text_style_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_loader.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(
      AppSizes.radiusButton.w(context),
    );

    return SizedBox(
      width: double.infinity,
      height: 52.w(context),
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.emerald),
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
              ),
              child: _buildChild(context),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.emerald,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
              ),
              child: _buildChild(context),
            ),
    );
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return const AppLoader(color: AppColors.white);
    }
    return Text(
      text,
      style: AppTextStyles.titleMedium
          .responsive(context)
          .copyWith(color: isOutlined ? AppColors.emerald : AppColors.white),
    );
  }
}
