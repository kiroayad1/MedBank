/// MedBank — Pharmacy Model

class PharmacyModel {
  const PharmacyModel({
    required this.id,
    required this.name,
    this.arName,
    this.address,
    this.city,
    this.district,
    this.phone,
    required this.isOpen24H,
    required this.acceptsDonations,
    this.latitude,
    this.longitude,
  });

  final int id;
  final String name;
  final String? arName;
  final String? address;
  final String? city;
  final String? district;
  final String? phone;
  final bool isOpen24H;
  final bool acceptsDonations;
  final double? latitude;
  final double? longitude;

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'Unknown Pharmacy',
      arName: json['arName'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      phone: json['phone'] as String?,
      isOpen24H: (json['isOpen24H'] as int? ?? 0) == 1,
      acceptsDonations: (json['acceptsDonations'] as int? ?? 1) == 1,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}
