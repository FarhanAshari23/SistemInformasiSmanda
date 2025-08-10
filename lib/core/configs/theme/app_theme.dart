import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final mainTheme = ThemeData(
    popupMenuTheme: const PopupMenuThemeData(
      color: AppColors.primary,
    ),
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    brightness: Brightness.light,
    fontFamily: 'Satoshi',
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.tertiary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
      ),
    ),
  );
}
