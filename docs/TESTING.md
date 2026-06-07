# Testing Guide

> How to write and run tests for the Medicine Bank Flutter application.

## Table of Contents

- [Test Types](#test-types)
- [Unit Testing](#unit-testing)
- [Widget Testing](#widget-testing)
- [Integration Testing](#integration-testing)
- [Mocking with Riverpod](#mocking-with-riverpod)
- [Running Tests](#running-tests)

---

## Test Types

| Type | Scope | File Location |
|---|---|---|
| **Unit Test** | Single function/class | `test/unit/*_test.dart` |
| **Widget Test** | Single widget tree | `test/widget/*_test.dart` |
| **Integration Test** | Full app flow | `integration_test/*_test.dart` |

---

## Unit Testing

### Testing a Repository

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../lib/core/network/services/medicine_service.dart';
import '../../lib/features/medicine_search/repositories/medicine_api_repository.dart';

class MockMedicineService extends Mock implements MedicineService {}

void main() {
  late MockMedicineService mockService;
  late MedicineApiRepository repository;

  setUp(() {
    mockService = MockMedicineService();
    repository = MedicineApiRepository();
  });

  test('getMedicines returns list of Medicine', () async {
    when(() => mockService.getAll()).thenAnswer(
      (_) async => [
        {'id': 1, 'name': 'Panadol', 'category': 'Painkiller', 'expiryDate': '12/2026', 'quantity': 10},
      ],
    );

    final result = await repository.getMedicines();

    expect(result.length, 1);
    expect(result.first.name, 'Panadol');
  });
}
```

### Testing a Provider

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../lib/features/auth/providers/auth_provider.dart';
import '../../lib/features/auth/repositories/auth_repository_provider.dart';
import '../../lib/features/auth/repositories/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  test('authProvider logs in successfully', () async {
    final mockRepo = MockAuthRepository();
    when(() => mockRepo.login(phone: any(named: 'phone'), password: any(named: 'password')))
        .thenAnswer((_) async => {'fullName': 'Test User', 'phoneNumber': '01012345678'});

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );

    final notifier = container.read(authProvider.notifier);
    await notifier.login(phone: '01012345678', password: 'password');

    final state = container.read(authProvider);
    expect(state.isAuthenticated, true);
    expect(state.fullName, 'Test User');
  });
}
```

---

## Widget Testing

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/features/medicine_search/screens/browse_screen.dart';

void main() {
  testWidgets('BrowseScreen shows loading then data', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: BrowseScreen()),
      ),
    );

    // Initially loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for async data
    await tester.pumpAndSettle();

    // Check that medicine list is rendered
    expect(find.text('Panadol Extra'), findsOneWidget);
  });
}
```

---

## Integration Testing

Integration tests run on a real device or emulator and test the full app flow.

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:medicine_bank/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full login flow', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Enter phone
    await tester.enterText(find.byType(TextField).at(0), '01012345678');
    // Enter password
    await tester.enterText(find.byType(TextField).at(1), 'password');
    // Tap login
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify home screen
    expect(find.text('Browse Medicines'), findsOneWidget);
  });
}
```

**Run integration tests:**
```sh
flutter test integration_test/app_test.dart
```

---

## Mocking with Riverpod

The key to testing with Riverpod is **overriding providers** in `ProviderContainer`:

```dart
final container = ProviderContainer(
  overrides: [
    // Replace real repository with fake
    medicineRepositoryProvider.overrideWithValue(FakeMedicineRepository()),
    // Replace real provider with a pre-computed state
    medicineSearchProvider.overrideWith((ref) => const MedicineSearchState(medicines: [])),
  ],
);
```

---

## Running Tests

### All Tests
```sh
flutter test
```

### Specific File
```sh
flutter test test/unit/auth_test.dart
```

### With Coverage
```sh
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Watch Mode (during development)
```sh
flutter test --watch
```

---

*For architecture details, see [ARCHITECTURE.md](ARCHITECTURE.md).*
