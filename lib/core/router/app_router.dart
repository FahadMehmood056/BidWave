import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auction_detail/presentation/bloc/auction_detail_bloc.dart';
import '../../features/auction_detail/presentation/bloc/auction_detail_event.dart';
import '../../features/auctions/presentation/bloc/my_auction_bloc/my_auctions_bloc.dart';
import '../../features/auctions/presentation/bloc/my_auction_bloc/my_auctions_event.dart';
import '../../features/bids/presentation/bloc/my_bids_bloc.dart';
import '../../features/bids/presentation/bloc/my_bids_event.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/presentation/bloc/home_event.dart';
import '../../features/auctions/presentation/bloc/post_auction_bloc/post_auction_bloc.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/home/presentation/pages/search_page.dart';
import '../../features/notifications/presentation/bloc/notifications_bloc.dart';
import '../../features/notifications/presentation/bloc/notifications_event.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_event.dart';
import '../../features/winner/presentation/bloc/winner_bloc/winner_bloc.dart';
import '../../features/winner/presentation/bloc/winner_bloc/winner_event.dart';
import '../../features/winner/presentation/bloc/won_auctions_bloc/won_auctions_bloc.dart';
import '../../features/winner/presentation/bloc/won_auctions_bloc/won_auctions_event.dart';
import '../constants/app_routes.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/main/presentation/pages/main_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/bids/presentation/pages/my_bids_page.dart';
import '../../features/post_auction/presentation/pages/post_auction_page.dart';
import '../../features/auctions/presentation/pages/my_auctions_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/auction_detail/presentation/pages/auction_detail_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/winner/presentation/pages/winner_page.dart';
import '../../features/winner/presentation/pages/won_auctions_page.dart';
import '../di/injection.dart';

class AppRouter {
  AppRouter._();

  static void openFromNotification({
    required String auctionId,
    required String type,
    bool fromTerminatedState = false,
  }) {
    if (auctionId.isEmpty) return;

    final targetRoute = type == 'auction_won'
        ? '${AppRoutes.winner}/$auctionId'
        : '${AppRoutes.auctionDetail}/$auctionId';

    if (fromTerminatedState) {
      router.go(AppRoutes.home);

      Future.delayed(const Duration(milliseconds: 300), () {
        router.push(targetRoute);
      });

      return;
    }

    router.push(targetRoute);
  }

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (_, state) => CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => sl<AuthBloc>(),
            child: const LoginPage(),
          ),
          transitionDuration: const Duration(milliseconds: 600),
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.auctionDetailWithId,
        builder: (_, state) {
          final auctionId = state.pathParameters['auctionId']!;
          return BlocProvider(
            create: (_) =>
                sl<AuctionDetailBloc>(param1: auctionId)
                  ..add(AuctionDetailStarted(auctionId)),
            child: AuctionDetailPage(auctionId: auctionId),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.postAuction,
        builder: (_, _) => BlocProvider(
          create: (_) => sl<PostAuctionBloc>(),
          child: const PostAuctionPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (_, _) => BlocProvider(
          create: (_) => sl<HomeBloc>()..add(const HomeStarted()),
          child: const SearchPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, _) => BlocProvider(
          create: (_) =>
              sl<NotificationsBloc>()..add(const NotificationsStarted()),
          child: const NotificationsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.winnerWithId,
        builder: (_, state) {
          final auctionId = state.pathParameters['auctionId']!;

          return BlocProvider(
            create: (_) => sl<WinnerBloc>()..add(WinnerStarted(auctionId)),
            child: WinnerPage(auctionId: auctionId),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.wonAuctions,
        builder: (_, _) => BlocProvider(
          create: (_) => sl<WonAuctionsBloc>()..add(const WonAuctionsStarted()),
          child: const WonAuctionsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (_, _) => BlocProvider(
          create: (_) => sl<ProfileBloc>()..add(const ProfileStarted()),
          child: const EditProfilePage(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, navigationShell) =>
            MainPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, _) => BlocProvider(
                  create: (_) => sl<HomeBloc>()..add(const HomeStarted()),
                  child: const HomePage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.myBids,
                builder: (_, _) => BlocProvider(
                  create: (_) => sl<MyBidsBloc>()..add(const MyBidsStarted()),
                  child: const MyBidsPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.myAuctions,
                builder: (_, _) => BlocProvider(
                  create: (_) =>
                      sl<MyAuctionsBloc>()..add(const MyAuctionsStarted()),
                  child: const MyAuctionsPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, _) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (_) =>
                          sl<ProfileBloc>()..add(const ProfileStarted()),
                    ),
                    BlocProvider(create: (_) => sl<AuthBloc>()),
                  ],
                  child: const ProfilePage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
