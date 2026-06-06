import 'package:flutter/material.dart';

/// Medicine Bank — Shape / Border Radius Constants
///
/// Consistent rounding across all components.
abstract final class AppShapes {
  // ──────────────────────────────────────────────
  //  RAW RADIUS VALUES
  // ──────────────────────────────────────────────
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;

  // ──────────────────────────────────────────────
  //  BORDER RADIUS
  // ──────────────────────────────────────────────
  static const BorderRadius borderRadiusXs = BorderRadius.all(
    Radius.circular(radiusXs),
  );
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(radiusSm),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );
  static const BorderRadius borderRadiusFull = BorderRadius.all(
    Radius.circular(radiusFull),
  );

  /// Top-only rounding for bottom sheets / modals.
  static const BorderRadius borderRadiusTopXl = BorderRadius.only(
    topLeft: Radius.circular(radiusXl),
    topRight: Radius.circular(radiusXl),
  );

  // ──────────────────────────────────────────────
  //  ROUNDED RECTANGLE SHAPE (Material widgets)
  // ──────────────────────────────────────────────
  static const RoundedRectangleBorder shapeSm = RoundedRectangleBorder(
    borderRadius: borderRadiusSm,
  );
  static const RoundedRectangleBorder shapeMd = RoundedRectangleBorder(
    borderRadius: borderRadiusMd,
  );
  static const RoundedRectangleBorder shapeLg = RoundedRectangleBorder(
    borderRadius: borderRadiusLg,
  );
  static const RoundedRectangleBorder shapeXl = RoundedRectangleBorder(
    borderRadius: borderRadiusXl,
  );
  static const RoundedRectangleBorder shapeFull = RoundedRectangleBorder(
    borderRadius: borderRadiusFull,
  );

  // ──────────────────────────────────────────────
  //  INPUT DECORATION BORDER
  // ──────────────────────────────────────────────
  static OutlineInputBorder inputBorder({
    Color color = const Color(0xFFE2E8F0),
    double width = 1.0,
  }) {
    return OutlineInputBorder(
      borderRadius: borderRadiusMd,
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static OutlineInputBorder inputBorderFocused({
    Color color = const Color(0xFF1A6B7C),
    double width = 1.5,
  }) {
    return OutlineInputBorder(
      borderRadius: borderRadiusMd,
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
