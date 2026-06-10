import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/sb.dart';
import '../../../../core/widgets/shimmer_skeletons/profile_skeleton.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(const AuthLogoutRequested());
  }

  Future<void> _refreshProfile(BuildContext context) async {
    context.read<ProfileBloc>().add(const ProfileRefreshRequested());
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              AppSnackbar.error(context, state.message);
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthUnauthenticated) {
              context.go(AppRoutes.login);
            }

            if (state is AuthError) {
              AppSnackbar.error(context, state.message);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading || state is ProfileInitial) {
              return const ProfileSkeleton();
            }

            if (state is ProfileError && state.cachedProfile == null) {
              return RefreshIndicator(
                onRefresh: () => _refreshProfile(context),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  padding: EdgeInsets.all(AppSizes.pagePadding.w(context)),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.32),
                    Center(child: Text(state.message)),
                    SB.h(16),
                    ProfileMenuItem(
                      icon: AppIcons.refresh,
                      label: 'Retry',
                      onTap: () {
                        context.read<ProfileBloc>().add(
                          const ProfileRefreshRequested(),
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            final profile = state is ProfileLoaded
                ? state.profile
                : state is ProfileError
                ? state.cachedProfile
                : null;

            if (profile == null) {
              return RefreshIndicator(
                onRefresh: () => _refreshProfile(context),
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  children: [
                    SizedBox(height: 280),
                    Center(child: Text('Profile not available')),
                  ],
                ),
              );
            }

            return Column(
              children: [
                ProfileHeader(
                  name: profile.name,
                  initials: profile.initials,
                  email: profile.email,
                  wonCount: profile.wonCount,
                  soldCount: profile.soldCount,
                  bidsCount: profile.bidsCount,
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _refreshProfile(context),
                    child: ListView(
                      padding: EdgeInsets.all(AppSizes.pagePadding.w(context)),
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: ClampingScrollPhysics(),
                      ),
                      children: [
                        ProfileMenuItem(
                          icon: AppIcons.trophy,
                          label: AppStrings.wonAuctions,
                          onTap: () => context.push(AppRoutes.wonAuctions),
                        ),
                        SB.h(AppSizes.cardGap),
                        ProfileMenuItem(
                          icon: AppIcons.edit,
                          label: AppStrings.editProfile,
                          onTap: () async {
                            final shouldRefresh = await context.push<bool>(
                              AppRoutes.editProfile,
                            );
                            if (!context.mounted) return;
                            if (shouldRefresh == true) {
                              context.read<ProfileBloc>().add(
                                const ProfileRefreshRequested(),
                              );
                            }
                          },
                        ),
                        SB.h(24),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, authState) {
                            final isLoggingOut =
                                authState is AuthLoading &&
                                authState.type == AuthLoadingType.logout;
                            return ProfileMenuItem(
                              icon: AppIcons.logoutIcon,
                              label: isLoggingOut
                                  ? 'Logging out...'
                                  : AppStrings.logout,
                              isDestructive: true,
                              onTap: isLoggingOut
                                  ? null
                                  : () => _logout(context),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
