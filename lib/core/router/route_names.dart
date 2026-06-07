/// Medicine Bank — Route Path & Name Constants
abstract final class RouteNames {
  // AUTH
  static const String login = 'login';
  static const String signUp = 'signUp';
  static const String forgotPassword = 'forgotPassword';
  static const String otpVerification = 'otpVerification';
  static const String createPassword = 'createPassword';

  // MAIN SHELL TABS
  static const String home = 'home';
  static const String browse = 'browse';
  static const String profile = 'profile';

  // DONATE FLOW
  static const String donateGuidelines = 'donateGuidelines';
  static const String donateForm = 'donateForm';

  // REQUEST FLOW
  static const String requestGuidelines = 'requestGuidelines';
  static const String requestForm = 'requestForm';

  // MEDICINE DETAILS
  static const String medicineDetails = 'medicineDetails';

  static const String categoryMedicines = 'categoryMedicines';

  // PROFILE SUB-ROUTES
  static const String editProfile = 'editProfile';
  static const String changePassword = 'changePassword';
  static const String settings = 'settings';
  static const String myDonations = 'myDonations';
  static const String myRequests = 'myRequests';

  // SUCCESS
  static const String success = 'success';

  // ORDER
  static const String orderConfirmation = 'orderConfirmation';
}

abstract final class RoutePaths {
  // Auth
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String createPassword = '/create-password';

  // Main tabs
  static const String home = '/';
  static const String browse = '/browse';
  static const String profile = '/profile';

  // Donate
  static const String donateGuidelines = '/donate';
  static const String donateForm = '/donate/form';

  // Request
  static const String requestGuidelines = '/request';
  static const String requestForm = '/request/form';

  // Medicine details
  static const String medicineDetails = '/medicine/:id';

  static const String categoryMedicines = '/request/category/:category';

  // Profile sub-routes
  static const String editProfile = '/profile/edit';
  static const String changePassword = '/profile/change-password';
  static const String settings = '/settings';
  static const String myDonations = '/profile/donations';
  static const String myRequests = '/profile/requests';

  // Success
  static const String success = '/success';

  // Order
  static const String orderConfirmation = '/order/:id';

  static String medicineDetailsFor(String id) => '/medicine/$id';
  static String orderConfirmationFor(String id) => '/order/$id';
}
