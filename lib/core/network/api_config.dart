/// MedBank — API Configuration
///
/// Toggle [useLiveBackend] to switch between real API and dummy data.
class ApiConfig {
  ApiConfig._();

  /// Master toggle: `true` = hit real backend, `false` = use dummy data.
  static const bool useLiveBackend = bool.fromEnvironment(
    'USE_LIVE_BACKEND',
    defaultValue: false,
  );

  /// Full base URL for API calls.
  /// Priority: --dart-define > default placeholder
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.medicinebank.app/api',
  );

  /// Request timeout.
  static const Duration timeout = Duration(seconds: 15);
}
