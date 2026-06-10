import 'package:flutter/material.dart';
import '../extensions/responsive_extension.dart';
import '../theme/app_colors.dart';

class AppAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  const AppAvatar({
    super.key,
    required this.initials,
    this.size = 80,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.w(context),
      height: size.w(context),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.emerald,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: (size * 0.35).sp(context),
            fontWeight: FontWeight.w700,
            color: textColor ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}
