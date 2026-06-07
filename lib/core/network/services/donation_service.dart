/// MedBank — Donation API Service

import '../../network/api_client.dart';

class DonationService {
  DonationService._();
  static final DonationService instance = DonationService._();

  final _client = ApiClient.instance;

  /// Create a donation record (requires auth).
  Future<Map<String, dynamic>> create({
    required String medicineName,
    required String expiryDate,
    int quantity = 1,
    String category = 'Other',
    String unit = 'Units',
    String condition = 'Sealed',
    String location = 'Cairo',
    String? manufacturer,
    String? imageUrl,
    String? deliveryMethod,
  }) async {
    final data = await _client.post('/Donation', auth: true, body: {
      'medicineName': medicineName,
      'expiryDate': expiryDate,
      'quantity': quantity,
      'category': category,
      'unit': unit,
      'condition': condition,
      'location': location,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (deliveryMethod != null) 'deliveryMethod': deliveryMethod,
    });
    return data as Map<String, dynamic>;
  }

  /// Get current user's donation history (requires auth).
  Future<List<Map<String, dynamic>>> getMyDonations() async {
    final data = await _client.get('/Donation/my-donations', auth: true);
    return (data as List).cast<Map<String, dynamic>>();
  }
}
