import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';

class DurationSelector extends StatelessWidget {
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  const DurationSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.duration,
          style: AppTextStyles.labelLarge.responsive(context),
        ),
        SB.h(8),
        Row(
          children: options.map((option) {
            final isSelected = option == selected;
            return Expanded(
              child: GestureDetector(
                onTap: () => onSelected(option),
                child: Container(
                  margin: EdgeInsets.only(
                    right: option != options.last ? 8.w(context) : 0,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.w(context)),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.emerald : AppColors.card,
                    borderRadius: BorderRadius.circular(
                      AppSizes.radiusPill.w(context),
                    ),
                    border: isSelected
                        ? null
                        : Border.all(color: AppColors.border),
                  ),
                  child: Center(
                    child: Text(
                      option,
                      style: AppTextStyles.titleSmall
                          .responsive(context)
                          .copyWith(
                            color: isSelected
                                ? AppColors.white
                                : AppColors.text,
                          ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
