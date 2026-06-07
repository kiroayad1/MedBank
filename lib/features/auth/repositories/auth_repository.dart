/// Abstract interface for authentication data access.
abstract class AuthRepository {
  /// Check if a valid session exists locally.
  Future<bool> hasSession();

  /// Get stored user info (name, phone).
  Future<Map<String, dynamic>> getUserInfo();

  /// Login with phone and password.
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  });

  /// Register a new user.
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
  });

  /// Update user profile.
  Future<void> updateProfile({
    required String fullName,
    required String phoneNumber,
  });

  /// Send OTP to a phone number for password reset.
  Future<void> sendOtp({required String phone});

  /// Verify the OTP code.
  Future<bool> verifyOtp({required String phone, required String code});

  /// Logout and clear local session.
  Future<void> logout();
}
