# API Contract Notes

The full API contract is available as an OpenAPI 3.0 specification in `openapi.json`. You can import this file into Postman, Swagger UI, or any other OpenAPI-compatible tool.

## Important Notes & Special Cases

When implementing the endpoints described in the OpenAPI specification, please pay attention to the following frontend expectations:

- **PascalCase Routes**: Ensure that route paths match exactly. For example, `/api/Auth/login` is expected, **not** `/api/auth/login`.
- **Checkout Payload**: The `POST /Request/checkout` endpoint expects a raw JSON array of objects, not a wrapped object.
  ```json
  [
    { "medicineId": 1, "quantity": 2 },
    { "medicineId": 3, "quantity": 1 }
  ]
  ```
- **Boolean Fields**: Some database drivers (like SQLite used in the temp backend) return booleans as `0` or `1` integers. The frontend Dart models have been built to handle both actual booleans and `0`/`1` integer values gracefully.
- **Donation Endpoints**: There are two donation paths documented in the OpenAPI spec:
  - `POST /Donation` — **Used by the app.** This is the primary endpoint for creating a donation.
  - `POST /Medicine` — An alternative endpoint, but currently unused by the frontend flow. Focus on `/Donation`.
- **Login Response Structure**: The app reads `token`, `fullName`, and `phoneNumber` directly from the login response.
  ```json
  {
    "isSuccess": true,
    "message": "Login successful",
    "token": "ey...",
    "fullName": "John Doe",
    "phoneNumber": "01012345678"
  }
  ```
