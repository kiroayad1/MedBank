/// MedBank — API Exception Types
///
/// Typed exceptions for cleaner error handling in providers/UI.

/// Base API exception.
class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}

/// 401 — token expired or invalid.
class UnauthorizedException extends ApiException {
  const UnauthorizedException([String message = 'Unauthorized'])
      : super(message, statusCode: 401);
}

/// 400 — bad request / validation errors.
class BadRequestException extends ApiException {
  const BadRequestException(super.message) : super(statusCode: 400);
}

/// 404 — resource not found.
class NotFoundException extends ApiException {
  const NotFoundException([String message = 'Not found'])
      : super(message, statusCode: 404);
}

/// 500 — server-side error.
class ServerException extends ApiException {
  const ServerException([String message = 'Internal server error'])
      : super(message, statusCode: 500);
}

/// Network unreachable / timeout.
class NetworkException extends ApiException {
  const NetworkException([String message = 'Network error — is the backend running?'])
      : super(message);
}
