import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_config.dart';
import '../../../core/network/services/donation_service.dart';
import '../models/donation_model.dart';
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

    if (!ApiConfig.useLiveBackend) {
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(donations: DonationDummyData.donations, isLoading: false);
      return;
    }

    try {
      final res = await DonationService.instance.getMyDonations();
      final data = res.map((json) => DonationModel.fromJson(json)).toList();
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
    if (!ApiConfig.useLiveBackend) {
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

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
    
    // Refresh list
    loadMyDonations();
  }
}

final donationProvider = NotifierProvider<DonationNotifier, DonationState>(
  DonationNotifier.new,
);
