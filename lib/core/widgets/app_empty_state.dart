import 'package:flutter/material.dart';
import '../extensions/responsive_extension.dart';
import '../extensions/text_style_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'sb.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const AppEmptyState({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48.w(context), color: AppColors.muted),
          SB.h(16),
          Text(
            message,
            style: AppTextStyles.labelLarge.responsive(context),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
