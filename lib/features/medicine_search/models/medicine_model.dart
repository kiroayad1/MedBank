/// Medicine Bank — Medicine Data Model
///
/// Core domain model used across search, details, donate, and request features.
class Medicine {
  const Medicine({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    required this.location,
    required this.distance,
    this.description = '',
    this.manufacturer,
    this.condition = 'Sealed',
    this.isAvailable = true,
    this.donorName,
    this.donorPhone,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String category;
  final int quantity;
  final String unit;
  final DateTime expiryDate;
  final String location;
  final double distance;
  final String description;
  final String? manufacturer;
  final String condition;
  final bool isAvailable;
  final String? donorName;
  final String? donorPhone;
  final String? imageUrl;

  /// Formatted expiry string.
  String get expiryFormatted {
    final m = expiryDate.month.toString().padLeft(2, '0');
    final y = expiryDate.year;
    return '$m/$y';
  }

  /// Formatted distance.
  String get distanceFormatted => '${distance.toStringAsFixed(1)} km';

  /// Formatted quantity with unit.
  String get quantityFormatted => '$quantity $unit';

  /// Whether the medicine expires within 3 months.
  bool get isExpiringSoon {
    final threeMonths = DateTime.now().add(const Duration(days: 90));
    return expiryDate.isBefore(threeMonths);
  }

  Medicine copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    String? unit,
    DateTime? expiryDate,
    String? location,
    double? distance,
    String? description,
    String? manufacturer,
    String? condition,
    bool? isAvailable,
    String? donorName,
    String? donorPhone,
    String? imageUrl,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      expiryDate: expiryDate ?? this.expiryDate,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      description: description ?? this.description,
      manufacturer: manufacturer ?? this.manufacturer,
      condition: condition ?? this.condition,
      isAvailable: isAvailable ?? this.isAvailable,
      donorName: donorName ?? this.donorName,
      donorPhone: donorPhone ?? this.donorPhone,
      imageUrl: imageUrl ?? this.imageUrl,
    );
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
