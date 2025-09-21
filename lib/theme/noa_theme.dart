import 'package:flutter/material.dart';

class NoaTheme {
  // Colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFFFF8A33);
  static const Color secondary = Color(0xFFFFD87A);
  static const Color neutralSurface = Color(0xFFF5F6F7);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color mutedText = Color(0xFF6B7280);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);

  // Typography
  static const String fontFamily = 'Inter';

  static const TextStyle h1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 1.5, // 24 / 16
    color: textPrimary,
  );

  static const TextStyle small = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 1.42, // 20 / 14
    color: mutedText,
  );

  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // Radii
  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double modalRadius = 20.0;

  // Elevation / Shadow
  static final BoxShadow cardShadow = BoxShadow(
    color: const Color(0xFF1F2937).withOpacity(0.08),
    blurRadius: 12.0,
    offset: const Offset(0, 4),
  );

  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      fontFamily: fontFamily,
      textTheme: const TextTheme(
        displayLarge: h1,
        displayMedium: h2,
        displaySmall: h3,
        bodyLarge: body,
        bodyMedium: body,
        bodySmall: small,
      ),
      colorScheme: const ColorScheme(
        primary: primary,
        secondary: secondary,
        surface: neutralSurface,
        background: background,
        error: error,
        onPrimary: Colors.white,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: Colors.white,
        brightness: Brightness.light,
      ),
    );
  }
}

class NoaMotion {
  // Durations
  static const Duration microPress = Duration(milliseconds: 120);
  static const Duration standardTransition = Duration(milliseconds: 260);
  static const Duration emphasis = Duration(milliseconds: 360);

  // Curves
  static const Curve microPressCurve = Curves.easeOut;
  static const Curve standardTransitionCurve = Curves.easeInOut;
  static const Curve emphasisCurve = Cubic(0.22, 1, 0.36, 1);

  // Stagger
  static const Duration staggerInterval = Duration(milliseconds: 60);
}
