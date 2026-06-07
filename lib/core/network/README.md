# Network Layer

This directory contains the networking stack for the Medicine Bank Flutter app.

## Architecture

The network layer acts as the bridge between the Riverpod providers and the backend API.

- **`api_config.dart`**: Contains configuration constants, such as the `baseUrl` and whether to use the live backend (`useLiveBackend`).
- **`api_client.dart`**: A wrapper around the standard `http` package. It intercepts requests to inject the JWT Bearer token automatically from SharedPreferences and handles common error parsing.
- **`api_exception.dart`**: Custom exception class for standardizing error reporting to the UI.
- **`services/`**: Directory containing service classes mapped to specific backend features (e.g., `AuthService`, `MedicineService`).

## How `ApiClient` Works

`ApiClient` is a singleton-like helper. For protected routes, it reads `medbank_jwt_token` from SharedPreferences and adds it to the HTTP headers. It also standardizes the JSON parsing and error throwing.

## Toggling Live Backend vs Mock Data

The app is built to run entirely offline using dummy data for development and handoff.
To connect to a live backend, you do not need to modify the code. Run the app with the following dart-define flags:

```sh
flutter run \
  --dart-define=API_BASE_URL=https://your-server.com/api \
  --dart-define=USE_LIVE_BACKEND=true
```

Alternatively, you can manually flip `useLiveBackend = true` in `api_config.dart`.

## Adding a New Service

1. Create a new file in `services/` (e.g., `feature_service.dart`).
2. Inject `ApiClient` into your service.
3. Add your methods (e.g., `getFeature()`).
4. Handle the API response and throw `ApiException` if `isSuccess` is false.
5. Provide your service through a Riverpod provider in the feature module.
