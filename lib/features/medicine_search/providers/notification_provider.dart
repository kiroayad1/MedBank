import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_config.dart';
import '../../../core/network/services/notification_service.dart';
import '../models/notification_model.dart';
import '../../auth/providers/auth_provider.dart';

class NotificationState {
  const NotificationState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = true,
    this.errorMessage,
  });

  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? errorMessage;

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

class NotificationNotifier extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    final auth = ref.watch(authProvider);
    if (auth.isAuthenticated) {
      Future.microtask(loadData);
    }
    return const NotificationState();
  }

  Future<void> loadData() async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    if (!ApiConfig.useLiveBackend) {
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(
        notifications: NotificationDummyData.notifications,
        unreadCount: NotificationDummyData.notifications.where((n) => !n.isRead).length,
        isLoading: false,
      );
      return;
    }

    try {
      final res = await NotificationService.instance.getAll();
      final count = await NotificationService.instance.getUnreadCount();
      
      final data = res.map((json) => NotificationModel.fromJson(json)).toList();
      
      state = state.copyWith(
        notifications: data,
        unreadCount: count,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Failed to load notifications',
      );
    }
  }

  Future<void> markAllRead() async {
    if (!ApiConfig.useLiveBackend) return;
    
    try {
      await NotificationService.instance.markAllRead();
      final current = state.notifications.map((n) {
        return NotificationModel(
          id: n.id,
          userId: n.userId,
          title: n.title,
          message: n.message,
          type: n.type,
          isRead: true,
          createdAt: n.createdAt,
          category: n.category,
          medicineId: n.medicineId,
          medicineName: n.medicineName,
        );
      }).toList();
      
      state = state.copyWith(notifications: current, unreadCount: 0);
    } catch (_) {}
  }
}

final notificationProvider = NotifierProvider<NotificationNotifier, NotificationState>(
  NotificationNotifier.new,
);
