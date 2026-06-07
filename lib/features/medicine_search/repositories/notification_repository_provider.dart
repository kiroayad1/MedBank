import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_config.dart';
import 'notification_api_repository.dart';
import 'notification_mock_repository.dart';
import 'notification_repository.dart';

/// Injects the correct [NotificationRepository] based on [ApiConfig.useLiveBackend].
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  if (ApiConfig.useLiveBackend) {
    return NotificationApiRepository();
  }
  return NotificationMockRepository();
});
