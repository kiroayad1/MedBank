/// MedBank — Medicine API Service

import '../../network/api_client.dart';

class MedicineService {
  MedicineService._();
  static final MedicineService instance = MedicineService._();

  final _client = ApiClient.instance;

  /// Get all medicines (public, no auth needed).
  Future<List<Map<String, dynamic>>> getAll() async {
    final data = await _client.get('/Medicine');
    return (data as List).cast<Map<String, dynamic>>();
  }

  /// Get medicine by ID (public).
  Future<Map<String, dynamic>> getById(int id) async {
    final data = await _client.get('/Medicine/$id');
    return data as Map<String, dynamic>;
  }

  /// Get medicines by category (public).
  Future<List<Map<String, dynamic>>> getByCategory(String category) async {
    final encoded = Uri.encodeComponent(category);
    final data = await _client.get('/Medicine/by-category/$encoded');
    return (data as List).cast<Map<String, dynamic>>();
  }

  /// Create a new medicine donation (requires auth).
  Future<Map<String, dynamic>> create({
    required String name,
    required String expiryDate,
    String? arName,
    String? description,
    int quantity = 1,
    double price = 0,
    String? imageUrl,
    String category = 'Other',
    String? manufacturer,
    String? condition,
    String? dosageForm,
    String? strength,
    String location = 'Cairo',
    String? deliveryMethod,
    String? deliveryAddress,
    String? pharmacyName,
    String? alternativePhone,
  }) async {
    final data = await _client.post('/Medicine', auth: true, body: {
      'name': name,
      'expiryDate': expiryDate,
      if (arName != null) 'arName': arName,
      if (description != null) 'description': description,
      'quantity': quantity,
      'price': price,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'category': category,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (condition != null) 'condition': condition,
      if (dosageForm != null) 'dosageForm': dosageForm,
      if (strength != null) 'strength': strength,
      'location': location,
      if (deliveryMethod != null) 'deliveryMethod': deliveryMethod,
      if (deliveryAddress != null) 'deliveryAddress': deliveryAddress,
      if (pharmacyName != null) 'pharmacyName': pharmacyName,
      if (alternativePhone != null) 'alternativePhone': alternativePhone,
    });
    return data as Map<String, dynamic>;
  }
}
