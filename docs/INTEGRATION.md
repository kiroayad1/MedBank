# Frontend/Backend Integration Guide

This document is the "what connects to what" bible for the Medicine Bank Flutter app, detailing how the frontend UI communicates with the backend API.

## Architecture

The frontend follows a clean separation of concerns using Riverpod for state management:

```mermaid
flowchart LR
  Screens[UI Screens] --> Providers[Riverpod Providers]
  Providers --> Services["lib/core/network/services/*"]
  Services --> ApiClient[ApiClient]
  ApiClient --> API[Backend API]
```

- **UI Screens**: Know nothing about HTTP requests. They just watch providers.
- **Providers**: Manage loading states, error handling, and whether to use the live API or mock data based on `useLiveBackend` configuration.
- **Services**: The bridge between providers and HTTP. They contain the endpoint logic (e.g. `AuthService.login()`).
- **ApiClient**: A wrapper over `package:http` that automatically injects the JWT token as a Bearer header.

## Authentication Flow

```mermaid
sequenceDiagram
  participant UI as LoginScreen
  participant AuthP as authProvider
  participant AuthS as AuthService
  participant Client as ApiClient
  participant Prefs as SharedPreferences
  participant API as Backend
  UI->>AuthP: login(phone, password)
  AuthP->>AuthS: login()
  AuthS->>Client: POST /Auth/login
  Client->>API: JSON body
  API-->>Client: token + user info
  Client->>Prefs: save medbank_jwt_token, name, phone
  AuthP-->>UI: authenticated
  Note over Client,API: Protected calls
  Client->>Prefs: read token
  Client->>API: Authorization Bearer token
```

### SharedPreferences Keys

| Key | Content |
|---|---|
| `medbank_jwt_token` | JWT string |
| `medbank_user_name` | Full name |
| `medbank_user_phone` | Phone number |

## Connection Matrix

**Provider → Service → Endpoint → Screen**

| Screen / Feature | Provider or direct call | Service method | HTTP | Endpoint | Auth |
|---|---|---|---|---|---|
| Login | `authProvider.login()` | `AuthService.login()` | POST | `/Auth/login` | No |
| Sign up | `authProvider.register()` | `AuthService.register()` | POST | `/Auth/register` | No |
| Session restore | `authProvider._initFromStorage()` | `AuthService.hasSession()` | — | local only | — |
| Logout | `authProvider.logout()` | `AuthService.logout()` | — | clears prefs | — |
| Browse / search | `medicineSearchProvider` | `MedicineService.getAll()` | GET | `/Medicine` | No |
| Category list | direct in screen | `MedicineService.getByCategory()` | GET | `/Medicine/by-category/:category` | No |
| Medicine details | direct in screen | `MedicineService.getById()` | GET | `/Medicine/:id` | No |
| Donate form | `donationProvider.createDonation()` | `DonationService.create()` | POST | `/Donation` | Bearer |
| My donations | `donationProvider.loadMyDonations()` | `DonationService.getMyDonations()` | GET | `/Donation/my-donation` | Bearer |
| Request form | `requestProvider.checkout()` | `RequestService.checkout()` | POST | `/Request/checkout` | Bearer |
| My requests | `requestProvider.loadHistory()` | `RequestService.getHistory()` | GET | `/Request/history` | Bearer |
| Notifications (no UI) | `notificationProvider` | `NotificationService.*` | GET/POST | `/Notification/*` | Bearer |
| Edit profile | — | `AuthService.updateProfile()` | PUT | `/Auth/update-profile` | Bearer |
| Pharmacy (no UI) | — | `PharmacyService.*` | GET | `/Pharmacy/*` | No |
| Stats (no UI) | — | `StatsService.getStats()` | GET | `/stats` | No |

## Error Handling Contract

- **Status Codes**: 
  - `2xx`: Success
  - `401`: Unauthorized (App will handle by requiring login, though token refresh is not fully implemented yet)
  - `4xx`: Client Error (App displays the message returned by the API)
  - `5xx`: Server Error
- **`ApiException` Types**: The frontend `ApiClient` throws `ApiException` which is caught by providers and surfaced as UI snackbars.
- **Expected JSON Error Shape**: The frontend expects errors to be returned as JSON, typically reading the `message` field to display to the user.

## Known Gaps

- **Notifications & Pharmacy**: The services exist and are documented, but the UI is pending.
- **Token Expiry**: No `GET /Auth/me` on startup. The app trusts the local token. The backend should handle token validation, but the frontend currently lacks a global 401 interceptor for automatic logout.
- **Forgot/Change Password**: No endpoints exist yet.

## Testing Integration

To test the app connected to a real backend, run the app using the `dart-define` flags:

```sh
flutter run \
  --dart-define=API_BASE_URL=https://your-server.com/api \
  --dart-define=USE_LIVE_BACKEND=true
```
