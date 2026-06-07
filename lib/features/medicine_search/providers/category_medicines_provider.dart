import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/medicine_model.dart';
import '../repositories/medicine_repository_provider.dart';

/// Fetches medicines filtered by category.
final categoryMedicinesProvider = FutureProvider.family<List<Medicine>, String>(
  (ref, category) async {
    final repo = ref.read(medicineRepositoryProvider);
    return repo.getMedicinesByCategory(category);
  },
);
