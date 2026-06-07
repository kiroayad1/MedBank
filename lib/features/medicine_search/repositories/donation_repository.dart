import '../models/donation_model.dart';

/// Abstract interface for donation data access.
abstract class DonationRepository {
  /// Fetch the current user's donations.
  Future<List<DonationModel>> getMyDonations();

  /// Create a new donation.
  Future<void> createDonation({
    required String medicineName,
    required String expiryDate,
    int quantity,
    String category,
    String unit,
    String condition,
    String location,
    String? manufacturer,
    String? deliveryMethod,
  });
}
