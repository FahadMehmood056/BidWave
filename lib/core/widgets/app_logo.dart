import 'package:flutter/material.dart';
import '../constants/app_icons.dart';
import '../constants/app_strings.dart';
import '../extensions/responsive_extension.dart';
import '../extensions/text_style_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'sb.dart';

class AppLogo extends StatelessWidget {
  final double iconSize;
  final double circleSize;
  final bool showTagline;
  final bool darkBackground;

  const AppLogo({
    super.key,
    this.iconSize = 48,
    this.circleSize = 100,
    this.showTagline = true,
    this.darkBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = darkBackground ? AppColors.white : AppColors.text;

    return Hero(
      tag: 'app_logo',
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: circleSize.w(context),
              height: circleSize.w(context),
              decoration: const BoxDecoration(
                color: AppColors.emerald,
                shape: BoxShape.circle,
              ),
              child: Icon(
                AppIcons.logo,
                size: iconSize.w(context),
                color: AppColors.white,
              ),
            ),
            SB.h(16),
            Text(
              AppStrings.appName,
              style: AppTextStyles.displayLarge
                  .responsive(context)
                  .copyWith(color: textColor),
            ),
            if (showTagline) ...[
              SB.h(8),
              Text(
                AppStrings.tagline,
                style: AppTextStyles.labelLarge
                    .responsive(context)
                    .copyWith(color: AppColors.muted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
