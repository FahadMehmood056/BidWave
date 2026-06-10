import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../../extensions/responsive_extension.dart';
import '../sb.dart';
import 'auction_card_skeleton.dart';
import 'auction_list_item_skeleton.dart';

class AuctionCardListSkeleton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final int itemCount;

  const AuctionCardListSkeleton({super.key, this.padding, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: AppSizes.pagePadding.w(context),
            vertical: AppSizes.pagePadding.h(context),
          ),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SB.h(AppSizes.cardGap),
      itemBuilder: (_, _) => const AuctionCardSkeleton(),
    );
  }
}

class AuctionListSkeleton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final int itemCount;

  const AuctionListSkeleton({super.key, this.padding, this.itemCount = 8});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding ?? EdgeInsets.all(AppSizes.pagePadding.w(context)),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SB.h(AppSizes.cardGap),
      itemBuilder: (_, _) => const AuctionListItemSkeleton(),
    );
  }
}
