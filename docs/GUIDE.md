# Medicine Bank — Developer Guide

> **Start here.** This document is the master index for all Medicine Bank documentation.

## Quick Links

| Document | Who is it for? | What does it cover? |
|---|---|---|
| **[SETUP.md](SETUP.md)** | New developers | Install Flutter, IDE, emulator, backend server, and configure `.env`. |
| **[ARCHITECTURE.md](ARCHITECTURE.md)** | Frontend developers | Layered architecture, Repository Pattern, Riverpod, unidirectional data flow. |
| **[FRONTEND.md](FRONTEND.md)** | Frontend developers | Every feature module explained in depth. How to add a new feature. |
| **[BACKEND.md](BACKEND.md)** | **Backend team** | Complete stack-agnostic API specification with SQL schema. |
| **[INTEGRATION.md](INTEGRATION.md)** | Backend + Frontend teams | Connection matrix: Screen → Provider → Repository → Service → Endpoint. |
| **[API_CONTRACT.md](API_CONTRACT.md)** | Backend team | Endpoint notes, PascalCase routes, special cases, checkout payload. |
| **[MODELS.md](MODELS.md)** | Backend team | Dart model field mappings, nullability, dates, booleans. |
| **[DEPLOYMENT.md](DEPLOYMENT.md)** | DevOps / Release managers | Build commands, `dart-define` flags, release checklist. |
| **[TESTING.md](TESTING.md)** | Frontend developers | How to run tests, mock repositories, integration testing. |

---

## Project Overview

**Medicine Bank** is a Flutter application that connects surplus medicine to those in need.

- **Frontend:** Flutter 3.11+, Dart, Riverpod, GoRouter
- **Backend:** Any stack (Node.js, ASP.NET, Django, Laravel, etc.) — see [BACKEND.md](BACKEND.md) for the contract.
- **State Management:** Riverpod (AsyncNotifier, FutureProvider)
- **HTTP:** Custom `ApiClient` wrapper over `package:http`
- **Local Storage:** `SharedPreferences` (JWT token, user info)

---

## Typical Developer Workflows

### I want to set up my machine
→ Read [SETUP.md](SETUP.md)

### I want to understand the codebase structure
→ Read [ARCHITECTURE.md](ARCHITECTURE.md)

### I want to build a new feature
→ Read [FRONTEND.md](FRONTEND.md) → "Feature Implementation Workflow"

### I want to connect the frontend to a real backend
→ Read [INTEGRATION.md](INTEGRATION.md) and [BACKEND.md](BACKEND.md)

### I want to prepare a release build
→ Read [DEPLOYMENT.md](DEPLOYMENT.md)

### I want to remove all mock data and go fully live
→ See [FRONTEND.md](FRONTEND.md) → "Removing Mock Data"

---

## Repository Structure

```text
medicine_bank/
├── docs/                        # You are here
│   ├── api/
│   │   └── openapi.json         # Full OpenAPI 3.0 specification
│   └── *.md                     # Documentation files
├── lib/
│   ├── core/                    # Networking, routing, theme, l10n
│   ├── features/                # Feature modules
│   │   ├── auth/
│   │   ├── medicine_search/
│   │   ├── medicine_details/
│   │   └── saved_medicines/
│   └── shared/                  # Reusable widgets
├── tools/
│   └── remove_mocks.dart        # Script to strip mock data (see FRONTEND.md)
└── test/                        # Unit and widget tests
```

---

*Last updated: June 2026*
