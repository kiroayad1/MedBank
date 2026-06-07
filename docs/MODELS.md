# Models and JSON Mapping

This document outlines the Dart model to JSON field mapping for the primary entities in the app, located in `lib/features/*/models/`.

## Key Models

### `Medicine`
- **`id`**: Parsed as a `String` in the frontend, although the backend might send it as an `int`. The `fromJson` factory handles this conversion.
- Maps to the `Medicine` table.

### `DonationModel`
- Contains fields representing a donation.
- *Fields the UI expects but backend may not send*: The app might anticipate fields like `distance`, `donorPhone`, or `userId` depending on the view. Ensure these are provided if they are relevant to the UI state.

### `RequestModel`
- Maps checkout requests. Contains references to the medicines requested and their quantities.

### `NotificationModel`
- Represents a notification sent to the user.

### `PharmacyModel`
- Represents a pharmacy entity in the search system.

## General Parsing Rules

- The Dart models are built with `freezed` and `json_serializable`.
- Null safety is strictly enforced in Dart; ensure that non-nullable fields in the backend always return a valid value, or make the corresponding Dart fields nullable if the data is optional.
- Dates are generally expected as ISO 8601 strings.
