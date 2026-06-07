import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_config.dart';
import 'request_api_repository.dart';
import 'request_mock_repository.dart';
import 'request_repository.dart';

/// Injects the correct [RequestRepository] based on [ApiConfig.useLiveBackend].
final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  if (ApiConfig.useLiveBackend) {
    return RequestApiRepository();
  }
  return RequestMockRepository();
});
