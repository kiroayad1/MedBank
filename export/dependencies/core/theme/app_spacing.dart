import 'package:flutter/material.dart';

/// Medicine Bank — Spacing & Layout Constants
///
/// Based on an 8pt grid system for consistent rhythm.
/// Use these exclusively — never hardcode padding/margin values.
abstract final class AppSpacing {
  // ──────────────────────────────────────────────
  //  BASE SPACING (8pt grid)
  // ──────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
  static const double section = 40.0;
  static const double hero = 56.0;

  // ──────────────────────────────────────────────
  //  SCREEN-LEVEL PADDING
  // ──────────────────────────────────────────────
  /// Standard horizontal padding for screen content.
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: xxl,
  );

  /// Full screen padding with vertical space.
  static const EdgeInsets screenPaddingAll = EdgeInsets.symmetric(
    horizontal: xxl,
    vertical: lg,
  );

  /// Compact padding for dense layouts.
  static const EdgeInsets screenPaddingCompact = EdgeInsets.symmetric(
    horizontal: lg,
  );

  // ──────────────────────────────────────────────
  //  CARD PADDING
  // ──────────────────────────────────────────────
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);

  static const EdgeInsets cardPaddingLarge = EdgeInsets.all(xl);

  static const EdgeInsets cardPaddingCompact = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  // ──────────────────────────────────────────────
  //  FORM SPACING
  // ──────────────────────────────────────────────
  /// Vertical gap between form fields.
  static const double formFieldGap = 20.0;

  /// Vertical gap between form sections.
  static const double formSectionGap = 28.0;

  /// Padding inside input fields.
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: lg,
  );

  // ──────────────────────────────────────────────
  //  COMPONENT SIZING
  // ──────────────────────────────────────────────
  /// Standard button height for accessible touch targets.
  static const double buttonHeight = 52.0;

  /// Small button height.
  static const double buttonHeightSmall = 40.0;

  /// Bottom navigation bar height.
  static const double bottomNavHeight = 72.0;

  /// Icon circle size (e.g., hero icons on guidelines pages).
  static const double iconCircleLarge = 80.0;
  static const double iconCircleMedium = 56.0;
  static const double iconCircleSmall = 40.0;

  /// Standard icon sizes.
  static const double iconSm = 16.0;
  static const double iconMd = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;

  // ──────────────────────────────────────────────
  //  CONVENIENCE GAP WIDGETS
  // ──────────────────────────────────────────────
  static const SizedBox gapXs = SizedBox(height: xs);
  static const SizedBox gapSm = SizedBox(height: sm);
  static const SizedBox gapMd = SizedBox(height: md);
  static const SizedBox gapLg = SizedBox(height: lg);
  static const SizedBox gapXl = SizedBox(height: xl);
  static const SizedBox gapXxl = SizedBox(height: xxl);
  static const SizedBox gapXxxl = SizedBox(height: xxxl);
  static const SizedBox gapSection = SizedBox(height: section);

  static const SizedBox gapHXs = SizedBox(width: xs);
  static const SizedBox gapHSm = SizedBox(width: sm);
  static const SizedBox gapHMd = SizedBox(width: md);
  static const SizedBox gapHLg = SizedBox(width: lg);
  static const SizedBox gapHXl = SizedBox(width: xl);
  static const SizedBox gapHXxl = SizedBox(width: xxl);
}
