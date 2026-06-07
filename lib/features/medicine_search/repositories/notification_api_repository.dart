import '../../../../core/network/services/notification_service.dart';
import '../models/notification_model.dart';
import 'notification_repository.dart';

/// Real implementation that calls the backend API.
class NotificationApiRepository implements NotificationRepository {
  @override
  Future<List<NotificationModel>> getAll() async {
    final res = await NotificationService.instance.getAll();
    return res.map((json) => NotificationModel.fromJson(json)).toList();
  }

  @override
  Future<int> getUnreadCount() => NotificationService.instance.getUnreadCount();

  @override
  Future<void> markAllRead() => NotificationService.instance.markAllRead();
}
