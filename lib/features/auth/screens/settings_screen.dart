import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/providers/app_settings_provider.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';

/// Settings screen — working dark mode + Arabic/English language switch.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.settings,
            style: AppTypography.appBarBrand.copyWith(color: colors.primary)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── Preferences ──
          _card(isDark, [
            // Dark Mode — sun icon when light (OFF), moon icon when dark (ON)
            _switchTile(
              l.darkMode,
              settings.isDarkMode
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              settings.isDarkMode,
              (v) => notifier.toggleThemeMode(),
              colors,
            ),
            _divider(isDark),

            // Language toggle
            _languageTile(context, ref, colors, settings, l),
          ]),
          AppSpacing.gapLg,

          // ── About ──
          _card(isDark, [
            _infoTile(l.appVersion, AppConstants.appVersion,
                Icons.info_outline_rounded, colors),
          ]),
          AppSpacing.gapXxl,

          // ── Delete Account ──
          AppButton(
            label: l.deleteAccount,
            variant: AppButtonVariant.text,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l.deleteAccountMsg)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _card(bool isDark, List<Widget> children) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppShapes.borderRadiusLg,
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(bool isDark) => Divider(
      height: 1,
      color: isDark ? AppColors.dividerDark : AppColors.dividerLight);

  Widget _switchTile(String title, IconData icon, bool value,
      ValueChanged<bool> onChanged, ColorScheme c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Row(children: [
        Icon(icon, size: 20, color: c.onSurfaceVariant),
        const SizedBox(width: 14),
        Expanded(
            child: Text(title,
                style:
                    AppTypography.titleSmall.copyWith(color: c.onSurface))),
        Switch(value: value, onChanged: onChanged),
      ]),
    );
  }

  Widget _languageTile(BuildContext context, WidgetRef ref,
      ColorScheme colors, AppSettings settings, S l) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => ref.read(appSettingsProvider.notifier).toggleLocale(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(children: [
            Icon(Icons.language_rounded, size: 20,
                color: colors.onSurfaceVariant),
            const SizedBox(width: 14),
            Expanded(
              child: Text(l.language,
                  style: AppTypography.titleSmall
                      .copyWith(color: colors.onSurface)),
            ),
            // Language chip
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.08),
                borderRadius: AppShapes.borderRadiusFull,
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(
                  settings.isArabic ? 'العربية' : 'English',
                  style: AppTypography.labelMedium
                      .copyWith(color: colors.primary),
                ),
                const SizedBox(width: 4),
                Icon(Icons.swap_horiz_rounded,
                    size: 16, color: colors.primary),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _infoTile(
      String title, String value, IconData icon, ColorScheme c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(children: [
        Icon(icon, size: 20, color: c.onSurfaceVariant),
        const SizedBox(width: 14),
        Expanded(
            child: Text(title,
                style:
                    AppTypography.titleSmall.copyWith(color: c.onSurface))),
        Text(value,
            style:
                AppTypography.bodySmall.copyWith(color: c.onSurfaceVariant)),
      ]),
    );
  }
}
