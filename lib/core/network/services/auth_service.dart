/// MedBank — Auth API Service

import '../api_client.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _client = ApiClient.instance;

  /// Register a new user. Returns response map with token + user info.
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    final data = await _client.post('/Auth/register', body: {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'password': password,
    });

    final map = data as Map<String, dynamic>;

    // Store token + user info
    if (map['token'] != null) {
      await _client.saveToken(map['token'] as String);
      await _client.saveUserInfo(
        name: map['fullName'] as String? ?? fullName,
        phone: map['phoneNumber'] as String? ?? phoneNumber,
      );
    }

    return map;
  }

  /// Login. Returns response map with token + user info.
  Future<Map<String, dynamic>> login({
    required String phoneNumber,
    required String password,
  }) async {
    final data = await _client.post('/Auth/login', body: {
      'phoneNumber': phoneNumber,
      'password': password,
    });

    final map = data as Map<String, dynamic>;

    // Store token + user info
    if (map['token'] != null) {
      await _client.saveToken(map['token'] as String);
      await _client.saveUserInfo(
        name: map['fullName'] as String? ?? '',
        phone: map['phoneNumber'] as String? ?? phoneNumber,
      );
    }

    return map;
  }

  /// Update profile (requires auth).
  Future<Map<String, dynamic>> updateProfile({
    required String fullName,
    required String phoneNumber,
  }) async {
    final data = await _client.put('/Auth/update-profile', body: {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
    });
    final map = data as Map<String, dynamic>;

    // Update stored info
    await _client.saveUserInfo(name: fullName, phone: phoneNumber);

    return map;
  }

  /// Logout — clears stored token.
  Future<void> logout() async {
    await _client.clearAuth();
  }

  /// Check if there's a stored token.
  Future<bool> hasSession() async {
    return _client.hasToken();
  }

  /// Get stored user info.
  Future<Map<String, String>> getUserInfo() async {
    return _client.getUserInfo();
  }
}
