import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_config.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/network/services/auth_service.dart';

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
    if (!ApiConfig.useLiveBackend) {
      state = const AuthState(status: AuthStatus.unauthenticated);
      return;
    }
    
    final hasSession = await AuthService.instance.hasSession();
    if (hasSession) {
      final info = await AuthService.instance.getUserInfo();
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

  /// Login with real backend or dummy.
  Future<void> login({
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);
    
    if (!ApiConfig.useLiveBackend) {
      await Future.delayed(const Duration(seconds: 1));
      if (password == 'wrong') {
        state = state.copyWith(isLoading: false, errorMessage: () => 'Incorrect password.');
        return;
      }
      state = const AuthState(status: AuthStatus.authenticated);
      return;
    }

    try {
      final res = await AuthService.instance.login(phoneNumber: phone, password: password);
      state = AuthState(
        status: AuthStatus.authenticated,
        fullName: res['fullName'],
        phoneNumber: res['phoneNumber'],
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: () => e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: () => 'Login failed: $e');
    }
  }

  /// Register with real backend or dummy.
  Future<void> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: () => null);
    
    if (!ApiConfig.useLiveBackend) {
      await Future.delayed(const Duration(seconds: 1));
      if (phone == '111') {
        state = state.copyWith(isLoading: false, errorMessage: () => 'Phone already registered.');
        return;
      }
      state = const AuthState(status: AuthStatus.authenticated);
      return;
    }

    try {
      final res = await AuthService.instance.register(fullName: name, phoneNumber: phone, password: password);
      state = AuthState(
        status: AuthStatus.authenticated,
        fullName: res['fullName'],
        phoneNumber: res['phoneNumber'],
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: () => e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: () => 'Registration failed: $e');
    }
  }

  /// Logout.
  Future<void> logout() async {
    if (ApiConfig.useLiveBackend) {
      await AuthService.instance.logout();
    }
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
