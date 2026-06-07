# Environment Setup Guide

> Step-by-step instructions for setting up the Medicine Bank development environment.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Flutter SDK Installation](#flutter-sdk-installation)
- [IDE Configuration](#ide-configuration)
- [Project Setup](#project-setup)
- [Backend Server Setup](#backend-server-setup)
- [Running the App](#running-the-app)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites

| Tool | Minimum Version | Purpose |
|---|---|---|
| Flutter SDK | 3.11 | Cross-platform UI framework |
| Dart | Bundled with Flutter | Programming language |
| Git | 2.30+ | Version control |
| Android Studio / Xcode | Latest | Android / iOS emulators |

---

## Flutter SDK Installation

### Windows

1. Download the Flutter SDK from [flutter.dev](https://docs.flutter.dev/get-started/install).
2. Extract to `C:\dev\flutter`.
3. Add to PATH:
   ```powershell
   [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\dev\flutter\bin", "User")
   ```
4. Restart terminal and verify:
   ```sh
   flutter doctor
   ```

### macOS

```sh
brew install flutter
flutter doctor
```

### Linux

```sh
sudo snap install flutter --classic
flutter doctor
```

**Expected output:** `flutter doctor` should show green checkmarks for Flutter, Dart, and at least one device (Android emulator or Chrome).

---

## IDE Configuration

### VS Code (Recommended)

1. Install extensions:
   - **Flutter** (Dart Code)
   - **Dart**
   - **Flutter Riverpod Snippets** (optional)
   - **Markdown All in One** (for docs)
2. Open the project folder.
3. Press `Ctrl+Shift+P` → `Flutter: Select Device` → choose your emulator.

### Android Studio

1. Install the **Flutter** plugin.
2. Open the project.
3. Configure an Android Virtual Device (AVD) with API 33+.

---

## Project Setup

```sh
# 1. Clone the repository
git clone <repo-url>
cd medicine_bank

# 2. Install dependencies
flutter pub get

# 3. Verify no errors
flutter analyze
```

---

## Backend Server Setup

The frontend is designed to work with **any backend stack**. The contract is defined in:

- [BACKEND.md](BACKEND.md) — SQL schema + endpoint specification
- [API_CONTRACT.md](API_CONTRACT.md) — Special cases and expectations
- [docs/api/openapi.json](api/openapi.json) — Full OpenAPI 3.0 spec

### Quick Start Options

| Option | Best For | Instructions |
|---|---|---|
| **Mock Mode** | Frontend-only development | Run `flutter run` with no backend. App uses local dummy data. |
| **Local Backend** | Full-stack integration testing | Run your backend on `localhost:3000`, then use `10.0.2.2:3000` (Android) or `localhost:3000` (iOS). |
| **Staging Backend** | QA / Pre-release testing | Deploy to a cloud server and pass the URL via `--dart-define`. |

### Connecting to a Local Backend

**Android Emulator:**
```sh
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api --dart-define=USE_LIVE_BACKEND=true
```

**iOS Simulator:**
```sh
flutter run --dart-define=API_BASE_URL=http://localhost:3000/api --dart-define=USE_LIVE_BACKEND=true
```

**Note for Android:** If using `http://`, ensure `android:usesCleartextTraffic="true"` is set in `AndroidManifest.xml`.

---

## Running the App

### Default Mode (Mock Data)
```sh
flutter run
```
The app runs with dummy data. No backend required. Useful for UI exploration.

### Live Backend Mode
```sh
flutter run \
  --dart-define=API_BASE_URL=https://your-server.com/api \
  --dart-define=USE_LIVE_BACKEND=true
```

### Release Build (Android)
```sh
flutter build apk --release \
  --dart-define=API_BASE_URL=https://your-server.com/api \
  --dart-define=USE_LIVE_BACKEND=true
```

### Release Build (iOS)
```sh
flutter build ios --release \
  --dart-define=API_BASE_URL=https://your-server.com/api \
  --dart-define=USE_LIVE_BACKEND=true
```

---

## Troubleshooting

| Problem | Solution |
|---|---|
| `flutter doctor` shows Android toolchain issues | Open Android Studio → SDK Manager → install latest SDK and command-line tools. |
| Emulator not detected | Start emulator manually from Android Studio before running `flutter run`. |
| `HttpException: Connection refused` | Verify backend is running and `API_BASE_URL` uses correct IP (10.0.2.2 for Android emulator). |
| `ApiException: 401 Unauthorized` | JWT token expired. Log out and log in again. |
| Build fails with missing dependencies | Run `flutter clean && flutter pub get`. |

---

*For architecture details, see [ARCHITECTURE.md](ARCHITECTURE.md).*
