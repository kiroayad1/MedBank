import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';

/// Donate Guidelines screen matching reference design.
class DonateGuidelinesScreen extends StatelessWidget {
  const DonateGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l = context.l10n;

    final guidelines = [
      _Guideline(
        title: l.sealedUnexpired,
        description: l.sealedUnexpiredDesc,
        icon: Icons.check_circle_rounded,
      ),
      _Guideline(
        title: l.threeMonthsMin,
        description: l.threeMonthsMinDesc,
        icon: Icons.check_circle_rounded,
      ),
      _Guideline(
        title: l.originalPackaging,
        description: l.originalPackagingDesc,
        icon: Icons.check_circle_rounded,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l.appName, style: theme.appBarTheme.titleTextStyle),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Hero Section ──
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    decoration: BoxDecoration(
                      gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: AppSpacing.iconCircleLarge,
                          height: AppSpacing.iconCircleLarge,
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.medical_services_rounded,
                            size: 36,
                            color: colors.primary,
                          ),
                        ),
                        AppSpacing.gapXxl,
                        Text(
                          l.donateMedicine,
                          style: AppTypography.displaySmall.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        AppSpacing.gapSm,
                        Padding(
                          padding: AppSpacing.screenPadding,
                          child: Text(
                            l.donateGuidelineDesc,
                            style: AppTypography.bodyMedium.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Guidelines Card ──
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.cardDark
                            : AppColors.cardLight,
                        borderRadius: AppShapes.borderRadiusLg,
                        boxShadow: isDark
                            ? AppShadows.cardDark
                            : AppShadows.cardLight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.checklist_rounded,
                                color: colors.primary,
                                size: 24,
                              ),
                              AppSpacing.gapHSm,
                              Expanded(
                                child: Text(
                                  l.importantGuidelines,
                                  style: AppTypography.headlineSmall.copyWith(
                                    color: colors.onSurface,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          AppSpacing.gapXxl,
                          ...guidelines.map(
                            (g) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: _GuidelineItem(guideline: g),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Warning Note ──
                  Padding(
                    padding: AppSpacing.screenPadding,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.warning.withValues(alpha: 0.15) : AppColors.warningLight,
                        borderRadius: AppShapes.borderRadiusMd,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.warning,
                            size: 20,
                          ),
                          AppSpacing.gapHSm,
                          Expanded(
                            child: Text(
                              l.donateWarning,
                              style: AppTypography.bodySmall.copyWith(
                                color: isDark ? colors.onSurface : const Color(0xFF92400E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AppSpacing.gapXxl,
                ],
              ),
            ),
          ),

          // ── CTA ──
          Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            decoration: BoxDecoration(
              color: isDark ? colors.surface : AppColors.surfaceLight,
            ),
            child: SafeArea(
              top: false,
              child: AppButton(
                label: l.continueToForm,
                icon: Icons.arrow_forward_rounded,
                onPressed: () => context.pushNamed(RouteNames.donateForm),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Guideline {
  const _Guideline({
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;
}

class _GuidelineItem extends StatelessWidget {
  const _GuidelineItem({required this.guideline});
  final _Guideline guideline;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(guideline.icon, color: AppColors.success, size: 22),
        AppSpacing.gapHMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                guideline.title,
                style: AppTypography.titleSmall.copyWith(
                  color: colors.onSurface,
                ),
              ),
              AppSpacing.gapXs,
              Text(
                guideline.description,
                style: AppTypography.bodySmall.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
