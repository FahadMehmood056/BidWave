import 'package:flutter/material.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';

class DetailInfoSection extends StatelessWidget {
  final String category;
  final String title;

  const DetailInfoSection({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(category, style: AppTextStyles.labelLarge.responsive(context)),
        SB.h(4),
        Text(title, style: AppTextStyles.headlineMedium.responsive(context)),
      ],
    );
  }
}
