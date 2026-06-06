import 'package:flutter/material.dart';

/// Medicine Bank — Shadow / Elevation Definitions
///
/// Subtle, modern shadows for depth without heaviness.
abstract final class AppShadows {
  // ──────────────────────────────────────────────
  //  LIGHT THEME SHADOWS
  // ──────────────────────────────────────────────

  /// No elevation — flat elements.
  static const List<BoxShadow> none = [];

  /// Subtle card shadow — main cards, list items.
  static const List<BoxShadow> cardLight = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x05000000),
      blurRadius: 4,
      offset: Offset(0, 1),
      spreadRadius: 0,
    ),
  ];

  /// Medium elevation — floating elements, dropdowns.
  static const List<BoxShadow> elevatedLight = [
    BoxShadow(
      color: Color(0x12000000),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 6,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// High elevation — modals, bottom sheets.
  static const List<BoxShadow> modalLight = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 8,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Bottom nav bar shadow.
  static const List<BoxShadow> bottomNavLight = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 12,
      offset: Offset(0, -2),
      spreadRadius: 0,
    ),
  ];

  /// Soft glow for primary buttons on press.
  static List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: const Color(0xFF1A6B7C).withValues(alpha: 0.3),
      blurRadius: 20,
      offset: const Offset(0, 6),
      spreadRadius: 0,
    ),
  ];

  // ──────────────────────────────────────────────
  //  DARK THEME SHADOWS
  // ──────────────────────────────────────────────

  static const List<BoxShadow> cardDark = [
    BoxShadow(
      color: Color(0x30000000),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> elevatedDark = [
    BoxShadow(
      color: Color(0x40000000),
      blurRadius: 16,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> bottomNavDark = [
    BoxShadow(
      color: Color(0x50000000),
      blurRadius: 12,
      offset: Offset(0, -2),
      spreadRadius: 0,
    ),
  ];
}
