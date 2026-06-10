import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/nav_item.dart';
import '../../../../core/widgets/app_bottom_nav.dart';

class MainPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainPage({super.key, required this.navigationShell});

  static const List<NavItem> _navItems = [
    NavItem(
      icon: AppIcons.home,
      activeIcon: AppIcons.homeFilled,
      label: AppStrings.navHome,
    ),
    NavItem(
      icon: AppIcons.myBids,
      activeIcon: AppIcons.myBidsFilled,
      label: AppStrings.navMyBids,
    ),
    NavItem(
      icon: AppIcons.post,
      activeIcon: AppIcons.post,
      label: AppStrings.navPost,
    ),
    NavItem(
      icon: AppIcons.auctions,
      activeIcon: AppIcons.auctionsFilled,
      label: AppStrings.navAuctions,
    ),
    NavItem(
      icon: AppIcons.profile,
      activeIcon: AppIcons.profileFilled,
      label: AppStrings.navProfile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        items: _navItems,
        currentIndex: _mapShellToNavIndex(navigationShell.currentIndex),
        onTap: (index) => _handleNavTap(context, index),
      ),
    );
  }

  void _handleNavTap(BuildContext context, int index) {
    if (index == 2) {
      context.push(AppRoutes.postAuction);
      return;
    }

    final shellIndex = index > 2 ? index - 1 : index;
    navigationShell.goBranch(
      shellIndex,
      initialLocation: shellIndex == navigationShell.currentIndex,
    );
  }

  int _mapShellToNavIndex(int shellIndex) {
    return shellIndex >= 2 ? shellIndex + 1 : shellIndex;
  }
}
