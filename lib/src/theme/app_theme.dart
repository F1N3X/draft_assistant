import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const _background = Color(0xFF071827);
  static const _surface = Color(0xFF122436);
  static const _primary = Color(0xFFA9C4FA);
  static const _onPrimary = Color(0xFF092845);
  static const _secondary = Color(0xFF1C2D3F);
  static const _onSecondary = Color(0xFFD6D9E3);
  static const _outline = Color(0xFF7C8798);

  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: _background,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: _primary,
      onPrimary: _onPrimary,
      secondary: _secondary,
      onSecondary: _onSecondary,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      surface: _surface,
      onSurface: Colors.white,
      outline: _outline,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: _background,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontSize: 57, fontWeight: FontWeight.w400),
      displayMedium: TextStyle(color: Colors.white, fontSize: 45, fontWeight: FontWeight.w400),
      displaySmall: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w400),
      headlineLarge: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w400),
      titleLarge: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w400),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _surface,
        foregroundColor: _onSecondary,
        fixedSize: const Size.square(24),
        minimumSize: Size.zero,
        padding: EdgeInsets.all(8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: _outline),
        ),
      ),
    ),
  );
}
