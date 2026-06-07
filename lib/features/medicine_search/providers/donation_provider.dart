import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/donation_model.dart';
import '../repositories/donation_repository_provider.dart';
import '../../auth/providers/auth_provider.dart';

class DonationState {
  const DonationState({
    this.donations = const [],
    this.isLoading = true,
    this.errorMessage,
  });

  final List<DonationModel> donations;
  final bool isLoading;
  final String? errorMessage;

  DonationState copyWith({
    List<DonationModel>? donations,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return DonationState(
      donations: donations ?? this.donations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

class DonationNotifier extends Notifier<DonationState> {
  @override
  DonationState build() {
    final auth = ref.watch(authProvider);
    if (auth.isAuthenticated) {
      Future.microtask(loadMyDonations);
    }
    return const DonationState();
  }

  Future<void> loadMyDonations() async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    try {
      final repo = ref.read(donationRepositoryProvider);
      final data = await repo.getMyDonations();
      state = state.copyWith(donations: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Failed to load donations',
      );
    }
  }

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
    final repo = ref.read(donationRepositoryProvider);
    await repo.createDonation(
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

    // Refresh list
    loadMyDonations();
  }
}

final donationProvider = NotifierProvider<DonationNotifier, DonationState>(
  DonationNotifier.new,
);
