import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../extensions/responsive_extension.dart';
import '../extensions/text_style_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'sb.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final bool obscureText;
  final bool showBorder;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;
  final Widget? prefixIcon;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.obscureText = false,
    this.showBorder = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.suffixIcon,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(
      AppSizes.radiusButton.w(context),
    );

    final defaultBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: showBorder
          ? BorderSide(color: AppColors.border)
          : BorderSide.none,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: AppTextStyles.labelLarge.responsive(context)),
          SB.h(8),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          onTapOutside: (e) => FocusScope.of(context).unfocus(),
          style: AppTextStyles.bodyLarge.responsive(context),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyLarge
                .responsive(context)
                .copyWith(color: AppColors.muted),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: AppColors.card,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSizes.paddingMedium.w(context),
              vertical: 14.w(context),
            ),
            border: defaultBorder,
            enabledBorder: defaultBorder,
            focusedBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: AppColors.emerald),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: borderRadius,
              borderSide: const BorderSide(color: AppColors.red),
            ),
          ),
        ),
      ],
    );
  }
}
