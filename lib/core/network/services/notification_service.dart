/// MedBank — Notification API Service

import '../../network/api_client.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _client = ApiClient.instance;

  /// Get all notifications for current user (requires auth).
  Future<List<Map<String, dynamic>>> getAll() async {
    final data = await _client.get('/Notification', auth: true);
    return (data as List).cast<Map<String, dynamic>>();
  }

  /// Get unread notification count (requires auth).
  Future<int> getUnreadCount() async {
    final data = await _client.get('/Notification/unread-count', auth: true);
    return (data as Map<String, dynamic>)['count'] as int? ?? 0;
  }

  /// Mark all notifications as read (requires auth).
  Future<void> markAllRead() async {
    await _client.post('/Notification/mark-read', auth: true);
  }
}
