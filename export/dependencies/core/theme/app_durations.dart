import 'package:flutter/material.dart';

/// Medicine Bank — Animation Duration & Curve Constants
///
/// Centralised timing for consistent motion throughout the app.
abstract final class AppDurations {
  // ──────────────────────────────────────────────
  //  DURATION PRESETS
  // ──────────────────────────────────────────────

  /// Instant feedback — button taps, opacity flips.
  static const Duration fast = Duration(milliseconds: 150);

  /// Standard transitions — field focus, chip toggle.
  static const Duration normal = Duration(milliseconds: 250);

  /// Moderate animations — card expand, page fade.
  static const Duration moderate = Duration(milliseconds: 350);

  /// Slow, intentional animations — bottom sheet, modal.
  static const Duration slow = Duration(milliseconds: 500);

  /// Hero transition duration.
  static const Duration hero = Duration(milliseconds: 400);

  /// Shimmer loop cycle.
  static const Duration shimmer = Duration(milliseconds: 1500);

  /// Stagger delay between list items.
  static const Duration stagger = Duration(milliseconds: 60);

  // ──────────────────────────────────────────────
  //  CURVE PRESETS
  // ──────────────────────────────────────────────

  /// Default curve for most animations.
  static const Curve defaultCurve = Curves.easeInOutCubic;

  /// Snappy entrance — elements popping in.
  static const Curve entrance = Curves.easeOutCubic;

  /// Smooth exit — elements sliding out.
  static const Curve exit = Curves.easeInCubic;

  /// Spring-like bounce for playful interactions.
  static const Curve spring = Curves.elasticOut;

  /// Deceleration — content settling into place.
  static const Curve decelerate = Curves.decelerate;

  /// Overshoot for attention-grabbing micro-animations.
  static const Curve overshoot = Curves.easeOutBack;
}
