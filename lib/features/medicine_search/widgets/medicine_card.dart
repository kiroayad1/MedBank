import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';

import '../../../core/theme/theme.dart';
import '../models/medicine_model.dart';

/// Medicine card matching the reference design.
///
/// Shows name, category chip, availability badge, description,
/// quantity, expiry, and location with distance.
class MedicineCard extends StatelessWidget {
  const MedicineCard({
    super.key,
    required this.medicine,
    required this.onTap,
    this.heroTag,
  });

  final Medicine medicine;
  final VoidCallback onTap;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final card = Material(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: AppShapes.borderRadiusLg,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppShapes.borderRadiusLg,
        child: Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            borderRadius: AppShapes.borderRadiusLg,
            border: Border.all(
              color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Name + Availability Badge ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      medicine.name,
                      style: AppTypography.titleLarge.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                  ),
                  AppSpacing.gapHSm,
                  _AvailabilityBadge(isAvailable: medicine.isAvailable),
                ],
              ),
              AppSpacing.gapSm,

              // ── Category Chip ──
              _CategoryChip(category: medicine.category),
              AppSpacing.gapLg,

              // ── Description ──
              Text(
                medicine.description,
                style: AppTypography.bodyMedium.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              AppSpacing.gapLg,

              // ── Metadata Row ──
              Row(
                children: [
                  _MetadataItem(
                    icon: Icons.inventory_2_outlined,
                    text: '${context.l10n.qty}: ${medicine.quantityFormatted}',
                  ),
                  AppSpacing.gapHXl,
                  _MetadataItem(
                    icon: Icons.calendar_today_outlined,
                    text: '${context.l10n.exp}: ${medicine.expiryFormatted}',
                  ),
                ],
              ),
              AppSpacing.gapSm,

              // ── Location ──
              _MetadataItem(
                icon: Icons.location_on_outlined,
                text: '${medicine.location} (${medicine.distanceFormatted})',
              ),
            ],
          ),
        ),
      ),
    );

    if (heroTag != null) {
      return Hero(tag: heroTag!, child: card);
    }
    return card;
  }
}

/// Green "AVAILABLE" / Gray "UNAVAILABLE" badge.
class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.isAvailable});

  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isAvailable
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.disabledLight.withValues(alpha: 0.2),
        borderRadius: AppShapes.borderRadiusFull,
      ),
      child: Text(
        isAvailable ? context.l10n.available.toUpperCase() : context.l10n.unavailable,
        style: AppTypography.labelSmall.copyWith(
          color: isAvailable ? AppColors.success : AppColors.disabledLight,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Color-coded category chip.
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm + 2,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.chipColorForCategory(category),
        borderRadius: AppShapes.borderRadiusSm,
      ),
      child: Text(
        category.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Small icon + text metadata row item.
class _MetadataItem extends StatelessWidget {
  const _MetadataItem({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: AppTypography.bodySmall.copyWith(color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
