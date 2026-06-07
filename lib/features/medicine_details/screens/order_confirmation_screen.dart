import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../medicine_search/models/medicine_model.dart';

/// Order confirmation screen — shown after tapping "Request This Medicine".
///
/// Displays the medicine in a cart-like view with quantity adjustment,
/// price breakdown (original price crossed out, shipping fees, total),
/// and a "Confirm Order" CTA.
class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key, required this.medicine});

  final Medicine medicine;

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  int _quantity = 1;

  Medicine get _medicine => widget.medicine;

  // Simulated pricing (medicines are donated; only shipping is charged)
  static const double _shippingFee = 10.0;

  double get _originalPrice => _quantity * 46.0; // illustrative original value
  double get _totalToPay => _shippingFee; // user only pays shipping

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l = context.l10n;
    final medicine = _medicine;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l.orderList, style: theme.appBarTheme.titleTextStyle),
            const SizedBox(width: 8),
            // Item count badge
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: colors.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$_quantity',
                  style: AppTypography.labelSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSpacing.cardPaddingLarge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Medicine Item Card ──
                  Container(
                    padding: const EdgeInsets.all(16),
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
                        // Medicine name & unit
                        Text(
                          medicine.localizedName(l.locale.languageCode),
                          style: AppTypography.titleMedium.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          medicine.unit.toLowerCase(),
                          style: AppTypography.bodySmall.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Image + Quantity row
                        Row(
                          children: [
                            // Medicine image placeholder
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.surfaceDark
                                    : const Color(0xFFEDF2F7),
                                borderRadius: AppShapes.borderRadiusMd,
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.outlineDark
                                      : AppColors.outlineLight,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.medication_rounded,
                                  size: 40,
                                  color: colors.primary,
                                ),
                              ),
                            ),
                            const Spacer(),
                            // Quantity selector
                            _QuantitySelector(
                              quantity: _quantity,
                              maxQuantity: medicine.quantity,
                              onChanged: (v) => setState(() => _quantity = v),
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Price Breakdown ──
                  Container(
                    padding: AppSpacing.cardPaddingLarge,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: AppShapes.borderRadiusLg,
                      boxShadow: isDark
                          ? AppShadows.cardDark
                          : AppShadows.cardLight,
                    ),
                    child: Column(
                      children: [
                        _PriceRow(
                          label: l.medicinesOriginalPrice,
                          value:
                              '${_originalPrice.toStringAsFixed(0)} ${l.egp}',
                          isStrikethrough: true,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 12),
                        _PriceRow(
                          label: l.shippingFees,
                          value: '${_shippingFee.toStringAsFixed(0)} ${l.egp}',
                          isDark: isDark,
                        ),
                        const SizedBox(height: 16),
                        Divider(
                          color: isDark
                              ? AppColors.dividerDark
                              : AppColors.dividerLight,
                          height: 1,
                        ),
                        const SizedBox(height: 16),
                        _PriceRow(
                          label: l.totalToPay,
                          value: '${_totalToPay.toStringAsFixed(0)} ${l.egp}',
                          isTotal: true,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Confirm Order Button ──
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              boxShadow: isDark
                  ? AppShadows.none
                  : [
                      const BoxShadow(
                        color: Color(0x08000000),
                        blurRadius: 8,
                        offset: Offset(0, -2),
                      ),
                    ],
            ),
            child: AppButton(
              label: l.confirmOrder,
              onPressed: () {
                context.goNamed(
                  RouteNames.success,
                  queryParameters: {'type': 'donation'},
                );
              },
              icon: Icons.check_circle_outline_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quantity Selector Widget ──
class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.quantity,
    required this.maxQuantity,
    required this.onChanged,
    required this.isDark,
  });

  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDark ? AppColors.outlineDark : AppColors.outlineLight,
        ),
        borderRadius: AppShapes.borderRadiusMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
            isDark: isDark,
          ),
          Container(
            width: 44,
            alignment: Alignment.center,
            child: Text(
              '$quantity',
              style: AppTypography.titleMedium.copyWith(
                color: colors.onSurface,
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add,
            onTap: quantity < maxQuantity
                ? () => onChanged(quantity + 1)
                : null,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    final colors = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppShapes.borderRadiusSm,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            size: 20,
            color: isDisabled
                ? (isDark ? AppColors.disabledDark : AppColors.disabledLight)
                : colors.primary,
          ),
        ),
      ),
    );
  }
}

// ── Price Row Widget ──
class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
    this.isStrikethrough = false,
    this.isTotal = false,
    required this.isDark,
  });

  final String label;
  final String value;
  final bool isStrikethrough;
  final bool isTotal;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final labelStyle = isTotal
        ? AppTypography.titleMedium.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w700,
          )
        : AppTypography.bodyMedium.copyWith(color: colors.onSurfaceVariant);

    final valueStyle = isTotal
        ? AppTypography.titleMedium.copyWith(
            color: colors.primary,
            fontWeight: FontWeight.w700,
          )
        : AppTypography.bodyMedium.copyWith(
            color: colors.onSurface,
            decoration: isStrikethrough ? TextDecoration.lineThrough : null,
            decorationColor: colors.onSurfaceVariant,
          );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: labelStyle)),
        const SizedBox(width: 16),
        Text(value, style: valueStyle),
      ],
    );
  }
}
