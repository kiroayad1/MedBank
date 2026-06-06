import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_shapes.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Medicine Bank — Unified Theme Builder
///
/// Constructs complete [ThemeData] for light and dark modes,
/// wiring together colors, typography, shapes, and component themes.
abstract final class AppTheme {
  // ──────────────────────────────────────────────
  //  LIGHT THEME
  // ──────────────────────────────────────────────
  static ThemeData light([Locale? locale]) {
    final colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryContainer,
      secondary: AppColors.accent,
      secondaryContainer: AppColors.accentSurface,
      error: AppColors.error,
      errorContainer: AppColors.errorLight,
      surface: AppColors.surfaceLight,
      onPrimary: AppColors.textOnPrimary,
      onSecondary: AppColors.textOnPrimary,
      onSurface: AppColors.textPrimaryLight,
      onSurfaceVariant: AppColors.textSecondaryLight,
      onError: AppColors.textOnPrimary,
      outline: AppColors.outlineLight,
      outlineVariant: AppColors.dividerLight,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackground: AppColors.backgroundLight,
      cardColor: AppColors.cardLight,
      dividerColor: AppColors.dividerLight,
      disabledColor: AppColors.disabledLight,
      hintColor: AppColors.textTertiaryLight,
      locale: locale,
    );
  }

  // ──────────────────────────────────────────────
  //  DARK THEME
  // ──────────────────────────────────────────────
  static ThemeData dark([Locale? locale]) {
    final colorScheme = ColorScheme.dark(
      primary: AppColors.primaryLight,
      primaryContainer: AppColors.primaryDark,
      secondary: AppColors.accent,
      secondaryContainer: AppColors.accentSurface,
      error: AppColors.error,
      errorContainer: AppColors.errorLight,
      surface: AppColors.surfaceDark,
      onPrimary: AppColors.textOnPrimaryDark,
      onSecondary: AppColors.textOnPrimaryDark,
      onSurface: AppColors.textPrimaryDark,
      onSurfaceVariant: AppColors.textSecondaryDark,
      onError: AppColors.textOnPrimaryDark,
      outline: AppColors.outlineDark,
      outlineVariant: AppColors.dividerDark,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackground: AppColors.backgroundDark,
      cardColor: AppColors.cardDark,
      dividerColor: AppColors.dividerDark,
      disabledColor: AppColors.disabledDark,
      hintColor: AppColors.textTertiaryDark,
      locale: locale,
    );
  }

  // ──────────────────────────────────────────────
  //  PRIVATE BUILDER
  // ──────────────────────────────────────────────
  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Brightness brightness,
    required Color scaffoldBackground,
    required Color cardColor,
    required Color dividerColor,
    required Color disabledColor,
    required Color hintColor,
    Locale? locale,
  }) {
    final isLight = brightness == Brightness.light;
    final baseTextTheme = locale != null
        ? AppTypography.textThemeFor(locale)
        : AppTypography.textTheme;
    final textTheme = baseTextTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      cardColor: cardColor,
      dividerColor: dividerColor,
      disabledColor: disabledColor,
      hintColor: hintColor,
      textTheme: textTheme,
      splashFactory: InkSparkle.splashFactory,

      // ── AppBar ──
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        titleTextStyle: AppTypography.appBarBrand.copyWith(
          color: colorScheme.primary,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
          size: AppSpacing.iconLg,
        ),
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
      ),

      // ── Cards ──
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: AppShapes.shapeLg,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
      ),

      // ── Elevated Button (Primary CTA) ──
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: disabledColor,
          elevation: 0,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          shape: AppShapes.shapeMd,
          textStyle: AppTypography.buttonLarge,
        ),
      ),

      // ── Outlined Button ──
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          shape: AppShapes.shapeMd,
          side: BorderSide(color: colorScheme.outline),
          textStyle: AppTypography.buttonLarge,
        ),
      ),

      // ── Text Button ──
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: AppTypography.buttonMedium,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
        ),
      ),

      // ── Input Fields ──
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        contentPadding: AppSpacing.inputPadding,
        border: AppShapes.inputBorder(),
        enabledBorder: AppShapes.inputBorder(color: dividerColor),
        focusedBorder: AppShapes.inputBorderFocused(
          color: colorScheme.primary,
        ),
        errorBorder: AppShapes.inputBorder(
          color: colorScheme.error,
        ),
        focusedErrorBorder: AppShapes.inputBorderFocused(
          color: colorScheme.error,
        ),
        hintStyle: AppTypography.bodyLarge.copyWith(color: hintColor),
        labelStyle: AppTypography.bodyLarge.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        floatingLabelStyle: AppTypography.labelLarge.copyWith(
          color: colorScheme.primary,
        ),
        errorStyle: AppTypography.bodySmall.copyWith(
          color: colorScheme.error,
        ),
        prefixIconColor: colorScheme.onSurfaceVariant,
        suffixIconColor: colorScheme.onSurfaceVariant,
      ),

      // ── Chips ──
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.primary,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: Colors.white,
        ),
        shape: AppShapes.shapeSm,
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),

      // ── Bottom Navigation ──
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.labelMedium,
      ),

      // ── Navigation Bar (M3) ──
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardColor,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTypography.labelMedium.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: colorScheme.primary,
              size: AppSpacing.iconLg,
            );
          }
          return IconThemeData(
            color: colorScheme.onSurfaceVariant,
            size: AppSpacing.iconLg,
          );
        }),
        height: AppSpacing.bottomNavHeight,
      ),

      // ── Divider ──
      dividerTheme: DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 0,
      ),

      // ── SnackBar ──
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isLight ? AppColors.textPrimaryLight : AppColors.surfaceDark,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: isLight ? Colors.white : AppColors.textPrimaryDark,
        ),
        shape: AppShapes.shapeMd,
        behavior: SnackBarBehavior.floating,
        elevation: 4,
      ),

      // ── Dialog ──
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        shape: AppShapes.shapeXl,
        elevation: 8,
        titleTextStyle: AppTypography.headlineSmall.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // ── Bottom Sheet ──
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: AppShapes.borderRadiusTopXl,
        ),
        elevation: 0,
        showDragHandle: true,
        dragHandleColor: dividerColor,
      ),

      // ── Floating Action Button ──
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shape: const CircleBorder(),
      ),

      // ── Page transitions ──
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
