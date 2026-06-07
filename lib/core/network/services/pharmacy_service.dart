/// MedBank — Pharmacy API Service

import '../../network/api_client.dart';

class PharmacyService {
  PharmacyService._();
  static final PharmacyService instance = PharmacyService._();

  final _client = ApiClient.instance;

  /// Get all pharmacies (public, no auth).
  Future<List<Map<String, dynamic>>> getAll() async {
    final data = await _client.get('/Pharmacy');
    return (data as List).cast<Map<String, dynamic>>();
  }

  /// Search pharmacies by name/district (public).
  Future<List<Map<String, dynamic>>> search(String query) async {
    final encoded = Uri.encodeQueryComponent(query);
    final data = await _client.get('/Pharmacy/search?q=$encoded');
    return (data as List).cast<Map<String, dynamic>>();
  }

  /// Get pharmacy by ID (public).
  Future<Map<String, dynamic>> getById(int id) async {
    final data = await _client.get('/Pharmacy/$id');
    return data as Map<String, dynamic>;
  }
}
