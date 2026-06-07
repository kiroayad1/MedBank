import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/medicine_model.dart';
import '../repositories/medicine_repository_provider.dart';

/// Fetches a single medicine by ID.
final medicineDetailsProvider = FutureProvider.family<Medicine, String>((
  ref,
  id,
) async {
  final repo = ref.read(medicineRepositoryProvider);
  return repo.getMedicineById(id);
});
