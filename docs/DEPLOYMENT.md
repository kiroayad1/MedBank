# Deployment Guide

> How to build, configure, and release the Medicine Bank Flutter application.

## Table of Contents

- [Build Configuration](#build-configuration)
- [Environment Variables](#environment-variables)
- [Android Release](#android-release)
- [iOS Release](#ios-release)
- [Release Checklist](#release-checklist)
- [CI/CD Suggestions](#cicd-suggestions)

---

## Build Configuration

The app uses `--dart-define` to inject configuration at compile time. No `.env` files are bundled.

| Variable | Required | Default | Purpose |
|---|---|---|---|
| `API_BASE_URL` | Yes | `https://api.medicinebank.app/api` | Backend API base URL |
| `USE_LIVE_BACKEND` | No | `false` | `true` = real API, `false` = mock data |

---

## Environment Variables

### Development

```sh
flutter run \
  --dart-define=API_BASE_URL=http://10.0.2.2:3000/api \
  --dart-define=USE_LIVE_BACKEND=true
```

### Staging

```sh
flutter run \
  --dart-define=API_BASE_URL=https://staging.medicinebank.app/api \
  --dart-define=USE_LIVE_BACKEND=true
```

### Production

```sh
flutter build apk --release \
  --dart-define=API_BASE_URL=https://api.medicinebank.app/api \
  --dart-define=USE_LIVE_BACKEND=true
```

---

## Android Release

### Build APK

```sh
flutter build apk --release \
  --dart-define=API_BASE_URL=https://api.medicinebank.app/api \
  --dart-define=USE_LIVE_BACKEND=true
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Build App Bundle (AAB) — Recommended for Play Store

```sh
flutter build appbundle --release \
  --dart-define=API_BASE_URL=https://api.medicinebank.app/api \
  --dart-define=USE_LIVE_BACKEND=true
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Signing

Ensure `android/key.properties` is configured:

```properties
storePassword=<password>
keyPassword=<password>
keyAlias=<alias>
storeFile=<path-to-keystore>
```

---

## iOS Release

### Build

```sh
flutter build ios --release \
  --dart-define=API_BASE_URL=https://api.medicinebank.app/api \
  --dart-define=USE_LIVE_BACKEND=true
```

### Archive in Xcode

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select `Runner` → Signing & Capabilities → configure Team.
3. Product → Archive.
4. Distribute via App Store Connect.

---

## Release Checklist

Before every release:

- [ ] `flutter analyze` passes with 0 errors.
- [ ] `flutter test` passes.
- [ ] Backend API is live and health check returns `200`.
- [ ] `API_BASE_URL` points to production.
- [ ] `USE_LIVE_BACKEND=true` is set.
- [ ] Mock data has been removed (run `dart tools/remove_mocks.dart` if needed).
- [ ] App version bumped in `pubspec.yaml`.
- [ ] Release notes drafted.
- [ ] Screenshots updated (if UI changed).

---

## CI/CD Suggestions

### GitHub Actions Example

```yaml
# .github/workflows/build.yml
name: Build & Test

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
```

### Fastlane (Optional)

For automated Play Store / App Store uploads, consider [Fastlane](https://fastlane.tools/):

```sh
fastlane init
fastlane android deploy
fastlane ios deploy
```

---

*For environment setup, see [SETUP.md](SETUP.md).*
