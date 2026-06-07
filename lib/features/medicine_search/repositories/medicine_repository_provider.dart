import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_config.dart';
import 'medicine_api_repository.dart';
import 'medicine_mock_repository.dart';
import 'medicine_repository.dart';

/// Injects the correct [MedicineRepository] based on [ApiConfig.useLiveBackend].
final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  if (ApiConfig.useLiveBackend) {
    return MedicineApiRepository();
  }
  return MedicineMockRepository();
});
