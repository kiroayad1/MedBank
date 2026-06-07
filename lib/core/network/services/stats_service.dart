/// MedBank — Stats API Service

import '../../network/api_client.dart';

class StatsService {
  StatsService._();
  static final StatsService instance = StatsService._();

  final _client = ApiClient.instance;

  /// Get platform statistics (public, no auth).
  Future<Map<String, dynamic>> getStats() async {
    final data = await _client.get('/stats');
    return data as Map<String, dynamic>;
  }
}
