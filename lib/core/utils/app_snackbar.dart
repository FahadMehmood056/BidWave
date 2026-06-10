import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(BuildContext context, String message) {
    _show(context, message, backgroundColor: AppColors.emerald);
  }

  static void error(BuildContext context, String message) {
    _show(context, message, backgroundColor: AppColors.red);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, backgroundColor: AppColors.charcoal);
  }

  static void _show(
    BuildContext context,
    String message, {
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
