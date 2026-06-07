import '../models/notification_model.dart';
import 'notification_repository.dart';

/// Mock implementation for offline development.
class NotificationMockRepository implements NotificationRepository {
  @override
  Future<List<NotificationModel>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return NotificationDummyData.notifications;
  }

  @override
  Future<int> getUnreadCount() async {
    final notifications = await getAll();
    return notifications.where((n) => !n.isRead).length;
  }

  @override
  Future<void> markAllRead() async {}
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
      category: 'Approval',
      medicineId: 101,
      medicineName: 'Panadol Extra',
    ),
    NotificationModel(
      id: 2,
      userId: 'mock_user_1',
      title: 'Request Fulfilled',
      message: 'Your request for Insulin Glargine is ready for pickup.',
      type: 'request',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Fulfilled',
      medicineId: 201,
      medicineName: 'Insulin Glargine',
    ),
  ];
}
