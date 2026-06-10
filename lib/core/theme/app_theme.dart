import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Roboto',
    colorScheme: ColorScheme.light(
      primary: AppColors.emerald,
      secondary: AppColors.charcoal,
      surface: AppColors.card,
      error: AppColors.red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.charcoal,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
  );
}
