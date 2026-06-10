import 'package:bid_wave/core/widgets/sb.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_icons.dart';
import '../extensions/responsive_extension.dart';
import '../extensions/text_style_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppBackBar extends StatelessWidget {
  final String title;

  const AppBackBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.charcoal,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w(context),
            vertical: 12.w(context),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                behavior: HitTestBehavior.opaque,
                child: Icon(
                  AppIcons.arrowBack,
                  size: 20.w(context),
                  color: AppColors.white,
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: AppTextStyles.titleLarge
                        .responsive(context)
                        .copyWith(color: AppColors.white),
                  ),
                ),
              ),
              SB.w(20.w(context)),
            ],
          ),
        ),
      ),
    );
  }
}
