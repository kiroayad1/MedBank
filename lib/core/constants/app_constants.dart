/// Medicine Bank — App-wide Constants
///
/// Static values that don't belong in the theme system.
abstract final class AppConstants {
  // ──────────────────────────────────────────────
  //  APP IDENTITY
  // ──────────────────────────────────────────────
  static const String appName = 'Medicine Bank';
  static const String appTagline = 'Connecting medicine to those in need';
  static const String appVersion = '1.0.0';

  // ──────────────────────────────────────────────
  //  API / NETWORK (placeholders for Step 2+)
  // ──────────────────────────────────────────────
  static const String baseUrl = 'https://api.medicinebank.app/v1';
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // ──────────────────────────────────────────────
  //  FORM VALIDATION
  // ──────────────────────────────────────────────
  static const int phoneNumberMinLength = 10;
  static const int phoneNumberMaxLength = 15;
  static const int passwordMinLength = 8;
  static const int nameMinLength = 2;
  static const int nameMaxLength = 50;

  // ──────────────────────────────────────────────
  //  MEDICINE-SPECIFIC
  // ──────────────────────────────────────────────
  static const int minExpiryMonths = 3;
  static const List<String> medicineCategories = [
    'Antibiotic',
    'Painkiller',
    'Diabetes',
    'Vitamins',
    'Heart',
    'Allergy',
    'Other',
  ];

  static const List<String> medicineUnits = [
    'Tablets',
    'Capsules',
    'Bottles',
    'Boxes',
    'Strips',
    'Vials',
    'Tubes',
  ];

  static const List<String> medicineConditions = [
    'Sealed',
    'Unopened',
    'Partially Used',
    'New',
  ];

  // ──────────────────────────────────────────────
  //  SEARCH
  // ──────────────────────────────────────────────
  static const Duration searchDebounce = Duration(milliseconds: 400);
  static const int searchMinChars = 2;
}
