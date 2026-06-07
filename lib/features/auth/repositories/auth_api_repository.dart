import '../../../core/network/services/auth_service.dart';
import 'auth_repository.dart';

/// Real implementation that calls the backend API.
class AuthApiRepository implements AuthRepository {
  @override
  Future<bool> hasSession() => AuthService.instance.hasSession();

  @override
  Future<Map<String, dynamic>> getUserInfo() =>
      AuthService.instance.getUserInfo();

  @override
  Future<Map<String, dynamic>> login({
    required String phone,
    required String password,
  }) => AuthService.instance.login(phoneNumber: phone, password: password);

  @override
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String password,
  }) => AuthService.instance.register(
    fullName: name,
    phoneNumber: phone,
    password: password,
  );

  @override
  Future<void> updateProfile({
    required String fullName,
    required String phoneNumber,
  }) => AuthService.instance.updateProfile(
    fullName: fullName,
    phoneNumber: phoneNumber,
  );

  @override
  Future<void> logout() => AuthService.instance.logout();
}
