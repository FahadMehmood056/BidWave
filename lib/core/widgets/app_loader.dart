import 'package:flutter/material.dart';
import '../extensions/responsive_extension.dart';
import '../theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const AppLoader({
    super.key,
    this.size = 20,
    this.color = AppColors.emerald,
    this.strokeWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size.w(context),
      width: size.w(context),
      child: CircularProgressIndicator(strokeWidth: strokeWidth, color: color),
    );
  }
}
