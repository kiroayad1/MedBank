import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/request_model.dart';
import '../repositories/request_repository_provider.dart';
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

    try {
      final repo = ref.read(requestRepositoryProvider);
      final data = await repo.getHistory();
      state = state.copyWith(requests: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Failed to load requests',
      );
    }
  }

  Future<void> checkout(List<Map<String, int>> items) async {
    final repo = ref.read(requestRepositoryProvider);
    await repo.checkout(items);

    // Refresh list
    loadHistory();
  }
}

final requestProvider = NotifierProvider<RequestNotifier, RequestState>(
  RequestNotifier.new,
);
