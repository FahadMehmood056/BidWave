import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../../extensions/responsive_extension.dart';
import '../sb.dart';
import 'notification_item_skeleton.dart';

class NotificationsSkeleton extends StatelessWidget {
  final int itemCount;

  const NotificationsSkeleton({super.key, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(AppSizes.pagePadding.w(context)),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SB.h(AppSizes.cardGap),
      itemBuilder: (_, _) => const NotificationItemSkeleton(),
    );
  }
}
