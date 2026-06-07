import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/shimmer_loading.dart';
import '../providers/medicine_provider.dart';
import '../widgets/medicine_card.dart';

/// Browse Medicines screen — matching reference design.
class BrowseScreen extends ConsumerStatefulWidget {
  const BrowseScreen({super.key});

  @override
  ConsumerState<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends ConsumerState<BrowseScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(medicineSearchProvider);
    final notifier = ref.read(medicineSearchProvider.notifier);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.appName, style: theme.appBarTheme.titleTextStyle),
      ),
      body: RefreshIndicator(
        onRefresh: notifier.refresh,
        color: colors.primary,
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.availableMedicines,
                      style: AppTypography.displayMedium.copyWith(
                        color: colors.onSurface,
                      ),
                    ),
                    AppSpacing.gapSm,
                    Text(
                      l.browseDescription,
                      style: AppTypography.bodyMedium.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    AppSpacing.gapXxl,

                    // ── Search Bar ──
                    _SearchBar(
                      controller: _searchController,
                      onChanged: notifier.search,
                    ),
                    AppSpacing.gapMd,

                    // ── Category Filter ──
                    _CategoryDropdown(
                      selectedCategory: state.selectedCategory,
                      onChanged: notifier.selectCategory,
                    ),
                    AppSpacing.gapXxl,
                  ],
                ),
              ),
            ),

            // ── Medicine List ──
            if (state.isLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: ShimmerMedicineList(count: 4),
                ),
              )
            else if (state.filteredMedicines.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(
                  hasFilters:
                      state.searchQuery.isNotEmpty ||
                      state.selectedCategory != null,
                  onClear: notifier.clearFilters,
                ),
              )
            else
              SliverPadding(
                padding: AppSpacing.screenPadding,
                sliver: SliverList.separated(
                  itemCount: state.filteredMedicines.length,
                  separatorBuilder: (context, index) => AppSpacing.gapMd,
                  itemBuilder: (context, index) {
                    final medicine = state.filteredMedicines[index];
                    return _AnimatedMedicineCard(
                      index: index,
                      medicine: medicine,
                      onTap: () => context.pushNamed(
                        RouteNames.medicineDetails,
                        pathParameters: {'id': medicine.id},
                      ),
                    );
                  },
                ),
              ),

            // Bottom padding
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

/// Animated wrapper for medicine cards — stagger effect on first load.
class _AnimatedMedicineCard extends StatefulWidget {
  const _AnimatedMedicineCard({
    required this.index,
    required this.medicine,
    required this.onTap,
  });

  final int index;
  final dynamic medicine;
  final VoidCallback onTap;

  @override
  State<_AnimatedMedicineCard> createState() => _AnimatedMedicineCardState();
}

class _AnimatedMedicineCardState extends State<_AnimatedMedicineCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.moderate,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: AppDurations.entrance,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(_fadeAnimation);

    // Stagger the start
    Future.delayed(AppDurations.stagger * widget.index, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: MedicineCard(
          medicine: widget.medicine,
          onTap: widget.onTap,
          heroTag: 'medicine_${widget.medicine.id}',
        ),
      ),
    );
  }
}

/// Search bar matching reference design.
class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l = context.l10n;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTypography.bodyLarge.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: l.searchMedicines,
        prefixIcon: Icon(
          Icons.search_rounded,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: AppShapes.inputBorder(color: AppColors.dividerLight),
        enabledBorder: AppShapes.inputBorder(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
        focusedBorder: AppShapes.inputBorderFocused(
          color: theme.colorScheme.primary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}

/// Category dropdown matching reference design.
class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.selectedCategory,
    required this.onChanged,
  });

  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l = context.l10n;
    final categoryItems = l.browseCategoryItems;

    // Defensive: only set initialValue if it exists in the items
    final validInitial = selectedCategory != null &&
        categoryItems.any((e) => e.value == selectedCategory)
        ? selectedCategory
        : null;

    return DropdownButtonFormField<String>(
      key: ValueKey('category_dropdown_${validInitial ?? "null"}_${l.locale.languageCode}'),
      initialValue: validInitial,
      decoration: InputDecoration(
        filled: true,
        fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: AppShapes.inputBorder(color: AppColors.dividerLight),
        enabledBorder: AppShapes.inputBorder(
          color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
      hint: Text(
        l.category,
        style: AppTypography.bodyLarge.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text(
            l.allCategories,
            style: AppTypography.bodyLarge.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        ...categoryItems.map(
          (entry) => DropdownMenuItem(
            value: entry.value,
            child: Text(
              entry.key,
              style: AppTypography.bodyLarge.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
      onChanged: onChanged,
    );
  }
}

/// Empty state when no medicines match filters.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFilters, required this.onClear});

  final bool hasFilters;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;

    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.medication_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
            AppSpacing.gapLg,
            Text(
              hasFilters ? l.noMedicinesFound : l.noMedicinesAvailable,
              style: theme.textTheme.titleLarge,
            ),
            if (hasFilters) ...[
              AppSpacing.gapXxl,
              TextButton(onPressed: onClear, child: Text(l.clearFilters)),
            ],
          ],
        ),
      ),
    );
  }
}
