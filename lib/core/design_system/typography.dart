import 'package:flutter/material.dart';

import 'colors.dart';

/// Una familia local, tres pesos; sin descargas al abrir la app.
abstract final class AppTypography {
  static const family = 'Manrope';
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semibold = FontWeight.w600;
  static const textTheme = TextTheme(
    displaySmall: TextStyle(
      fontFamily: family,
      fontSize: 36,
      height: 1.2,
      fontWeight: semibold,
      color: AppColors.text,
      letterSpacing: -1,
    ),
    headlineMedium: TextStyle(
      fontFamily: family,
      fontSize: 28,
      height: 1.3,
      fontWeight: semibold,
      color: AppColors.text,
      letterSpacing: -0.6,
    ),
    headlineSmall: TextStyle(
      fontFamily: family,
      fontSize: 24,
      height: 1.35,
      fontWeight: semibold,
      color: AppColors.text,
      letterSpacing: -0.4,
    ),
    titleLarge: TextStyle(
      fontFamily: family,
      fontSize: 20,
      height: 1.4,
      fontWeight: semibold,
      color: AppColors.text,
    ),
    titleMedium: TextStyle(
      fontFamily: family,
      fontSize: 16,
      height: 1.5,
      fontWeight: semibold,
      color: AppColors.text,
    ),
    titleSmall: TextStyle(
      fontFamily: family,
      fontSize: 14,
      height: 1.5,
      fontWeight: semibold,
      color: AppColors.text,
    ),
    bodyLarge: TextStyle(
      fontFamily: family,
      fontSize: 16,
      height: 1.6,
      fontWeight: regular,
      color: AppColors.text,
    ),
    bodyMedium: TextStyle(
      fontFamily: family,
      fontSize: 14,
      height: 1.6,
      fontWeight: regular,
      color: AppColors.text,
    ),
    bodySmall: TextStyle(
      fontFamily: family,
      fontSize: 12,
      height: 1.5,
      fontWeight: regular,
      color: AppColors.textSecondary,
    ),
    labelLarge: TextStyle(
      fontFamily: family,
      fontSize: 14,
      height: 1.4,
      fontWeight: semibold,
      color: AppColors.text,
    ),
    labelMedium: TextStyle(
      fontFamily: family,
      fontSize: 12,
      height: 1.4,
      fontWeight: medium,
      color: AppColors.textSecondary,
    ),
    labelSmall: TextStyle(
      fontFamily: family,
      fontSize: 11,
      height: 1.4,
      fontWeight: medium,
      color: AppColors.textSecondary,
    ),
  );
}
