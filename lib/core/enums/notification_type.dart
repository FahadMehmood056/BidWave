import 'package:flutter/material.dart';
import '../constants/app_icons.dart';
import '../theme/app_colors.dart';

enum NotificationType {
  outbid,
  won,
  auctionEnded,
  newBid;

  static NotificationType fromFirestore(String value) {
    switch (value) {
      case 'outbid':
        return NotificationType.outbid;
      case 'auction_won':
        return NotificationType.won;
      case 'auction_ended':
        return NotificationType.auctionEnded;
      case 'new_bid':
        return NotificationType.newBid;
      default:
        return NotificationType.newBid;
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationType.outbid:
        return AppIcons.myBids;
      case NotificationType.won:
        return AppIcons.trophy;
      case NotificationType.auctionEnded:
        return AppIcons.timer;
      case NotificationType.newBid:
        return AppIcons.money;
    }
  }

  Color get color {
    switch (this) {
      case NotificationType.outbid:
        return AppColors.red;
      case NotificationType.won:
        return AppColors.emerald;
      case NotificationType.auctionEnded:
        return AppColors.info;
      case NotificationType.newBid:
        return AppColors.info;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case NotificationType.outbid:
        return AppColors.red.withValues(alpha: 0.1);
      case NotificationType.won:
        return AppColors.emeraldLight;
      case NotificationType.auctionEnded:
        return AppColors.info.withValues(alpha: 0.1);
      case NotificationType.newBid:
        return AppColors.info.withValues(alpha: 0.1);
    }
  }
}
