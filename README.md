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

Comprehensive documentation is available in the `docs/` folder. **Start at [docs/GUIDE.md](docs/GUIDE.md).**

Key documents:

- [Architecture Guide](docs/ARCHITECTURE.md) — Layered architecture, Repository Pattern, Riverpod, data flow.
- [Frontend Deep Dive](docs/FRONTEND.md) — Every feature module explained. How to add new features. How to remove mocks.
- [Backend Specification](docs/BACKEND.md) — **Stack-agnostic API spec** with full SQL schema, endpoints, and integration checklist.
- [Integration Guide](docs/INTEGRATION.md) — Connection matrix (Screen → Provider → Repository → Service → Endpoint).
- [API Contract](docs/API_CONTRACT.md) — Endpoint notes, PascalCase routes, special cases.
- [Models Mapping](docs/MODELS.md) — How Dart models map to JSON.
- [Setup Guide](docs/SETUP.md) — Install Flutter, IDE, emulator, and backend server.
- [Deployment Guide](docs/DEPLOYMENT.md) — Build commands, `dart-define` flags, release checklist.
- [Testing Guide](docs/TESTING.md) — Unit, widget, and integration testing.
- [OpenAPI Spec](docs/api/openapi.json) — Full OpenAPI 3.0 specification.

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
