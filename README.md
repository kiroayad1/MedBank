# Medicine Bank

A Flutter application designed to connect surplus medicine to those in need.

## Prerequisites

- Flutter SDK ^3.11
- `flutter pub get` to install dependencies

## Quick Start (Standalone / Offline Mode)

The application is configured to run fully offline using dummy data by default. This allows you to explore the UI, browse medicines, mock a login, and test the donation flow without needing a backend server.

Simply run:
```sh
flutter run
```

## Connecting to a Live Backend

When the backend API is ready, you can connect the app to it by passing the base URL and enabling the live backend flag via `dart-define`:

```sh
flutter run \
  --dart-define=API_BASE_URL=https://your-server.com/api \
  --dart-define=USE_LIVE_BACKEND=true
```

If you are testing locally on an Android Emulator, use `http://10.0.2.2:PORT/api` as the base URL. For iOS Simulators, use `http://localhost:PORT/api`.

*(Note: If using `http://` in development, ensure `android:usesCleartextTraffic="true"` is set in your `AndroidManifest.xml` if needed).*

## Documentation

Comprehensive documentation for backend integration is available in the `docs/` folder:

- [Integration Guide](docs/INTEGRATION.md) — The main handoff document explaining architecture and connections.
- [API Contract](docs/API_CONTRACT.md) — Endpoint notes and expectations.
- [OpenAPI Spec](docs/api/openapi.json) — The full OpenAPI 3.0 specification exported from the initial mockup backend.
- [Models Mapping](docs/MODELS.md) — How Dart models map to JSON.
- [Backend Checklist](docs/BACKEND_CHECKLIST.md) — Actionable items for the backend team.
- [Network Layer Overview](lib/core/network/README.md) — Developer-focused guide on how `ApiClient` and providers are wired.

## Folder Structure

```text
medicine_bank/
├── docs/                      # Backend handoff and integration documentation
├── lib/
│   ├── core/                  # Core features: networking, routing, theme, l10n
│   │   └── network/           # API config, client, and service classes
│   ├── features/              # Feature modules (auth, medicine_details, etc.)
│   │   └── [feature]/
│   │       ├── models/        # Data models and DummyData
│   │       ├── providers/     # Riverpod state management
│   │       └── screens/       # UI widgets
│   └── shared/                # Reusable UI components
```
