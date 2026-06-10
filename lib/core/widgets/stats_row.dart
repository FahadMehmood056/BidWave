import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import '../extensions/responsive_extension.dart';
import '../theme/app_colors.dart';
import 'stat_item.dart';

class StatsRow extends StatelessWidget {
  final List<StatItem> stats;
  final Color? backgroundColor;
  final Color? dividerColor;

  const StatsRow({
    super.key,
    required this.stats,
    this.backgroundColor,
    this.dividerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.w(context)),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.card,
        borderRadius: BorderRadius.circular(AppSizes.radiusCard.w(context)),
        border: backgroundColor == null
            ? Border.all(color: AppColors.border)
            : null,
      ),
      child: Row(children: _buildChildren(context)),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    final children = <Widget>[];
    for (int i = 0; i < stats.length; i++) {
      children.add(Expanded(child: stats[i]));
      if (i < stats.length - 1) {
        children.add(
          Container(
            width: 1,
            height: 36.w(context),
            color: dividerColor ?? AppColors.border,
          ),
        );
      }
    }
    return children;
  }
}
