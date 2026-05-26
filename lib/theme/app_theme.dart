import 'package:flutter/material.dart';

class AppColors {
  static const teal = Color(0xFF3CC8C8);
  static const tealDark = Color(0xFF2AABAB);
  static const blue = Color(0xFF3B82F6);
  static const orange = Color(0xFFE8673A);
  static const orangeLight = Color(0xFFF08060);
  static const white = Color(0xFFFFFFFF);
  static const grey = Color(0xFFB0B0B0);
  static const greyLight = Color(0xFFD9D9D9);
  static const greyBg = Color(0xFFF0F0F0);
  static const textDark = Color(0xFF333333);
  static const textMedium = Color(0xFF555555);
}

class AppTheme {
  static ThemeData tutorTheme = ThemeData(
    primaryColor: AppColors.teal,
    scaffoldBackgroundColor: AppColors.teal,
    colorScheme: const ColorScheme.light(
      primary: AppColors.teal,
      secondary: AppColors.orange,
    ),
    fontFamily: 'Roboto',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey)),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey)),
      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.teal, width: 2)),
    ),
  );

  static ThemeData clinicaTheme = ThemeData(
    primaryColor: AppColors.orange,
    scaffoldBackgroundColor: AppColors.orange,
    colorScheme: const ColorScheme.light(
      primary: AppColors.orange,
      secondary: AppColors.teal,
    ),
    fontFamily: 'Roboto',
  );
}
