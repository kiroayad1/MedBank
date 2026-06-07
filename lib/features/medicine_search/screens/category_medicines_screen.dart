import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/widgets/app_button.dart';
import '../providers/category_medicines_provider.dart';

/// Screen displaying a list of medicines filtered by a specific category.
class CategoryMedicinesScreen extends ConsumerWidget {
  const CategoryMedicinesScreen({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l = context.l10n;

    final medicinesAsync = ref.watch(categoryMedicinesProvider(category));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.categoryDisplay(category),
          style: AppTypography.headlineSmall.copyWith(color: colors.onSurface),
        ),
      ),
      body: medicinesAsync.when(
        data: (medicines) {
          if (medicines.isEmpty) {
            return Center(child: Text(l.noMedicinesFound));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            itemCount: medicines.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final med = medicines[index];
              return _CategoryMedicineCard(
                name: med.localizedName(l.locale.languageCode),
                qty: med.quantity,
                unit: med.unit,
                condition: med.condition,
                onRequestTap: () {
                  context.pushNamed(
                    RouteNames.medicineDetails,
                    pathParameters: {'id': med.id},
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load: $error')),
      ),
    );
  }
}

class _CategoryMedicineCard extends StatelessWidget {
  const _CategoryMedicineCard({
    required this.name,
    required this.qty,
    required this.unit,
    required this.condition,
    required this.onRequestTap,
  });

  final String name;
  final int qty;
  final String unit;
  final String condition;
  final VoidCallback onRequestTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l = context.l10n;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppShapes.borderRadiusLg,
        border: Border.all(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Placeholder
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.1),
                  borderRadius: AppShapes.borderRadiusMd,
                ),
                child: Icon(
                  Icons.medication_outlined,
                  color: colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.titleMedium.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _Badge(
                          icon: Icons.inventory_2_outlined,
                          text: '${l.qty}: $qty $unit',
                          colors: colors,
                        ),
                        _Badge(
                          icon: Icons.verified_outlined,
                          text: condition,
                          colors: colors,
                          isHighlight: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Request Button
          SizedBox(
            width: double.infinity,
            child: AppButton(label: l.requestMedicine, onPressed: onRequestTap),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.text,
    required this.colors,
    this.isHighlight = false,
  });

  final IconData icon;
  final String text;
  final ColorScheme colors;
  final bool isHighlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isHighlight
            ? colors.secondaryContainer.withValues(alpha: 0.5)
            : colors.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isHighlight ? colors.secondary : colors.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTypography.labelMedium.copyWith(
              color: isHighlight ? colors.secondary : colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
