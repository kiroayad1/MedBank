# Backend Team Checklist

Please complete the following checklist to ensure the backend is fully compatible with the Flutter frontend:

- [ ] Implement all endpoints documented in `api/openapi.json`.
- [ ] Ensure route paths match the exact casing (e.g., `/api/Auth/login`).
- [ ] Return the JWT token on both **register** and **login** endpoints.
- [ ] Support `Authorization: Bearer <token>` on all protected routes.
- [ ] Enable CORS for local development (if the frontend is tested on the web).
- [ ] Ensure HTTPS is used in production.
- [ ] Provide the official `API_BASE_URL` to the frontend team once deployed.
- [ ] Verify that `POST /Request/checkout` accepts a raw JSON array.
- [ ] (Future) Implement forgot-password, change-password, and token refresh logic.
- [ ] (Future) Implement `GET /Auth/me` for proper session validation on startup.
