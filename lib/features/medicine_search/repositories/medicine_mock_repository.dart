import '../models/medicine_model.dart';
import 'medicine_repository.dart';

/// Mock implementation that returns local dummy data.
class MedicineMockRepository implements MedicineRepository {
  @override
  Future<List<Medicine>> getMedicines() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return MedicineDummyData.medicines;
  }

  @override
  Future<Medicine> getMedicineById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MedicineDummyData.medicines.firstWhere(
      (m) => m.id == id,
      orElse: () => MedicineDummyData.medicines.first,
    );
  }

  @override
  Future<List<Medicine>> getMedicinesByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MedicineDummyData.medicines
        .where((m) => m.category == category)
        .toList();
  }
}

/// Dummy data for development — matches reference images.
abstract final class MedicineDummyData {
  static final List<Medicine> medicines = [
    Medicine(
      id: '1',
      name: 'Amoxicillin 250mg',
      category: 'Antibiotic',
      quantity: 25,
      unit: 'Capsules',
      expiryDate: DateTime(2026, 12, 15),
      location: 'Downtown Clinic Area',
      distance: 2.5,
      description:
          'Unopened box of 20 capsules. Prescribed but no longer needed. Kept in cool, dry place.',
      manufacturer: 'Pfizer',
      condition: 'Sealed',
    ),
    Medicine(
      id: '2',
      name: 'Ibuprofen 400mg',
      category: 'Painkiller',
      quantity: 45,
      unit: 'Tablets',
      expiryDate: DateTime(2027, 5, 20),
      location: 'Westside Pharmacy Hub',
      distance: 1.2,
      description:
          'Sealed blister packs. Standard pain relief medication. Donating surplus supply.',
      manufacturer: 'GSK',
      condition: 'Sealed',
    ),
    Medicine(
      id: '3',
      name: 'Metformin 500mg',
      category: 'Diabetes',
      quantity: 60,
      unit: 'Tablets',
      expiryDate: DateTime(2026, 12, 28),
      location: 'North Community Center',
      distance: 4.5,
      description:
          'Two full boxes, sealed. Switched medication plan recently. Valid prescription required to request.',
      manufacturer: 'Merck',
      condition: 'Unopened',
    ),
    Medicine(
      id: '4',
      name: 'Vitamin D3 1000 IU',
      category: 'Vitamins',
      quantity: 80,
      unit: 'Tablets',
      expiryDate: DateTime(2028, 8, 15),
      location: 'Eastside Suburbs',
      distance: 5.1,
      description:
          'Partially used bottle, about 80% full. Clean and securely capped. Daily supplement.',
      condition: 'Partially Used',
    ),
    Medicine(
      id: '5',
      name: 'Lisinopril 10mg',
      category: 'Heart',
      quantity: 30,
      unit: 'Tablets',
      expiryDate: DateTime(2027, 3, 10),
      location: 'Central Medical District',
      distance: 3.2,
      description:
          'Full sealed bottle. Dosage changed by doctor, no longer needed at this strength.',
      manufacturer: 'AstraZeneca',
      condition: 'Sealed',
    ),
    Medicine(
      id: '6',
      name: 'Cetirizine 10mg',
      category: 'Allergy',
      quantity: 20,
      unit: 'Tablets',
      expiryDate: DateTime(2027, 7, 1),
      location: 'Riverside Pharmacy',
      distance: 2.8,
      description:
          'Sealed strip pack. Antihistamine for seasonal allergies. Purchased extra by mistake.',
      manufacturer: 'Johnson & Johnson',
      condition: 'Sealed',
    ),
  ];
}
