/// MedBank — Request Model

class RequestModel {
  const RequestModel({
    required this.id,
    required this.medicineName,
    required this.quantity,
    required this.status,
    required this.requestDate,
    this.medicineArName,
  });

  final int id;
  final String medicineName;
  final String? medicineArName;
  final int quantity;
  final String status;
  final DateTime requestDate;

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as int,
      medicineName: json['medicineName'] as String? ?? 'Unknown',
      medicineArName: json['medicineArName'] as String?,
      quantity: json['quantity'] as int? ?? 1,
      status: json['status'] as String? ?? 'Pending',
      requestDate:
          DateTime.tryParse(json['requestDate'] as String? ?? '') ??
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

/// Offline mock data for requests
abstract final class RequestDummyData {
  static final List<RequestModel> requests = [
    RequestModel(
      id: 1,
      medicineName: 'Insulin Glargine',
      quantity: 3,
      status: 'Pending',
      requestDate: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RequestModel(
      id: 2,
      medicineName: 'Lisinopril',
      quantity: 1,
      status: 'Fulfilled',
      requestDate: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];
}
