import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/theme.dart';

/// Shimmer loading placeholder for medicine cards.
///
/// Renders a skeleton that mimics the medicine card layout
/// while data is being fetched.
class ShimmerMedicineCard extends StatelessWidget {
  const ShimmerMedicineCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF2A2F3D) : const Color(0xFFE8ECF0);
    final highlightColor = isDark ? const Color(0xFF363C4A) : const Color(0xFFF5F7FA);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: AppDurations.shimmer,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: AppShapes.borderRadiusLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + badge row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _shimmerBox(width: 160, height: 18),
                _shimmerBox(width: 80, height: 22, radius: AppShapes.radiusFull),
              ],
            ),
            AppSpacing.gapSm,
            // Category chip
            _shimmerBox(width: 90, height: 24, radius: AppShapes.radiusSm),
            AppSpacing.gapLg,
            // Description lines
            _shimmerBox(width: double.infinity, height: 14),
            AppSpacing.gapSm,
            _shimmerBox(width: 220, height: 14),
            AppSpacing.gapLg,
            // Metadata row
            Row(
              children: [
                _shimmerBox(width: 60, height: 14),
                AppSpacing.gapHXl,
                _shimmerBox(width: 90, height: 14),
              ],
            ),
            AppSpacing.gapSm,
            // Location
            _shimmerBox(width: 180, height: 14),
          ],
        ),
      ),
    );
  }

  static Widget _shimmerBox({
    required double height,
    double? width,
    double radius = 6,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Shimmer list — shows N skeleton cards.
class ShimmerMedicineList extends StatelessWidget {
  const ShimmerMedicineList({super.key, this.count = 4});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (_) => const ShimmerMedicineCard(),
      ),
    );
  }
}
