import '../models/medicine_model.dart';

/// Abstract interface for medicine data access.
abstract class MedicineRepository {
  /// Fetch all medicines.
  Future<List<Medicine>> getMedicines();

  /// Fetch a single medicine by its ID.
  Future<Medicine> getMedicineById(String id);

  /// Fetch medicines filtered by category.
  Future<List<Medicine>> getMedicinesByCategory(String category);
}
