import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_config.dart';
import '../../../core/network/services/request_service.dart';
import '../models/request_model.dart';
import '../../auth/providers/auth_provider.dart';

class RequestState {
  const RequestState({
    this.requests = const [],
    this.isLoading = true,
    this.errorMessage,
  });

  final List<RequestModel> requests;
  final bool isLoading;
  final String? errorMessage;

  RequestState copyWith({
    List<RequestModel>? requests,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return RequestState(
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

class RequestNotifier extends Notifier<RequestState> {
  @override
  RequestState build() {
    final auth = ref.watch(authProvider);
    if (auth.isAuthenticated) {
      Future.microtask(loadHistory);
    }
    return const RequestState();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    if (!ApiConfig.useLiveBackend) {
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(requests: RequestDummyData.requests, isLoading: false);
      return;
    }

    try {
      final res = await RequestService.instance.getHistory();
      final data = res.map((json) => RequestModel.fromJson(json)).toList();
      state = state.copyWith(requests: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Failed to load requests',
      );
    }
  }

  Future<void> checkout(List<Map<String, int>> items) async {
    if (!ApiConfig.useLiveBackend) {
      await Future.delayed(const Duration(seconds: 1));
      return;
    }

    await RequestService.instance.checkout(items);
    
    // Refresh list
    loadHistory();
  }
}

final requestProvider = NotifierProvider<RequestNotifier, RequestState>(
  RequestNotifier.new,
);
