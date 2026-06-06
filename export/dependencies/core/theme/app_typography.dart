import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Medicine Bank — Typography System
///
/// **Bi-directional font stack:**
/// - English (LTR): **Inter** — clean, modern, medical-grade readability.
/// - Arabic  (RTL): **Cairo** — highly legible Arabic typeface designed
///   for UI, with proper glyph spacing and diacritics support.
///
/// Arabic script has taller ascenders/descenders, so line-heights
/// are bumped by ~10% when the locale is Arabic to prevent clipping.
abstract final class AppTypography {
  // ──────────────────────────────────────────────
  //  FONT FAMILIES
  // ──────────────────────────────────────────────
  /// Latin font — Inter for English content.
  static String get _latinFamily => GoogleFonts.inter().fontFamily!;

  /// Arabic font — Cairo for Arabic content.
  static String get _arabicFamily => GoogleFonts.cairo().fontFamily!;

  /// Returns the correct font family for the given locale.
  static String fontFamilyFor(Locale locale) =>
      locale.languageCode == 'ar' ? _arabicFamily : _latinFamily;

  /// Returns font family list with both fonts for proper fallback.
  static List<String>? fontFallbackFor(Locale locale) =>
      locale.languageCode == 'ar' ? [_latinFamily] : [_arabicFamily];

  // ──────────────────────────────────────────────
  //  LINE-HEIGHT ADJUSTMENT
  // ──────────────────────────────────────────────
  /// Arabic script needs slightly more vertical room.
  static const double _arabicHeightBump = 0.15;

  // ──────────────────────────────────────────────
  //  DISPLAY — Screen titles, hero text
  // ──────────────────────────────────────────────
  static TextStyle get displayLarge => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.3,
  );

  static TextStyle get displaySmall => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.2,
  );

  // ──────────────────────────────────────────────
  //  HEADLINE — Section headers, card titles
  // ──────────────────────────────────────────────
  static TextStyle get headlineLarge => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle get headlineMedium => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static TextStyle get headlineSmall => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ──────────────────────────────────────────────
  //  TITLE — Medicine names, form headers
  // ──────────────────────────────────────────────
  static TextStyle get titleLarge => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle get titleMedium => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle get titleSmall => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.45,
  );

  // ──────────────────────────────────────────────
  //  BODY — Descriptions, form content
  // ──────────────────────────────────────────────
  static TextStyle get bodyLarge => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ──────────────────────────────────────────────
  //  LABEL — Chips, badges, captions
  // ──────────────────────────────────────────────
  static TextStyle get labelLarge => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.1,
  );

  static TextStyle get labelMedium => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.2,
  );

  static TextStyle get labelSmall => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.3,
  );

  // ──────────────────────────────────────────────
  //  BUTTON
  // ──────────────────────────────────────────────
  static TextStyle get buttonLarge => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.3,
  );

  static TextStyle get buttonMedium => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.2,
  );

  static TextStyle get buttonSmall => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.2,
  );

  // ──────────────────────────────────────────────
  //  UTILITY — AppBar brand text
  // ──────────────────────────────────────────────
  static TextStyle get appBarBrand => TextStyle(
    fontFamily: _latinFamily,
    fontFamilyFallback: [_arabicFamily],
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.2,
  );

  // ──────────────────────────────────────────────
  //  LOCALE-AWARE TEXT THEME
  // ──────────────────────────────────────────────

  /// Builds a full [TextTheme] for the given locale.
  /// When [locale] is Arabic, uses Cairo font with bumped line-heights
  /// and zero letter-spacing (Arabic doesn't use Latin letter-spacing).
  static TextTheme textThemeFor(Locale locale) {
    final isAr = locale.languageCode == 'ar';
    final family = isAr ? _arabicFamily : _latinFamily;
    final fallback = isAr ? [_latinFamily] : [_arabicFamily];
    final bump = isAr ? _arabicHeightBump : 0.0;
    // Arabic text should not use negative letter-spacing
    double ls(double latin) => isAr ? 0 : latin;

    return TextTheme(
      displayLarge: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 32, fontWeight: FontWeight.w700, height: 1.2 + bump, letterSpacing: ls(-0.5)),
      displayMedium: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 28, fontWeight: FontWeight.w700, height: 1.25 + bump, letterSpacing: ls(-0.3)),
      displaySmall: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 24, fontWeight: FontWeight.w700, height: 1.3 + bump, letterSpacing: ls(-0.2)),
      headlineLarge: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 22, fontWeight: FontWeight.w600, height: 1.3 + bump),
      headlineMedium: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 20, fontWeight: FontWeight.w600, height: 1.35 + bump),
      headlineSmall: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 18, fontWeight: FontWeight.w600, height: 1.4 + bump),
      titleLarge: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 18, fontWeight: FontWeight.w600, height: 1.4 + bump),
      titleMedium: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 16, fontWeight: FontWeight.w600, height: 1.4 + bump),
      titleSmall: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 14, fontWeight: FontWeight.w600, height: 1.45 + bump),
      bodyLarge: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 16, fontWeight: FontWeight.w400, height: 1.5 + bump),
      bodyMedium: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 14, fontWeight: FontWeight.w400, height: 1.5 + bump),
      bodySmall: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 12, fontWeight: FontWeight.w400, height: 1.5 + bump),
      labelLarge: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 14, fontWeight: FontWeight.w500, height: 1.4 + bump, letterSpacing: ls(0.1)),
      labelMedium: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 12, fontWeight: FontWeight.w500, height: 1.4 + bump, letterSpacing: ls(0.2)),
      labelSmall: TextStyle(fontFamily: family, fontFamilyFallback: fallback, fontSize: 10, fontWeight: FontWeight.w500, height: 1.5 + bump, letterSpacing: ls(0.3)),
    );
  }

  /// Builds the default [TextTheme] for Material 3 integration.
  /// Uses Inter (Latin) as the primary with Cairo (Arabic) as fallback.
  static TextTheme get textTheme => TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
