/// MedBank — HTTP Client Wrapper
///
/// Thin wrapper around `package:http` that:
/// - Sets JSON headers
/// - Auto-attaches JWT Bearer token from SharedPreferences
/// - Returns decoded JSON maps
/// - Throws typed [ApiException]s

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_config.dart';
import 'api_exception.dart';

/// Singleton HTTP client for the MedBank backend.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final http.Client _client = http.Client();

  // ── Token management ─────────────────────────────────────────
  static const _tokenKey = 'medbank_jwt_token';
  static const _nameKey = 'medbank_user_name';
  static const _phoneKey = 'medbank_user_phone';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> saveUserInfo({required String name, required String phone}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setString(_phoneKey, phone);
  }

  Future<Map<String, String>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_nameKey) ?? '',
      'phone': prefs.getString(_phoneKey) ?? '',
    };
  }

  Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_nameKey);
    await prefs.remove(_phoneKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ── Headers ──────────────────────────────────────────────────
  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  // ── HTTP methods ─────────────────────────────────────────────

  /// GET request.
  Future<dynamic> get(String path, {bool auth = false}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$path');
    _log('GET', url);
    try {
      final response = await _client
          .get(url, headers: await _headers(auth: auth))
          .timeout(ApiConfig.timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException('Request timed out');
    }
  }

  /// POST request.
  Future<dynamic> post(String path, {dynamic body, bool auth = false}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$path');
    _log('POST', url);
    try {
      final response = await _client
          .post(url, headers: await _headers(auth: auth), body: jsonEncode(body))
          .timeout(ApiConfig.timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException('Request timed out');
    }
  }

  /// PUT request.
  Future<dynamic> put(String path, {dynamic body, bool auth = true}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$path');
    _log('PUT', url);
    try {
      final response = await _client
          .put(url, headers: await _headers(auth: auth), body: jsonEncode(body))
          .timeout(ApiConfig.timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException('Request timed out');
    }
  }

  /// DELETE request.
  Future<dynamic> delete(String path, {bool auth = true}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}$path');
    _log('DELETE', url);
    try {
      final response = await _client
          .delete(url, headers: await _headers(auth: auth))
          .timeout(ApiConfig.timeout);
      return _handleResponse(response);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const NetworkException('Request timed out');
    }
  }

  // ── Response handling ────────────────────────────────────────
  dynamic _handleResponse(http.Response response) {
    _log('RESPONSE ${response.statusCode}', Uri.parse(''));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty || response.statusCode == 204) return null;
      return jsonDecode(response.body);
    }

    // Try to extract error message from response body
    String message = 'Request failed';
    try {
      final body = jsonDecode(response.body);
      message = body['message'] ?? body['error'] ?? message;
    } catch (_) {}

    switch (response.statusCode) {
      case 400:
        throw BadRequestException(message);
      case 401:
        throw UnauthorizedException(message);
      case 404:
        throw NotFoundException(message);
      case >= 500:
        throw ServerException(message);
      default:
        throw ApiException(message, statusCode: response.statusCode);
    }
  }

  void _log(String method, Uri url) {
    if (kDebugMode) {
      debugPrint('🌐 $method ${url.toString()}');
    }
  }
}
