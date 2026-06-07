import '../models/notification_model.dart';

/// Abstract interface for notification data access.
abstract class NotificationRepository {
  /// Fetch all notifications.
  Future<List<NotificationModel>> getAll();

  /// Get unread notification count.
  Future<int> getUnreadCount();

  /// Mark all notifications as read.
  Future<void> markAllRead();
}
