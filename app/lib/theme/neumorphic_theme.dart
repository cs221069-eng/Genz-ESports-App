import 'package:flutter/material.dart';

// ── Global Color Constants ──────────────────────────────────────────────────
const Color kPrimaryBlue = Color(0xFF17B7FF);
const Color kBackground   = Color(0xFF061532);
const Color kSurfaceDark  = Color(0xFF0B2559);
const Color kTextHeading  = Color(0xFFECF7FF);
const Color kTextMuted    = Color(0xFFA6C9EA);
const Color kTextSubtle   = Color(0xFF6B91B5);

class NeumorphicTheme {
  // ── Brand Colors (unchanged) ──────────────────────────────────────────────
  static const Color primaryBlue = kPrimaryBlue;
  static const Color background   = kBackground;
  static const Color surfaceDark  = kSurfaceDark;

  // ── Glass layer tokens ────────────────────────────────────────────────────
  static const Color glassSurface   = Color(0x1A17B7FF); // 10 % primary tint
  static const Color glassBorder    = Color(0x33FFFFFF); // 20 % white
  static const Color glassHighlight = Color(0x0DFFFFFF); // 5  % white
  static const Color glassShadow    = Color(0x40000000); // 25 % black

  // ── Text colors (unchanged) ───────────────────────────────────────────────
  static const Color textHeading = kTextHeading;
  static const Color textMuted   = kTextMuted;
  static const Color textSubtle  = kTextSubtle;

  static ThemeData lightTheme() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: background,
      cardColor: surfaceDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        surface: surfaceDark,
        onSurface: textHeading,
      ),
      // ── Input field theme (glassmorphism fields) ─────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0x1A17B7FF),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0x4017B7FF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0x3317B7FF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFBA1A1A)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 1.5),
        ),
      ),
      // ── Typography ────────────────────────────────────────────────────────
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textHeading,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: textHeading,
          letterSpacing: -0.3,
        ),
        headlineMedium: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: textHeading,
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: primaryBlue,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: textMuted, height: 1.5),
        bodyMedium: TextStyle(fontSize: 14, color: textMuted, height: 1.4),
        bodySmall: TextStyle(fontSize: 12, color: textSubtle),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
      // ── App bar ───────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: textHeading,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
        iconTheme: IconThemeData(color: textHeading),
      ),
      // ── Filled button ─────────────────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      // ── Floating action button ────────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: CircleBorder(),
      ),
      // ── Tab bar ───────────────────────────────────────────────────────────
      tabBarTheme: TabBarThemeData(
        labelColor: Colors.white,
        unselectedLabelColor: textMuted,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: primaryBlue,
          borderRadius: BorderRadius.circular(999),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
      // ── Divider ───────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: Color(0x2217B7FF),
        thickness: 1,
      ),
      // ── Snack bar ─────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF0B2559),
        contentTextStyle: const TextStyle(color: textHeading),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
