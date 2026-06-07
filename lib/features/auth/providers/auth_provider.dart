import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../repositories/auth_repository_provider.dart';

/// Authentication state.
enum AuthStatus { unknown, unauthenticated, authenticated }

class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.isLoading = false,
    this.errorMessage,
    this.fullName,
    this.phoneNumber,
  });

  final AuthStatus status;
  final bool isLoading;
  final String? errorMessage;
  final String? fullName;
  final String? phoneNumber;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get hasError => errorMessage != null;

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    String? Function()? errorMessage,
    String? fullName,
    String? phoneNumber,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _initFromStorage();
    return const AuthState(status: AuthStatus.unknown);
  }

  Future<void> _initFromStorage() async {
    final repo = ref.read(authRepositoryProvider);
    final hasSession = await repo.hasSession();
    if (hasSession) {
      final info = await repo.getUserInfo();
      state = AuthState(
        status: AuthStatus.authenticated,
        fullName: info['name'],
        phoneNumber: info['phone'],
      );
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Clear any error messages.
  void clearError() {
    state = state.copyWith(errorMessage: () => null);
  }

  /// Login with phone and password.
  Future<void> login({required String phone, required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    try {
      final repo = ref.read(authRepositoryProvider);
      final res = await repo.login(phone: phone, password: password);
      state = AuthState(
        status: AuthStatus.authenticated,
        fullName: res['fullName'],
        phoneNumber: res['phoneNumber'],
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: () => e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Login failed: $e',
      );
    }
  }

  /// Register a new user.
  Future<void> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);

    try {
      final repo = ref.read(authRepositoryProvider);
      final res = await repo.register(
        name: name,
        phone: phone,
        password: password,
      );
      state = AuthState(
        status: AuthStatus.authenticated,
        fullName: res['fullName'],
        phoneNumber: res['phoneNumber'],
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: () => e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Registration failed: $e',
      );
    }
  }

  /// Logout.
  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
