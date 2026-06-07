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
    this.arName,
    this.dosageForm,
    this.strength,
    this.price,
    this.popularity,
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
  final String? arName;
  final String? dosageForm;
  final String? strength;
  final double? price;
  final int? popularity;

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

  /// Returns the localized name based on locale code.
  /// Use 'ar' for Arabic, anything else for English.
  String localizedName(String localeCode) {
    if (localeCode == 'ar' && arName != null && arName!.isNotEmpty) {
      return arName!;
    }
    return name;
  }

  /// Whether the medicine expires within 3 months.
  bool get isExpiringSoon {
    final threeMonths = DateTime.now().add(const Duration(days: 90));
    return expiryDate.isBefore(threeMonths);
  }

  /// Create Medicine from backend JSON response.
  factory Medicine.fromJson(Map<String, dynamic> json) {
    // Parse expiryDate — backend sends "MM/YYYY" format
    DateTime expiry;
    try {
      final parts = (json['expiryDate'] as String? ?? '01/2030').split('/');
      if (parts.length == 2) {
        expiry = DateTime(int.parse(parts[1]), int.parse(parts[0]));
      } else {
        expiry = DateTime.tryParse(json['expiryDate'] ?? '') ?? DateTime(2030);
      }
    } catch (_) {
      expiry = DateTime(2030);
    }

    // Derive unit from dosageForm
    final dosageForm = json['dosageForm'] as String?;
    String unit = 'Units';
    if (dosageForm != null) {
      switch (dosageForm.toLowerCase()) {
        case 'tablet':
          unit = 'Tablets';
        case 'capsule':
          unit = 'Capsules';
        case 'syrup':
        case 'suspension':
          unit = 'ml';
        case 'injection':
          unit = 'Vials';
        case 'cream':
        case 'gel':
          unit = 'Tubes';
        case 'drops':
          unit = 'Drops';
        case 'inhaler':
          unit = 'Puffs';
        case 'spray':
          unit = 'Sprays';
        case 'softgel':
          unit = 'Softgels';
        default:
          unit = 'Units';
      }
    }

    return Medicine(
      id: json['id'].toString(),
      name: json['name'] as String? ?? 'Unknown',
      category: json['category'] as String? ?? 'Other',
      quantity: json['quantity'] as int? ?? 0,
      unit: unit,
      expiryDate: expiry,
      location: json['location'] as String? ?? 'Cairo',
      distance: 0.0, // Backend doesn't have distance — could compute from GPS
      description: json['description'] as String? ?? '',
      manufacturer: json['manufacturer'] as String?,
      condition: json['condition'] as String? ?? 'Sealed',
      isAvailable: (json['quantity'] as int? ?? 0) > 0,
      donorName: json['donorName'] as String?,
      donorPhone: null,
      imageUrl: json['imageUrl'] as String?,
      arName: json['arName'] as String?,
      dosageForm: dosageForm,
      strength: json['strength'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      popularity: json['popularity'] as int?,
    );
  }

  /// Serialize to JSON for API requests.
  Map<String, dynamic> toJson() => {
        'name': name,
        'arName': arName,
        'description': description,
        'expiryDate': expiryFormatted,
        'quantity': quantity,
        'price': price ?? 0,
        'imageUrl': imageUrl,
        'category': category,
        'manufacturer': manufacturer,
        'condition': condition,
        'dosageForm': dosageForm,
        'strength': strength,
        'location': location,
      };

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
    String? arName,
    String? dosageForm,
    String? strength,
    double? price,
    int? popularity,
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
      arName: arName ?? this.arName,
      dosageForm: dosageForm ?? this.dosageForm,
      strength: strength ?? this.strength,
      price: price ?? this.price,
      popularity: popularity ?? this.popularity,
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
