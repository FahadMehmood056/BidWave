import 'package:flutter/material.dart';
import '../constants/app_icons.dart';
import '../extensions/responsive_extension.dart';
import '../theme/app_colors.dart';

class AppImagePlaceholder extends StatelessWidget {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const AppImagePlaceholder({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: borderRadius,
      ),
      child: Icon(AppIcons.image, size: 32.w(context), color: AppColors.muted),
    );
  }
}
