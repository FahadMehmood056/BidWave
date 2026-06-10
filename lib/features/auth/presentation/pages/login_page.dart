import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/responsive_extension.dart';
import '../../../../core/extensions/text_style_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/utils/app_validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/sb.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_toggle.dart';
import '../widgets/or_divider.dart';
import '../widgets/social_button.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitAuthForm() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    final authBloc = context.read<AuthBloc>();

    if (_isLogin) {
      authBloc.add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    } else {
      authBloc.add(
        AuthSignUpRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _submitGoogleSignIn() {
    context.read<AuthBloc>().add(const AuthGoogleSignInRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          AppSnackbar.success(context, 'Welcome to BidWave');
          context.go(AppRoutes.home);
        }

        if (state is AuthError) {
          AppSnackbar.error(context, state.message);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.pagePadding.w(context),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SB.h(40),
                  AppLogo(
                    circleSize: 80,
                    iconSize: 38,
                    showTagline: false,
                    darkBackground: false,
                  ),
                  SB.h(8),
                  Text(
                    AppStrings.authSubtitle,
                    style: AppTextStyles.labelLarge.responsive(context),
                  ),
                  SB.h(32),
                  AuthToggle(
                    isLogin: _isLogin,
                    onToggle: (value) {
                      setState(() => _isLogin = value);
                      _formKey.currentState?.reset();
                    },
                  ),
                  SB.h(24),

                  if (!_isLogin) ...[
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
                    SB.h(16),
                  ],

                  AppTextField(
                    controller: _emailController,
                    label: AppStrings.email,
                    hint: AppStrings.emailHint,
                    keyboardType: TextInputType.emailAddress,
                    validator: AppValidators.email,
                    prefixIcon: Icon(
                      AppIcons.email,
                      size: 20.w(context),
                      color: AppColors.muted,
                    ),
                  ),
                  SB.h(16),

                  AppTextField(
                    controller: _passwordController,
                    label: AppStrings.password,
                    hint: AppStrings.passwordHint,
                    obscureText: _obscurePassword,
                    validator: AppValidators.password,
                    prefixIcon: Icon(
                      AppIcons.lock,
                      size: 20.w(context),
                      color: AppColors.muted,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                      child: Icon(
                        _obscurePassword
                            ? AppIcons.visibilityOff
                            : AppIcons.visibilityOn,
                        size: 20.w(context),
                        color: AppColors.muted,
                      ),
                    ),
                  ),
                  SB.h(24),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading =
                          state is AuthLoading &&
                          state.type == AuthLoadingType.email;

                      return AppButton(
                        text: _isLogin ? AppStrings.login : AppStrings.signUp,
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _submitAuthForm,
                      );
                    },
                  ),

                  SB.h(24),
                  const OrDivider(),
                  SB.h(24),

                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading =
                          state is AuthLoading &&
                          state.type == AuthLoadingType.google;

                      return SocialButton(
                        label: AppStrings.google,
                        isLoading: isLoading,
                        icon: Text(
                          'G',
                          style: AppTextStyles.headlineMedium
                              .responsive(context)
                              .copyWith(color: AppColors.emerald),
                        ),
                        onPressed: _submitGoogleSignIn,
                      );
                    },
                  ),

                  SB.h(24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
