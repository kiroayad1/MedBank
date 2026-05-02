import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';

import '../../../core/theme/theme.dart';
import '../../medicine_search/models/medicine_model.dart';

/// My Donations / My Requests list screen.
/// Shows user's donation or request history with status badges.
class MyActivityListScreen extends StatelessWidget {
  const MyActivityListScreen({super.key, required this.isDonations});
  final bool isDonations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final l = context.l10n;

    // Dummy data
    final items = isDonations
        ? MedicineDummyData.medicines.take(3).toList()
        : MedicineDummyData.medicines.skip(3).take(2).toList();

    // Localized statuses
    final statuses = [l.statusPending, l.statusApproved, l.statusCompleted];

    return Scaffold(
      appBar: AppBar(
        title: Text(isDonations ? l.myDonations : l.myRequests,
            style: AppTypography.appBarBrand.copyWith(color: colors.primary)),
      ),
      body: items.isEmpty
          ? _EmptyState(isDonations: isDonations, colors: colors)
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: items.length,
              separatorBuilder: (_, i) => AppSpacing.gapMd,
              itemBuilder: (context, index) {
                final med = items[index];
                final status = statuses[index % statuses.length];
                return _ActivityCard(
                  medicine: med, status: status, isDark: isDark, colors: colors,
                );
              },
            ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.medicine, required this.status,
    required this.isDark, required this.colors,
  });
  final Medicine medicine;
  final String status;
  final bool isDark;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppShapes.borderRadiusLg,
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(medicine.name,
              style: AppTypography.titleMedium.copyWith(color: colors.onSurface))),
          _StatusBadge(status: status),
        ]),
        AppSpacing.gapSm,
        Text(medicine.category,
            style: AppTypography.labelSmall.copyWith(color: colors.onSurfaceVariant)),
        AppSpacing.gapSm,
        Row(children: [
          Icon(Icons.inventory_2_outlined, size: 14, color: colors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(medicine.quantityFormatted,
              style: AppTypography.bodySmall.copyWith(color: colors.onSurfaceVariant)),
          const SizedBox(width: 16),
          Icon(Icons.calendar_today_outlined, size: 14, color: colors.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(medicine.expiryFormatted,
              style: AppTypography.bodySmall.copyWith(color: colors.onSurfaceVariant)),
        ]),
      ]),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  Color _color(BuildContext context) {
    final l = context.l10n;
    if (status == l.statusPending) return const Color(0xFFEAB308);
    if (status == l.statusApproved) return const Color(0xFF3B82F6);
    if (status == l.statusCompleted) return AppColors.success;
    return AppColors.disabledLight;
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppShapes.borderRadiusFull,
      ),
      child: Text(status,
          style: AppTypography.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isDonations, required this.colors});
  final bool isDonations;
  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(isDonations ? Icons.volunteer_activism_outlined : Icons.medication_outlined,
            size: 64, color: colors.onSurfaceVariant.withValues(alpha: 0.3)),
        AppSpacing.gapLg,
        Text(isDonations ? l.noDonationsYet : l.noRequestsYet,
            style: AppTypography.titleMedium.copyWith(color: colors.onSurface)),
        AppSpacing.gapSm,
        Text(isDonations ? l.startDonating : l.startRequesting,
            style: AppTypography.bodyMedium.copyWith(color: colors.onSurfaceVariant),
            textAlign: TextAlign.center),
      ]),
    );
  }
}
