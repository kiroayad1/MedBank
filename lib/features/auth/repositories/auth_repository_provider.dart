import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_config.dart';
import 'auth_api_repository.dart';
import 'auth_mock_repository.dart';
import 'auth_repository.dart';

/// Injects the correct [AuthRepository] based on [ApiConfig.useLiveBackend].
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  if (ApiConfig.useLiveBackend) {
    return AuthApiRepository();
  }
  return AuthMockRepository();
});
