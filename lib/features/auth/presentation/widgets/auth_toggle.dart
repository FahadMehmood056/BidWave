import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AuthToggle extends StatelessWidget {
  final bool isLogin;
  final ValueChanged<bool> onToggle;

  const AuthToggle({super.key, required this.isLogin, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w(context)),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusPill.w(context)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: isLogin ? 0 : tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.emerald,
                    borderRadius: BorderRadius.circular(
                      AppSizes.radiusPill.w(context),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  _buildTab(
                    context,
                    text: 'Login',
                    isActive: isLogin,
                    onTap: () => onToggle(true),
                  ),
                  _buildTab(
                    context,
                    text: 'Sign Up',
                    isActive: !isLogin,
                    onTap: () => onToggle(false),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String text,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 14.w(context)),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 250),
              style: AppTextStyles.titleMedium
                  .responsive(context)
                  .copyWith(
                    color: isActive ? AppColors.white : AppColors.muted,
                  ),
              child: Text(text),
            ),
          ),
        ),
      ),
    );
  }
}
