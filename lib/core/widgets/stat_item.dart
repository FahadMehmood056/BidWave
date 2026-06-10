import 'package:flutter/material.dart';
import '../extensions/text_style_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'sb.dart';

class StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color? valueColor;
  final Color? labelColor;

  const StatItem({
    super.key,
    required this.value,
    required this.label,
    this.valueColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTextStyles.headlineLarge
              .responsive(context)
              .copyWith(color: valueColor ?? AppColors.text),
        ),
        SB.h(4),
        Text(
          label,
          style: AppTextStyles.labelLarge
              .responsive(context)
              .copyWith(color: labelColor ?? AppColors.muted),
        ),
      ],
    );
  }
}
