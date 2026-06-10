import 'package:flutter/material.dart';
import '../../../../core/constants/app_currencies.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/sb.dart';

class CurrencySelector extends StatelessWidget {
  final AppCurrency selected;
  final ValueChanged<AppCurrency> onSelected;

  const CurrencySelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.currency,
          style: AppTextStyles.labelLarge.responsive(context),
        ),
        SB.h(8),
        GestureDetector(
          onTap: () => _showCurrencySheet(context),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16.w(context),
              vertical: 14.w(context),
            ),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(
                AppSizes.radiusButton.w(context),
              ),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Text(
                  '${selected.symbol}  ${selected.code}',
                  style: AppTextStyles.bodyLarge.responsive(context),
                ),
                const Spacer(),
                Icon(
                  AppIcons.dropdown,
                  size: 20.w(context),
                  color: AppColors.muted,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCurrencySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _CurrencyBottomSheet(
        selected: selected,
        onSelected: (currency) {
          onSelected(currency);
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _CurrencyBottomSheet extends StatelessWidget {
  final AppCurrency selected;
  final ValueChanged<AppCurrency> onSelected;

  const _CurrencyBottomSheet({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.5,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.w(context)),
          topRight: Radius.circular(20.w(context)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SB.h(12),
          Container(
            width: 40.w(context),
            height: 4.w(context),
            decoration: BoxDecoration(
              color: AppColors.muted.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2.w(context)),
            ),
          ),
          SB.h(16),
          Text(
            AppStrings.selectCurrency,
            style: AppTextStyles.titleLarge.responsive(context),
          ),
          SB.h(8),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: AppCurrencies.all.length,
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + 16,
              ),
              itemBuilder: (_, index) {
                final currency = AppCurrencies.all[index];
                final isSelected = currency.code == selected.code;
                return GestureDetector(
                  onTap: () => onSelected(currency),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w(context),
                      vertical: 14.w(context),
                    ),
                    color: isSelected
                        ? AppColors.emeraldLight
                        : Colors.transparent,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 36.w(context),
                          child: Text(
                            currency.symbol,
                            style: AppTextStyles.titleMedium
                                .responsive(context)
                                .copyWith(
                                  color: isSelected
                                      ? AppColors.emeraldDark
                                      : AppColors.text,
                                ),
                          ),
                        ),
                        SB.w(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currency.code,
                                style: AppTextStyles.titleSmall
                                    .responsive(context)
                                    .copyWith(
                                      color: isSelected
                                          ? AppColors.emeraldDark
                                          : AppColors.text,
                                    ),
                              ),
                              Text(
                                currency.name,
                                style: AppTextStyles.labelMedium
                                    .responsive(context)
                                    .copyWith(
                                      color: isSelected
                                          ? AppColors.emeraldDark
                                          : AppColors.muted,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            AppIcons.check,
                            size: 20.w(context),
                            color: AppColors.emeraldDark,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
