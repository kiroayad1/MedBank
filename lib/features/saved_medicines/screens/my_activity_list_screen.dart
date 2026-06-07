import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../medicine_search/providers/donation_provider.dart';
import '../../medicine_search/providers/request_provider.dart';

/// My Donations / My Requests list screen.
/// Shows user's donation or request history with status badges.
class MyActivityListScreen extends ConsumerWidget {
  const MyActivityListScreen({super.key, required this.isDonations});
  final bool isDonations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final l = context.l10n;

    // Fetch real data from providers
    final items = isDonations
        ? ref.watch(donationProvider).donations
        : ref.watch(requestProvider).requests;
    final isLoading = isDonations
        ? ref.watch(donationProvider).isLoading
        : ref.watch(requestProvider).isLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isDonations ? l.myDonations : l.myRequests,
          style: AppTypography.appBarBrand.copyWith(color: colors.primary),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
          ? _EmptyState(isDonations: isDonations, colors: colors)
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: items.length,
              separatorBuilder: (_, i) => AppSpacing.gapMd,
              itemBuilder: (context, index) {
                final item = items[index];
                return _ActivityCard(
                  item: item,
                  isDark: isDark,
                  colors: colors,
                  isDonations: isDonations,
                );
              },
            ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.item,
    required this.isDark,
    required this.colors,
    required this.isDonations,
  });
  final dynamic item; // DonationModel or RequestModel
  final bool isDark;
  final ColorScheme colors;
  final bool isDonations;

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final name = item.localizedName(localeCode);
    final quantity = item.quantity;
    final date = isDonations ? item.donationDate : item.requestDate;
    final status = item.status;

    final dateFormatted =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppShapes.borderRadiusLg,
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: AppTypography.titleMedium.copyWith(
                    color: colors.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _StatusBadge(status: status),
            ],
          ),
          AppSpacing.gapSm,
          Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 14,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '$quantity Units',
                style: AppTypography.bodySmall.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                dateFormatted,
                style: AppTypography.bodySmall.copyWith(
                  color: colors.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  Color _color(BuildContext context) {
    final s = status.toLowerCase();
    if (s == 'pending') return const Color(0xFFEAB308);
    if (s == 'approved') return const Color(0xFF3B82F6);
    if (s == 'completed' || s == 'received' || s == 'delivered') return AppColors.success;
    return AppColors.disabledLight;
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: AppShapes.borderRadiusFull,
        ),
        child: Text(
          status,
          style: AppTypography.labelSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDonations
                ? Icons.volunteer_activism_outlined
                : Icons.medication_outlined,
            size: 64,
            color: colors.onSurfaceVariant.withValues(alpha: 0.3),
          ),
          AppSpacing.gapLg,
          Text(
            isDonations ? l.noDonationsYet : l.noRequestsYet,
            style: AppTypography.titleMedium.copyWith(color: colors.onSurface),
          ),
          AppSpacing.gapSm,
          Text(
            isDonations ? l.startDonating : l.startRequesting,
            style: AppTypography.bodyMedium.copyWith(
              color: colors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
