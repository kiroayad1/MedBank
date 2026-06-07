import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_config.dart';
import 'donation_api_repository.dart';
import 'donation_mock_repository.dart';
import 'donation_repository.dart';

/// Injects the correct [DonationRepository] based on [ApiConfig.useLiveBackend].
final donationRepositoryProvider = Provider<DonationRepository>((ref) {
  if (ApiConfig.useLiveBackend) {
    return DonationApiRepository();
  }
  return DonationMockRepository();
});
