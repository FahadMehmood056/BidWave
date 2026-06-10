import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loader.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/sb.dart';

class BidInputBar extends StatefulWidget {
  final String minimumBid;
  final bool isLoading;
  final ValueChanged<String>? onBid;

  const BidInputBar({
    super.key,
    required this.minimumBid,
    this.isLoading = false,
    this.onBid,
  });

  @override
  State<BidInputBar> createState() => _BidInputBarState();
}

class _BidInputBarState extends State<BidInputBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitBid() {
    if (widget.isLoading) return;

    final value = _controller.text.trim();

    if (value.isEmpty || widget.onBid == null) return;

    widget.onBid!(value);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w(context),
        right: 16.w(context),
        top: 12.w(context),
        bottom: MediaQuery.paddingOf(context).bottom + 12.w(context),
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: _controller,
              hint: '${widget.minimumBid}+',
              keyboardType: TextInputType.number,
              showBorder: true,
            ),
          ),
          SB.w(12),
          GestureDetector(
            onTap: widget.isLoading ? null : _submitBid,
            child: Container(
              width: 88.w(context),
              padding: EdgeInsets.symmetric(
                horizontal: 24.w(context),
                vertical: 14.w(context),
              ),
              decoration: BoxDecoration(
                color: widget.isLoading
                    ? AppColors.muted.withValues(alpha: 0.4)
                    : AppColors.emerald,
                borderRadius: BorderRadius.circular(
                  AppSizes.radiusButton.w(context),
                ),
              ),
              child: Center(
                child: widget.isLoading
                    ? const AppLoader(color: AppColors.white)
                    : Text(
                        AppStrings.bid,
                        style: AppTextStyles.titleMedium
                            .responsive(context)
                            .copyWith(color: AppColors.white),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
