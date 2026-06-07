import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/network/api_config.dart';
import '../../../core/network/services/medicine_service.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../medicine_search/models/medicine_model.dart';

/// Medicine Details screen with Hero animation support.
///
/// Shows full details for a medicine: name, category, description,
/// quantity, expiry, location, condition, manufacturer.
class MedicineDetailsScreen extends ConsumerStatefulWidget {
  const MedicineDetailsScreen({super.key, required this.medicineId});

  final String medicineId;

  @override
  ConsumerState<MedicineDetailsScreen> createState() =>
      _MedicineDetailsScreenState();
}

class _MedicineDetailsScreenState extends ConsumerState<MedicineDetailsScreen> {
  Medicine? _medicine;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadMedicine();
  }

  Future<void> _loadMedicine() async {
    if (!ApiConfig.useLiveBackend) {
      final found = MedicineDummyData.medicines.firstWhere(
        (m) => m.id == widget.medicineId,
        orElse: () => MedicineDummyData.medicines.first,
      );
      setState(() {
        _medicine = found;
        _isLoading = false;
      });
      return;
    }

    try {
      final res = await MedicineService.instance.getById(
        int.parse(widget.medicineId),
      );
      setState(() {
        _medicine = Medicine.fromJson(res);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load medicine: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l = context.l10n;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l.appName, style: theme.appBarTheme.titleTextStyle),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _medicine == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l.appName, style: theme.appBarTheme.titleTextStyle),
        ),
        body: Center(child: Text(_error ?? 'Medicine not found')),
      );
    }

    final medicine = _medicine!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.appName, style: theme.appBarTheme.titleTextStyle),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Header ──
            Hero(
              tag: 'medicine_${medicine.id}',
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              medicine.localizedName(l.locale.languageCode),
                              style: AppTypography.displaySmall.copyWith(
                                color: colors.onSurface,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _AvailabilityBadge(isAvailable: medicine.isAvailable),
                        ],
                      ),
                      AppSpacing.gapSm,
                      _CategoryChip(category: l.categoryDisplay(medicine.category)),
                    ],
                  ),
                ),
              ),
            ),

            // ── Details Card ──
            Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: AppSpacing.cardPaddingLarge,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: AppShapes.borderRadiusLg,
                  boxShadow: isDark
                      ? AppShadows.cardDark
                      : AppShadows.cardLight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.description,
                      style: AppTypography.titleMedium.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    AppSpacing.gapSm,
                    Text(
                      medicine.description,
                      style: AppTypography.bodyMedium.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.6,
                      ),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapXxl,

                    // ── Info Grid ──
                    _InfoRow(
                      icon: Icons.inventory_2_outlined,
                      label: l.quantity,
                      value: medicine.quantityFormatted,
                    ),
                    AppSpacing.gapLg,
                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      label: l.expiryDate,
                      value: medicine.expiryFormatted,
                      valueColor: medicine.isExpiringSoon
                          ? AppColors.warning
                          : null,
                    ),
                    AppSpacing.gapLg,
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      label: l.location,
                      value:
                          '${medicine.location} (${medicine.distanceFormatted})',
                    ),
                    AppSpacing.gapLg,
                    _InfoRow(
                      icon: Icons.verified_outlined,
                      label: l.condition,
                      value: medicine.condition,
                    ),
                    if (medicine.manufacturer != null) ...[
                      AppSpacing.gapLg,
                      _InfoRow(
                        icon: Icons.factory_outlined,
                        label: l.manufacturer,
                        value: medicine.manufacturer!,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // ── Request Button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: AppButton(
                label: l.requestThisMedicine,
                onPressed: () {
                  context.pushNamed(
                    RouteNames.requestForm,
                    queryParameters: {
                      'id': medicine.id,
                      'name': medicine.localizedName(l.locale.languageCode),
                      'category': medicine.category,
                      'unit': medicine.unit,
                    },
                  );
                },
                icon: Icons.check_circle_outline_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.isAvailable});
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 110),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isAvailable
              ? AppColors.success.withValues(alpha: 0.1)
              : AppColors.disabledLight.withValues(alpha: 0.2),
          borderRadius: AppShapes.borderRadiusFull,
        ),
        child: Text(
          isAvailable
              ? context.l10n.available.toUpperCase()
              : context.l10n.unavailable,
          style: AppTypography.labelMedium.copyWith(
            color: isAvailable ? AppColors.success : AppColors.disabledLight,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.chipColorForCategory(category),
          borderRadius: AppShapes.borderRadiusSm,
        ),
        child: Text(
          category.toUpperCase(),
          style: AppTypography.labelSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.08),
            borderRadius: AppShapes.borderRadiusSm,
          ),
          child: Icon(icon, size: 18, color: colors.primary),
        ),
        AppSpacing.gapHMd,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              Text(
                value,
                style: AppTypography.bodyMedium.copyWith(
                  color: valueColor ?? colors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
