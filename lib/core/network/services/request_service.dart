/// MedBank — Request API Service

import '../../network/api_client.dart';

class RequestService {
  RequestService._();
  static final RequestService instance = RequestService._();

  final _client = ApiClient.instance;

  /// Checkout cart items. Each item: {medicineId: int, quantity: int}.
  Future<Map<String, dynamic>> checkout(List<Map<String, int>> items) async {
    final data = await _client.post('/Request/checkout', auth: true, body: items);
    return data as Map<String, dynamic>;
  }

  /// Get request history for current user (requires auth).
  Future<List<Map<String, dynamic>>> getHistory() async {
    final data = await _client.get('/Request/history', auth: true);
    return (data as List).cast<Map<String, dynamic>>();
  }
}
