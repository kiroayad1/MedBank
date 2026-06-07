import '../../../core/network/services/medicine_service.dart';
import '../models/medicine_model.dart';
import 'medicine_repository.dart';

/// Real implementation that calls the backend API.
class MedicineApiRepository implements MedicineRepository {
  @override
  Future<List<Medicine>> getMedicines() async {
    final res = await MedicineService.instance.getAll();
    return res.map((json) => Medicine.fromJson(json)).toList();
  }

  @override
  Future<Medicine> getMedicineById(String id) async {
    final res = await MedicineService.instance.getById(int.parse(id));
    return Medicine.fromJson(res);
  }

  @override
  Future<List<Medicine>> getMedicinesByCategory(String category) async {
    final res = await MedicineService.instance.getByCategory(category);
    return res.map((json) => Medicine.fromJson(json)).toList();
  }
}
