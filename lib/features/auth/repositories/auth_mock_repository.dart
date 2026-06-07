import 'auth_repository.dart';

/// Mock implementation for offline development.
class AuthMockRepository implements AuthRepository {
  @override
  Future<bool> hasSession() async => false;

  @override
  Future<Map<String, dynamic>> getUserInfo() async => {
    'name': 'Mock User',
    'phone': '01000000000',
  };

  @override
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (password == 'wrong') {
      throw Exception('Incorrect password.');
    }
    return {'fullName': 'Mock User', 'phoneNumber': phone};
  }

  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    if (phone == '111') {
      throw Exception('Phone already registered.');
    }
    return {'fullName': name, 'phoneNumber': phone};
  }

  @override
  Future<void> updateProfile({
    required String fullName,
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> logout() async {}
}
