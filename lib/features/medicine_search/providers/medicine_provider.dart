import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/medicine_model.dart';
import '../repositories/medicine_repository_provider.dart';

/// State for the browse/search screen.
class MedicineSearchState {
  const MedicineSearchState({
    this.medicines = const [],
    this.filteredMedicines = const [],
    this.isLoading = true,
    this.searchQuery = '',
    this.selectedCategory,
    this.errorMessage,
  });

  final List<Medicine> medicines;
  final List<Medicine> filteredMedicines;
  final bool isLoading;
  final String searchQuery;
  final String? selectedCategory;
  final String? errorMessage;

  MedicineSearchState copyWith({
    List<Medicine>? medicines,
    List<Medicine>? filteredMedicines,
    bool? isLoading,
    String? searchQuery,
    String? Function()? selectedCategory,
    String? Function()? errorMessage,
  }) {
    return MedicineSearchState(
      medicines: medicines ?? this.medicines,
      filteredMedicines: filteredMedicines ?? this.filteredMedicines,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory != null
          ? selectedCategory()
          : this.selectedCategory,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

class MedicineSearchNotifier extends Notifier<MedicineSearchState> {
  Timer? _debounce;

  @override
  MedicineSearchState build() {
    ref.onDispose(() => _debounce?.cancel());
    // Load data on init
    Future.microtask(_loadMedicines);
    return const MedicineSearchState();
  }

  Future<void> _loadMedicines() async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    try {
      final repo = ref.read(medicineRepositoryProvider);
      final data = await repo.getMedicines();

      state = state.copyWith(
        medicines: data,
        filteredMedicines: data,
        isLoading: false,
      );
      _applyFilters();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Failed to load medicines: $e',
      );
    }
  }

  /// Debounced search to avoid excessive filtering.
  void search(String query) {
    state = state.copyWith(searchQuery: query);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _applyFilters();
    });
  }

  /// Filter by category.
  void selectCategory(String? category) {
    state = state.copyWith(selectedCategory: () => category);
    _applyFilters();
  }

  /// Clear all filters.
  void clearFilters() {
    state = state.copyWith(
      searchQuery: '',
      selectedCategory: () => null,
      filteredMedicines: state.medicines,
    );
  }

  void _applyFilters() {
    var results = state.medicines;

    // Search filter
    final query = state.searchQuery.trim().toLowerCase();
    if (query.isNotEmpty) {
      results = results.where((m) {
        return m.name.toLowerCase().contains(query) ||
            (m.arName?.toLowerCase().contains(query) ?? false) ||
            m.category.toLowerCase().contains(query) ||
            m.description.toLowerCase().contains(query) ||
            m.location.toLowerCase().contains(query);
      }).toList();
    }

    // Category filter
    if (state.selectedCategory != null) {
      results = results
          .where((m) => m.category == state.selectedCategory)
          .toList();
    }

    state = state.copyWith(filteredMedicines: results);
  }

  /// Refresh data from source.
  Future<void> refresh() async {
    await _loadMedicines();
  }
}

final medicineSearchProvider =
    NotifierProvider<MedicineSearchNotifier, MedicineSearchState>(
      MedicineSearchNotifier.new,
    );
