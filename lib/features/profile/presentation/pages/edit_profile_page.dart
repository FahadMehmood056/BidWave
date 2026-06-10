import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_back_bar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/sb.dart';
import '../../../../core/widgets/shimmer_skeletons/edit_profile_skeleton.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _hasFilledInitialData = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _fillInitialData(ProfileLoaded state) {
    if (_hasFilledInitialData) return;

    _nameController.text = state.profile.name;
    _phoneController.text = state.profile.phone;

    _hasFilledInitialData = true;
  }

  void _saveProfile() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    context.read<ProfileBloc>().add(
      ProfileUpdateRequested(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          AppSnackbar.error(context, state.message);
        }

        if (state is ProfileUpdateSuccess) {
          AppSnackbar.success(context, 'Profile updated successfully');
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            const AppBackBar(title: AppStrings.editProfile),
            Expanded(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading || state is ProfileInitial) {
                    return const EditProfileSkeleton();
                  }

                  if (state is ProfileError && state.cachedProfile == null) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(
                          AppSizes.pagePadding.w(context),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message),
                            SB.h(16),
                            AppButton(
                              text: 'Retry',
                              onPressed: () {
                                context.read<ProfileBloc>().add(
                                  const ProfileRefreshRequested(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final profile = state is ProfileLoaded
                      ? state.profile
                      : state is ProfileUpdateSuccess
                      ? state.profile
                      : state is ProfileError
                      ? state.cachedProfile
                      : null;

                  if (profile == null) {
                    return const Center(child: Text('Profile not available'));
                  }

                  final isUpdating = state is ProfileLoaded && state.isUpdating;

                  if (state is ProfileLoaded) {
                    _fillInitialData(state);
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.pagePadding.w(context),
                    ),
                    physics: const ClampingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SB.h(32),
                          AppAvatar(initials: profile.initials, size: 90),
                          SB.h(32),
                          AppTextField(
                            controller: _nameController,
                            label: AppStrings.name,
                            hint: AppStrings.nameHint,
                            validator: AppValidators.name,
                            prefixIcon: Icon(
                              AppIcons.person,
                              size: 20.w(context),
                              color: AppColors.muted,
                            ),
                          ),
                          SB.h(16),
                          AppTextField(
                            controller: _phoneController,
                            label: AppStrings.phoneNumber,
                            hint: AppStrings.phoneHint,
                            keyboardType: TextInputType.phone,
                            validator: AppValidators.phone,
                            prefixIcon: Icon(
                              AppIcons.phone,
                              size: 20.w(context),
                              color: AppColors.muted,
                            ),
                          ),
                          SB.h(32),
                          AppButton(
                            text: AppStrings.saveChanges,
                            isLoading: isUpdating,
                            onPressed: isUpdating ? null : _saveProfile,
                          ),
                          SB.h(24),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
