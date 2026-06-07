# Frontend Deep Dive

> Everything a frontend developer needs to know about the Medicine Bank codebase.

## Table of Contents

- [Project Structure](#project-structure)
- [Feature Modules](#feature-modules)
- [State Management (Riverpod)](#state-management-riverpod)
- [Adding a New Feature](#adding-a-new-feature)
- [Removing Mock Data](#removing-mock-data)
- [Common Patterns](#common-patterns)
- [Code Style](#code-style)

---

## Project Structure

```text
lib/
├── core/                          # Cross-cutting concerns
│   ├── network/                   # ApiClient, services, config
│   │   ├── api_client.dart        # HTTP wrapper with JWT injection
│   │   ├── api_config.dart        # Base URL, timeout, toggle flags
│   │   ├── api_exception.dart     # Custom exception types
│   │   └── services/              # One service per external API
│   │       ├── auth_service.dart
│   │       ├── medicine_service.dart
│   │       ├── donation_service.dart
│   │       ├── request_service.dart
│   │       ├── notification_service.dart
│   │       ├── pharmacy_service.dart
│   │       └── stats_service.dart
│   ├── router/                    # GoRouter configuration
│   ├── theme/                     # Colors, typography, spacing, shadows
│   └── l10n/                      # Localization (ARB files)
│
├── features/                      # Feature modules
│   ├── auth/                      # Login, register, profile, settings
│   │   ├── models/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── repositories/          # AuthRepository interface + impls
│   ├── medicine_search/           # Browse, search, category, donate, request
│   │   ├── models/                # Medicine, Donation, Request, Notification
│   │   ├── providers/             # Riverpod state management
│   │   ├── screens/               # Browse, category, donate form, request form
│   │   └── repositories/          # Medicine, Donation, Request, Notification repos
│   ├── medicine_details/          # Detail view, order confirmation
│   │   └── screens/
│   └── saved_medicines/           # My activity (donations + requests)
│       └── screens/
│
├── shared/                        # Globally reusable UI components
│   └── widgets/                   # AppButton, AppTextField, AppShellScaffold, etc.
│
└── main.dart                      # App entry point
```

---

## Feature Modules

Each feature follows the **Repository Pattern**:

```text
feature_name/
├── models/           # Immutable domain models
├── repositories/     # Abstract interface + API impl + Mock impl
│   ├── *_repository.dart
│   ├── *_api_repository.dart
│   ├── *_mock_repository.dart
│   └── *_repository_provider.dart
├── providers/        # Riverpod state management
└── screens/          # UI widgets
```

### Why Repository Pattern?

Providers **never** contain `if (useMock)` logic. They only talk to an abstract `Repository` interface. The concrete implementation (real API vs. mock) is injected via a single root provider.

**Benefits:**
- **Clean deletion:** Delete all `*_mock_repository.dart` files and the app still compiles.
- **Testable:** Inject a fake repository in widget tests.
- **Consistent:** Every feature follows the exact same structure.

---

## State Management (Riverpod)

### Provider Types Used

| Type | Use Case | Example |
|---|---|---|
| `Provider<T>` | Dependency injection | `authRepositoryProvider` |
| `FutureProvider<T>` | One-shot async data | `medicineDetailsProvider(id)` |
| `FutureProvider.family<T, Arg>` | Parametrized async data | `categoryMedicinesProvider(category)` |
| `AsyncNotifier<T>` | Complex state with commands | `AuthNotifier`, `MedicineSearchNotifier` |
| `Notifier<T>` | Synchronous state | `MedicineSearchNotifier` (for local filtering) |

### Anatomy of a Feature Provider

```dart
// 1. Repository provider (injection point)
final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  if (ApiConfig.useLiveBackend) {
    return MedicineApiRepository();
  }
  return MedicineMockRepository();
});

// 2. Business logic provider
class MedicineSearchNotifier extends Notifier<MedicineSearchState> {
  @override
  MedicineSearchState build() {
    Future.microtask(_loadMedicines);
    return const MedicineSearchState();
  }

  Future<void> _loadMedicines() async {
    state = state.copyWith(isLoading: true);
    try {
      final repo = ref.read(medicineRepositoryProvider);
      final data = await repo.getMedicines();
      state = state.copyWith(medicines: data, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: () => e.toString(), isLoading: false);
    }
  }
}

final medicineSearchProvider =
    NotifierProvider<MedicineSearchNotifier, MedicineSearchState>(
  MedicineSearchNotifier.new,
);
```

### Watching vs. Reading

- `ref.watch(provider)` — Subscribe to changes. Use in `build()` methods.
- `ref.read(provider)` — One-time access. Use inside event handlers (`onPressed`, `initState`).

---

## Adding a New Feature

Follow this exact workflow. Do not skip steps.

### Step 1: Define the Domain Model

```dart
// lib/features/my_feature/models/my_model.dart
class MyModel {
  const MyModel({required this.id, required this.name});
  final String id;
  final String name;

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(id: json['id'].toString(), name: json['name']);
  }
}
```

### Step 2: Create the Repository Interface

```dart
// lib/features/my_feature/repositories/my_repository.dart
abstract class MyRepository {
  Future<List<MyModel>> getItems();
}
```

### Step 3: Implement API Repository

```dart
// lib/features/my_feature/repositories/my_api_repository.dart
class MyApiRepository implements MyRepository {
  @override
  Future<List<MyModel>> getItems() async {
    final res = await MyService.instance.getItems();
    return res.map((json) => MyModel.fromJson(json)).toList();
  }
}
```

### Step 4: Implement Mock Repository (Optional, for offline dev)

```dart
// lib/features/my_feature/repositories/my_mock_repository.dart
class MyMockRepository implements MyRepository {
  @override
  Future<List<MyModel>> getItems() async {
    await Future.delayed(const Duration(seconds: 1));
    return [const MyModel(id: '1', name: 'Mock Item')];
  }
}
```

### Step 5: Create the Provider Injection Point

```dart
// lib/features/my_feature/repositories/my_repository_provider.dart
final myRepositoryProvider = Provider<MyRepository>((ref) {
  if (ApiConfig.useLiveBackend) {
    return MyApiRepository();
  }
  return MyMockRepository();
});
```

### Step 6: Create the Business Logic Provider

```dart
// lib/features/my_feature/providers/my_provider.dart
class MyNotifier extends Notifier<MyState> {
  @override
  MyState build() {
    Future.microtask(_load);
    return const MyState();
  }

  Future<void> _load() async {
    final repo = ref.read(myRepositoryProvider);
    final data = await repo.getItems();
    state = state.copyWith(items: data);
  }
}
```

### Step 7: Create the Screen

```dart
// lib/features/my_feature/screens/my_screen.dart
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    // Build UI...
  }
}
```

### Step 8: Register the Route

Add the route in `lib/core/router/app_router.dart`.

---

## Removing Mock Data

When the backend is fully ready, strip all mock implementations.

### Option A: Automated Script (Recommended)

```sh
dart tools/remove_mocks.dart
```

This script will:
1. Delete all `*_mock_repository.dart` files.
2. Rewrite all `*_repository_provider.dart` files to always use the real API.
3. Optionally remove `ApiConfig.useLiveBackend`.
4. Run `flutter analyze` and print a summary.

**Dry run** (preview without changes):
```sh
dart tools/remove_mocks.dart --dry-run
```

**Keep the toggle flag** (if you want staging environments):
```sh
dart tools/remove_mocks.dart --keep-toggle
```

### Option B: Manual Removal

1. Delete these files:
   ```text
   lib/features/*/repositories/*_mock_repository.dart
   ```
2. Edit each `*_repository_provider.dart`:
   ```dart
   // BEFORE
   final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
     if (ApiConfig.useLiveBackend) {
       return MedicineApiRepository();
     }
     return MedicineMockRepository();
   });

   // AFTER
   final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
     return MedicineApiRepository();
   });
   ```
3. Optionally delete `ApiConfig.useLiveBackend` from `lib/core/network/api_config.dart`.
4. Run `flutter analyze` to verify.

---

## Common Patterns

### Converting a StatefulWidget to ConsumerWidget

When a screen needs async data, use `FutureProvider` instead of local `initState` + `setState`:

```dart
// BEFORE (StatefulWidget with local loading state)
class DetailScreen extends StatefulWidget { ... }

// AFTER (ConsumerWidget watching a FutureProvider)
class DetailScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(detailProvider(id));
    return asyncData.when(
      data: (data) => _buildContent(data),
      loading: () => const CircularProgressIndicator(),
      error: (err, _) => Text('Error: $err'),
    );
  }
}
```

### Error Handling in Providers

Always catch `ApiException` separately from generic `Exception`:

```dart
try {
  final data = await repo.getItems();
} on ApiException catch (e) {
  // Known API error (4xx, 5xx with JSON message)
  state = state.copyWith(errorMessage: () => e.message);
} catch (e) {
  // Unknown error (network timeout, parse error, etc.)
  state = state.copyWith(errorMessage: () => 'Unexpected error: $e');
}
```

### Debounced Search

Use a `Timer` to avoid filtering on every keystroke:

```dart
Timer? _debounce;

void search(String query) {
  _debounce?.cancel();
  _debounce = Timer(const Duration(milliseconds: 300), () {
    _applyFilters();
  });
}
```

---

## Code Style

- **No comments** unless explaining *why*, not *what*.
- **Immutable models** — use `const` constructors and `copyWith`.
- **No business logic in widgets** — keep screens lean.
- **One service per external API** — services are stateless.
- **Repositories are the only place that caches domain data**.

---

*For the backend specification, see [BACKEND.md](BACKEND.md).*
