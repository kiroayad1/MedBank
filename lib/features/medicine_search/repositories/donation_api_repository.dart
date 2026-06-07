import '../../../../core/network/services/donation_service.dart';
import '../models/donation_model.dart';
import 'donation_repository.dart';

/// Real implementation that calls the backend API.
class DonationApiRepository implements DonationRepository {
  @override
  Future<List<DonationModel>> getMyDonations() async {
    final res = await DonationService.instance.getMyDonations();
    return res.map((json) => DonationModel.fromJson(json)).toList();
  }

  @override
  Future<void> createDonation({
    required String medicineName,
    required String expiryDate,
    int quantity = 1,
    String category = 'Other',
    String unit = 'Units',
    String condition = 'Sealed',
    String location = 'Cairo',
    String? manufacturer,
    String? deliveryMethod,
  }) async {
    await DonationService.instance.create(
      medicineName: medicineName,
      expiryDate: expiryDate,
      quantity: quantity,
      category: category,
      unit: unit,
      condition: condition,
      location: location,
      manufacturer: manufacturer,
      deliveryMethod: deliveryMethod,
    );
  }
}
