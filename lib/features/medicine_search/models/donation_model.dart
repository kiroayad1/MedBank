/// MedBank — Donation Model

class DonationModel {
  const DonationModel({
    required this.id,
    required this.medicineId,
    required this.medicineName,
    required this.quantity,
    required this.status,
    required this.donationDate,
    this.medicineArName,
  });

  final int id;
  final int medicineId;
  final String medicineName;
  final String? medicineArName;
  final int quantity;
  final String status;
  final DateTime donationDate;

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json['id'] as int,
      medicineId: json['medicineId'] as int? ?? 0,
      medicineName: json['medicineName'] as String? ?? 'Unknown',
      medicineArName: json['medicineArName'] as String?,
      quantity: json['quantity'] as int? ?? 1,
      status: json['status'] as String? ?? 'Pending',
      donationDate:
          DateTime.tryParse(json['donationDate'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  /// Returns localized name based on locale code.
  String localizedName(String localeCode) {
    if (localeCode == 'ar' &&
        medicineArName != null &&
        medicineArName!.isNotEmpty) {
      return medicineArName!;
    }
    return medicineName;
  }
}
