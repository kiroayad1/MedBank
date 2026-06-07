import '../models/donation_model.dart';
import 'donation_repository.dart';

/// Mock implementation for offline development.
class DonationMockRepository implements DonationRepository {
  @override
  Future<List<DonationModel>> getMyDonations() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DonationDummyData.donations;
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
    await Future.delayed(const Duration(seconds: 1));
  }
}

/// Offline mock data for donations
abstract final class DonationDummyData {
  static final List<DonationModel> donations = [
    DonationModel(
      id: 1,
      medicineId: 101,
      medicineName: 'Panadol Extra',
      quantity: 2,
      status: 'Pending',
      donationDate: DateTime.now().subtract(const Duration(days: 1)),
    ),
    DonationModel(
      id: 2,
      medicineId: 102,
      medicineName: 'Amoxicillin',
      quantity: 1,
      status: 'Approved',
      donationDate: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
}
