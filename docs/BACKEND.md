# Backend Implementation Guide

> **Stack-agnostic specification.** This document tells any backend team exactly what the Flutter frontend expects, regardless of whether you use Node.js, ASP.NET, Django, Laravel, or any other framework.

## Table of Contents

- [Overview](#overview)
- [Technology Recommendations](#technology-recommendations)
- [Database Schema](#database-schema)
- [Authentication](#authentication)
- [Endpoints Reference](#endpoints-reference)
- [Request / Response Examples](#request--response-examples)
- [Error Handling](#error-handling)
- [Data Seeding](#data-seeding)
- [Frontend Integration Checklist](#frontend-integration-checklist)

---

## Overview

The Medicine Bank backend is a REST API that powers a Flutter mobile application. It manages:

- **Users** — authentication via phone + password
- **Medicines** — catalog of donated medicines
- **Donations** — records of users donating medicines
- **Requests** — users requesting medicines from the catalog
- **Notifications** — system messages to users
- **Pharmacies** — directory of partner pharmacies

**Base URL format:** `https://your-domain.com/api`

**Important:** All route paths use **PascalCase**. Example: `/api/Auth/login`, NOT `/api/auth/login`.

---

## Technology Recommendations

While this spec is stack-agnostic, the following are proven combinations:

| Layer | Suggested Tech |
|---|---|
| Runtime | Node.js (Express/NestJS), Python (Django/DRF, FastAPI), .NET (ASP.NET Core), PHP (Laravel) |
| Database | PostgreSQL (recommended), MySQL, SQLite (for prototyping only) |
| Auth | JWT (HS256 or RS256), stored in `SharedPreferences` on the frontend |
| File Storage | Cloudinary, AWS S3, or Supabase Storage for `imageUrl` |

---

## Database Schema

### Users

```sql
CREATE TABLE users (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name     VARCHAR(255) NOT NULL,
  phone_number  VARCHAR(20)  NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,  -- bcrypt/argon2 hash
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Notes:**
- Phone number is the login identifier (not email).
- Password must be hashed. Never store plain text.
- The frontend reads `fullName` and `phoneNumber` from login/register responses.

---

### Medicines

```sql
CREATE TABLE medicines (
  id             SERIAL PRIMARY KEY,
  name           VARCHAR(255) NOT NULL,
  ar_name        VARCHAR(255),           -- Arabic name
  description    TEXT,
  expiry_date    VARCHAR(10)  NOT NULL,   -- Format: "MM/YYYY" (frontend expectation)
  quantity       INTEGER DEFAULT 0,
  price          DECIMAL(10,2) DEFAULT 0, -- Original price (for display only; app is donation-based)
  image_url      TEXT,
  category       VARCHAR(100) DEFAULT 'Other',
  manufacturer   VARCHAR(255),
  condition      VARCHAR(50) DEFAULT 'Sealed',
  dosage_form    VARCHAR(50),             -- e.g., "Tablet", "Syrup", "Injection"
  strength       VARCHAR(50),             -- e.g., "500mg", "250mg/5ml"
  popularity     INTEGER DEFAULT 0,
  location       VARCHAR(255) DEFAULT 'Cairo',
  donor_id       UUID REFERENCES users(id),
  is_available   BOOLEAN DEFAULT TRUE,     -- Computed: quantity > 0
  created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Notes:**
- `id` is sent as `integer` in JSON, but the frontend parses it as `String` (handles both).
- `expiry_date` is stored as `VARCHAR` in `"MM/YYYY"` format. Do not use `DATE` type unless you also format it correctly in the JSON response.
- `is_available` should be derived from `quantity > 0`.
- When a request is approved, decrement `quantity`.

---

### Donations

```sql
CREATE TABLE donations (
  id              SERIAL PRIMARY KEY,
  medicine_id     INTEGER REFERENCES medicines(id),
  donor_id        UUID REFERENCES users(id),
  quantity        INTEGER DEFAULT 1,
  status          VARCHAR(50) DEFAULT 'Pending',  -- "Pending", "Approved", "Rejected"
  donation_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  delivery_method VARCHAR(50)  -- e.g., "pickup", "pharmacy"
);
```

**Notes:**
- The frontend shows `medicineName` and `status` in the "My Donations" list.
- When creating a donation, you may also need to create a `medicines` record if it doesn't exist.
- `donation_date` is sent as ISO 8601 string in JSON.

---

### Requests

```sql
CREATE TABLE requests (
  id            SERIAL PRIMARY KEY,
  medicine_id   INTEGER REFERENCES medicines(id),
  requester_id  UUID REFERENCES users(id),
  quantity      INTEGER DEFAULT 1,
  status        VARCHAR(50) DEFAULT 'Pending',  -- "Pending", "Approved", "Delivered"
  request_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Notes:**
- The `/Request/checkout` endpoint receives a **raw JSON array** of objects:
  ```json
  [
    { "medicineId": 1, "quantity": 2 },
    { "medicineId": 3, "quantity": 1 }
  ]
  ```
- For each item in the array, create one row in `requests`.
- Deduct stock from `medicines.quantity` upon approval.
- The frontend `RequestModel` expects `medicineName` in the response (join with `medicines`).

---

### Notifications

```sql
CREATE TABLE notifications (
  id            SERIAL PRIMARY KEY,
  user_id       UUID REFERENCES users(id),
  title         VARCHAR(255) NOT NULL,
  message       TEXT NOT NULL,
  type          VARCHAR(50) DEFAULT 'donation',  -- "donation" or "request"
  category      VARCHAR(50),
  medicine_id   INTEGER REFERENCES medicines(id),
  medicine_name VARCHAR(255),  -- Denormalized for quick display
  is_read       INTEGER DEFAULT 0,  -- 0 = false, 1 = true (SQLite compat)
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**Notes:**
- `is_read` should be returned as `0` or `1` integer in JSON. The frontend handles both `int` and `bool` gracefully.
- Include `medicineName` in the response so the frontend doesn't need a second lookup.

---

### Pharmacies

```sql
CREATE TABLE pharmacies (
  id                SERIAL PRIMARY KEY,
  name              VARCHAR(255) NOT NULL,
  ar_name           VARCHAR(255),
  address           TEXT,
  city              VARCHAR(100),
  district          VARCHAR(100),
  phone             VARCHAR(20),
  is_open_24h       INTEGER DEFAULT 0,  -- 0 = false, 1 = true
  accepts_donations INTEGER DEFAULT 0,  -- 0 = false, 1 = true
  latitude          DECIMAL(10, 8),
  longitude         DECIMAL(11, 8)
);
```

**Notes:**
- Currently the frontend UI for pharmacies is pending, but the API must exist.
- Boolean fields (`is_open_24h`, `accepts_donations`) should be sent as `0` or `1`.

---

## Authentication

### JWT Flow

1. **Login:** `POST /Auth/login` → Backend validates credentials → Returns JWT token.
2. **Storage:** Frontend stores token in `SharedPreferences` under key `medbank_jwt_token`.
3. **Protected Calls:** Frontend sends `Authorization: Bearer <token>` header on every protected request.
4. **Validation:** Backend validates the token on every protected endpoint.

### Token Claims

At minimum, include:

```json
{
  "sub": "user-uuid",
  "phone": "01012345678",
  "iat": 1717776000,
  "exp": 1717862400
}
```

### Local Storage Keys (Frontend)

| Key | Content |
|---|---|
| `medbank_jwt_token` | JWT string |
| `medbank_user_name` | Full name |
| `medbank_user_phone` | Phone number |

---

## Endpoints Reference

### Legend

| Icon | Meaning |
|---|---|
| 🔓 | Public (no auth) |
| 🔒 | Requires Bearer token |

---

### Health

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/health` | 🔓 | Server status check |

**Response:**
```json
{
  "status": "OK",
  "message": "MedBank API is running"
}
```

---

### Stats

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/stats` | 🔓 | Platform statistics |

**Response:**
```json
{
  "medicines": 174,
  "requests": 12,
  "users": 45,
  "donations": 8
}
```

---

### Auth

| Method | Path | Auth | Description |
|---|---|---|---|
| POST | `/Auth/register` | 🔓 | Register new user |
| POST | `/Auth/login` | 🔓 | Login with phone + password |
| PUT | `/Auth/update-profile` | 🔒 | Update fullName + phoneNumber |

---

### Medicines

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/Medicine` | 🔓 | List all medicines |
| POST | `/Medicine` | 🔒 | Create new medicine (donation) |
| GET | `/Medicine/by-category/{category}` | 🔓 | Filter by category |
| GET | `/Medicine/{id}` | 🔓 | Get single medicine |
| PUT | `/Medicine/{id}` | 🔒 | Update medicine |
| DELETE | `/Medicine/{id}` | 🔒 | Delete medicine |

---

### Donations

| Method | Path | Auth | Description |
|---|---|---|---|
| POST | `/Donation` | 🔒 | Create donation record |
| GET | `/Donation/my-donations` | 🔒 | Current user's donations |

---

### Requests

| Method | Path | Auth | Description |
|---|---|---|---|
| POST | `/Request/checkout` | 🔒 | Checkout cart items |
| GET | `/Request/history` | 🔒 | Current user's request history |

---

### Notifications

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/Notification` | 🔒 | Get all notifications |
| GET | `/Notification/unread-count` | 🔒 | Unread count |
| POST | `/Notification/mark-read` | 🔒 | Mark all as read |

---

### Pharmacies

| Method | Path | Auth | Description |
|---|---|---|---|
| GET | `/Pharmacy` | 🔓 | List all pharmacies |
| GET | `/Pharmacy/search?q={query}` | 🔓 | Search pharmacies |
| GET | `/Pharmacy/{id}` | 🔓 | Get pharmacy by ID |

---

## Request / Response Examples

### Register

**Request:**
```http
POST /api/Auth/register
Content-Type: application/json

{
  "fullName": "Ahmed Mohamed",
  "phoneNumber": "01012345678",
  "password": "123456"
}
```

**Response (201):**
```json
{
  "isSuccess": true,
  "message": "User created successfully"
}
```

---

### Login

**Request:**
```http
POST /api/Auth/login
Content-Type: application/json

{
  "phoneNumber": "01012345678",
  "password": "123456"
}
```

**Response (200):**
```json
{
  "isSuccess": true,
  "message": "Login successful",
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "fullName": "Ahmed Mohamed",
  "phoneNumber": "01012345678"
}
```

---

### Get All Medicines

**Request:**
```http
GET /api/Medicine
```

**Response (200):**
```json
[
  {
    "id": 1,
    "name": "Panadol Extra",
    "arName": "بانادول إكسترا",
    "description": "Pain reliever",
    "expiryDate": "12/2026",
    "quantity": 50,
    "price": 45.00,
    "imageUrl": "https://...",
    "category": "Painkiller",
    "manufacturer": "GSK",
    "condition": "Sealed",
    "dosageForm": "Tablet",
    "strength": "500mg/65mg",
    "popularity": 98,
    "location": "Cairo"
  }
]
```

---

### Create Donation

**Request:**
```http
POST /api/Donation
Authorization: Bearer <token>
Content-Type: application/json

{
  "medicineName": "Amoxicillin",
  "expiryDate": "06/2027",
  "quantity": 2,
  "deliveryMethod": "pickup"
}
```

**Response (200):**
```json
{
  "isSuccess": true,
  "message": "Donation created"
}
```

---

### Checkout

**Request:**
```http
POST /api/Request/checkout
Authorization: Bearer <token>
Content-Type: application/json

[
  { "medicineId": 1, "quantity": 2 },
  { "medicineId": 3, "quantity": 1 }
]
```

**Response (200):**
```json
{
  "isSuccess": true,
  "message": "Order placed successfully"
}
```

**Important:** The body is a raw array, NOT wrapped in an object.

---

### Get Notifications

**Request:**
```http
GET /api/Notification
Authorization: Bearer <token>
```

**Response (200):**
```json
[
  {
    "id": 1,
    "userId": "550e8400-e29b-41d4-a716-446655440000",
    "title": "Donation Approved",
    "message": "Your donation has been approved.",
    "type": "donation",
    "category": "Approval",
    "medicineId": 101,
    "medicineName": "Panadol Extra",
    "isRead": 0,
    "createdAt": "2024-06-07T10:00:00Z"
  }
]
```

---

## Error Handling

### Status Codes

| Code | Meaning | Frontend Behavior |
|---|---|---|
| 200 | Success | Render data |
| 201 | Created | Show success message |
| 204 | No Content | Silent success |
| 400 | Bad Request | Show `message` from response body |
| 401 | Unauthorized | Redirect to login screen |
| 404 | Not Found | Show "Not found" error |
| 500 | Server Error | Show generic error message |

### Error Response Shape

```json
{
  "message": "Invalid phone number or password"
}
```

The frontend reads the `message` field and displays it in a Snackbar.

---

## Data Seeding

For initial development, seed the database with:

```sql
-- Categories
INSERT INTO medicines (name, category, expiry_date, quantity, location) VALUES
('Amoxicillin 250mg', 'Antibiotic', '12/2026', 25, 'Downtown Clinic Area'),
('Ibuprofen 400mg', 'Painkiller', '05/2027', 45, 'Westside Pharmacy Hub'),
('Metformin 500mg', 'Diabetes', '12/2026', 60, 'North Community Center'),
('Vitamin D3 1000 IU', 'Vitamins', '08/2028', 80, 'Eastside Suburbs'),
('Lisinopril 10mg', 'Heart', '03/2027', 30, 'Central Medical District'),
('Cetirizine 10mg', 'Allergy', '07/2027', 20, 'Riverside Pharmacy');
```

---

## Frontend Integration Checklist

Before declaring the backend "ready," verify:

- [ ] `POST /Auth/login` returns `token`, `fullName`, `phoneNumber`.
- [ ] `POST /Auth/register` returns `isSuccess` and `message`.
- [ ] All protected endpoints reject requests without `Authorization: Bearer <token>`.
- [ ] `GET /Medicine` returns an array of medicine objects.
- [ ] `GET /Medicine/{id}` returns a single medicine object.
- [ ] `GET /Medicine/by-category/{category}` filters correctly (case-sensitive match).
- [ ] `POST /Request/checkout` accepts a raw JSON array.
- [ ] `GET /Donation/my-donations` returns donations for the authenticated user only.
- [ ] `GET /Request/history` returns requests for the authenticated user only.
- [ ] `GET /Notification` returns `isRead` as `0` or `1`.
- [ ] All date fields are ISO 8601 strings (`2024-06-07T10:00:00Z`).
- [ ] `expiryDate` is in `"MM/YYYY"` format.
- [ ] Route paths use PascalCase (`/Auth/login`, not `/auth/login`).

---

*For the frontend architecture, see [ARCHITECTURE.md](ARCHITECTURE.md). For integration details, see [INTEGRATION.md](INTEGRATION.md).*
