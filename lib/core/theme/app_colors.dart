import 'package:flutter/material.dart';

/// Medicine Bank — Centralized Color Palette
///
/// Every color in the app flows from here. No magic hex values
/// should exist anywhere outside this file.
abstract final class AppColors {
  // ──────────────────────────────────────────────
  //  PRIMARY — Deep Teal
  // ──────────────────────────────────────────────
  static const Color primary = Color(0xFF1A6B7C);
  static const Color primaryDark = Color(0xFF135A68);
  static const Color primaryLight = Color(0xFF2A8A9C);
  static const Color primarySurface = Color(0xFFE8F4F6);
  static const Color primaryContainer = Color(0xFFD0EAF0);

  // ──────────────────────────────────────────────
  //  ACCENT — Sky Blue
  // ──────────────────────────────────────────────
  static const Color accent = Color(0xFF5BC0EB);
  static const Color accentLight = Color(0xFFB8E4F8);
  static const Color accentSurface = Color(0xFFEAF6FC);

  // ──────────────────────────────────────────────
  //  SEMANTIC COLORS
  // ──────────────────────────────────────────────
  static const Color success = Color(0xFF34C759);
  static const Color successLight = Color(0xFFD4F5DD);
  static const Color error = Color(0xFFDC3545);
  static const Color errorLight = Color(0xFFFDE8EA);
  static const Color warning = Color(0xFFF0AD4E);
  static const Color warningLight = Color(0xFFFFF4E0);
  static const Color info = Color(0xFF2196F3);

  // ──────────────────────────────────────────────
  //  NEUTRAL — Light Theme
  // ──────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF5F8FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color outlineLight = Color(0xFFD1D9E0);
  static const Color disabledLight = Color(0xFFBCC5CE);

  // ──────────────────────────────────────────────
  //  NEUTRAL — Dark Theme
  // ──────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0F1419);
  static const Color surfaceDark = Color(0xFF1A1F2E);
  static const Color cardDark = Color(0xFF222836);
  static const Color dividerDark = Color(0xFF2D3548);
  static const Color outlineDark = Color(0xFF3A4558);
  static const Color disabledDark = Color(0xFF4A5568);

  // ──────────────────────────────────────────────
  //  TEXT COLORS
  // ──────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF1A1A2E);
  static const Color textSecondaryLight = Color(0xFF4A5568);
  static const Color textTertiaryLight = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);
  static const Color textOnPrimaryDark = Color(0xFFFFFFFF);

  // ──────────────────────────────────────────────
  //  MEDICINE CATEGORY CHIP COLORS
  // ──────────────────────────────────────────────
  static const Color chipAntibiotic = Color(0xFF1A6B7C);
  static const Color chipPainkiller = Color(0xFF2D3748);
  static const Color chipDiabetes = Color(0xFF6366F1);
  static const Color chipVitamins = Color(0xFF059669);
  static const Color chipHeart = Color(0xFFDC2626);
  static const Color chipAllergy = Color(0xFFD97706);
  static const Color chipDefault = Color(0xFF6B7280);

  // ──────────────────────────────────────────────
  //  GRADIENT DEFINITIONS
  // ──────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFE8F0F5), Color(0xFFF5F8FA)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primarySurface, Color(0xFFF5F8FA)],
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF141B27), Color(0xFF0F1419)],
  );

  /// Returns the chip color for a given medicine category.
  static Color chipColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'antibiotic':
        return chipAntibiotic;
      case 'painkiller':
        return chipPainkiller;
      case 'diabetes':
        return chipDiabetes;
      case 'vitamins':
        return chipVitamins;
      case 'heart':
        return chipHeart;
      case 'allergy':
        return chipAllergy;
      default:
        return chipDefault;
    }
  }
}
