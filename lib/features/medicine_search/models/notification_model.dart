/// MedBank — Notification Model

class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.category,
    this.medicineId,
    this.medicineName,
  });

  final int id;
  final String userId;
  final String title;
  final String message;
  final String type; // 'donation' or 'request'
  final bool isRead;
  final DateTime createdAt;
  final String? category;
  final int? medicineId;
  final String? medicineName;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? 'Notification',
      message: json['message'] as String? ?? '',
      type: json['type'] as String? ?? 'donation',
      isRead: (json['isRead'] as int? ?? 0) == 1,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      category: json['category'] as String?,
      medicineId: json['medicineId'] as int?,
      medicineName: json['medicineName'] as String?,
    );
  }
}

/// Offline mock data for notifications
abstract final class NotificationDummyData {
  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 1,
      userId: 'mock_user_1',
      title: 'Donation Approved',
      message: 'Your donation of Panadol Extra has been approved.',
      type: 'donation',
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      medicineName: 'Panadol Extra',
    ),
    NotificationModel(
      id: 2,
      userId: 'mock_user_1',
      title: 'Request Fulfilled',
      message: 'Your request for Lisinopril is ready for pickup.',
      type: 'request',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      medicineName: 'Lisinopril',
    ),
  ];
}
