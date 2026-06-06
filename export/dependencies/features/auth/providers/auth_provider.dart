import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Authentication state.
enum AuthStatus { unknown, unauthenticated, authenticated }

class AuthState {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.isLoading = false,
    this.errorMessage,
  });

  final AuthStatus status;
  final bool isLoading;
  final String? errorMessage;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get hasError => errorMessage != null;

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    String? Function()? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Clear any error messages.
  void clearError() {
    state = state.copyWith(errorMessage: () => null);
  }

  /// Simulate login with error handling.
  Future<void> login({
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);
    await Future.delayed(const Duration(seconds: 1));

    // Simulate wrong password
    if (password == 'wrong') {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Incorrect password. Please try again.',
      );
      return;
    }

    // Simulate account not found
    if (phone == '000') {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'No account found with this phone number.',
      );
      return;
    }

    // Simulate network error
    if (phone == '999') {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'Network error. Please check your connection.',
      );
      return;
    }

    state = const AuthState(status: AuthStatus.authenticated);
  }

  /// Simulate registration with error handling.
  Future<void> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);
    await Future.delayed(const Duration(seconds: 1));

    // Simulate phone already registered
    if (phone == '111') {
      state = state.copyWith(
        isLoading: false,
        errorMessage: () => 'This phone number is already registered.',
      );
      return;
    }

    state = const AuthState(status: AuthStatus.authenticated);
  }

  /// Logout.
  void logout() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  /// Skip auth for development.
  void skipAuth() {
    state = const AuthState(status: AuthStatus.authenticated);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
