import 'package:flutter/material.dart';

/// Simple map-based localization for Arabic/English.
///
/// Usage: `S.of(context).appName` or `context.l10n.appName`
class S {
  S(this.locale);
  final Locale locale;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const _localizedValues = <String, Map<String, String>>{
    // ── App Identity ──
    'appName': {'en': 'Medicine Bank', 'ar': 'بنك الدواء'},
    'appTagline': {'en': 'Connecting medicine to those in need', 'ar': 'نوصل الدواء لمن يحتاج'},

    // ── Bottom Navigation ──
    'home': {'en': 'Home', 'ar': 'الرئيسية'},
    'browse': {'en': 'Browse', 'ar': 'تصفح'},
    'profile': {'en': 'Profile', 'ar': 'الملف الشخصي'},

    // ── Home Screen ──
    'welcomeBack': {'en': 'Welcome Back 👋', 'ar': '👋 مرحباً بعودتك'},
    'whatToDo': {'en': 'What would you like to do today?', 'ar': 'ماذا تريد أن تفعل اليوم؟'},
    'donateMedicine': {'en': 'Donate Medicine', 'ar': 'تبرع بدواء'},
    'donateSubtitle': {'en': 'Share your unused medicines with those in need', 'ar': 'شارك أدويتك غير المستخدمة مع المحتاجين'},
    'requestMedicine': {'en': 'Request Medicine', 'ar': 'اطلب دواء'},
    'requestSubtitle': {'en': 'Find and request the medicines you need', 'ar': 'ابحث واطلب الأدوية التي تحتاجها'},
    'browseAvailable': {'en': 'Browse Available', 'ar': 'تصفح المتاح'},
    'browseSubtitle': {'en': 'See all medicines donated by the community', 'ar': 'شاهد جميع الأدوية المتبرع بها'},

    // ── Auth ──
    'profileLogin': {'en': 'Profile Login', 'ar': 'تسجيل الدخول'},
    'loginSubtitle': {'en': 'Enter your phone number and password to log in', 'ar': 'أدخل رقم هاتفك وكلمة المرور لتسجيل الدخول'},
    'phoneNumber': {'en': 'Phone Number', 'ar': 'رقم الهاتف'},
    'password': {'en': 'Password', 'ar': 'كلمة المرور'},
    'forgotPassword': {'en': 'Forgot Password?', 'ar': 'نسيت كلمة المرور؟'},
    'logIn': {'en': 'Log In', 'ar': 'تسجيل الدخول'},
    'noAccount': {'en': "Don't have an account? ", 'ar': 'ليس لديك حساب؟ '},
    'signUp': {'en': 'Sign Up', 'ar': 'إنشاء حساب'},
    'signUpTitle': {'en': 'Sign up', 'ar': 'إنشاء حساب'},
    'signUpSubtitle': {'en': 'Create an account to continue!', 'ar': 'أنشئ حساباً للمتابعة!'},
    'fullName': {'en': 'Full Name', 'ar': 'الاسم الكامل'},
    'setPassword': {'en': 'Set Password', 'ar': 'تعيين كلمة المرور'},
    'confirmPassword': {'en': 'Confirm Password', 'ar': 'تأكيد كلمة المرور'},
    'register': {'en': 'Register', 'ar': 'تسجيل'},
    'alreadyAccount': {'en': 'Already have an account? ', 'ar': 'لديك حساب بالفعل؟ '},
    'login': {'en': 'Login', 'ar': 'دخول'},
    'forgotPasswordTitle': {'en': 'Forget Password', 'ar': 'نسيت كلمة المرور'},
    'forgotPasswordSubtitle': {'en': 'Please enter Your Phone number To Receive a Verification Code', 'ar': 'أدخل رقم هاتفك لتلقي رمز التحقق'},
    'resetPassword': {'en': 'Reset Password', 'ar': 'إعادة تعيين كلمة المرور'},
    'tryAnotherWay': {'en': 'Try Another Way?', 'ar': 'جرب طريقة أخرى؟'},
    'createNewPassword': {'en': 'Create a New Password', 'ar': 'إنشاء كلمة مرور جديدة'},
    'createPasswordSubtitle': {'en': 'Your New Password Must be Different From Previously Used Password', 'ar': 'يجب أن تكون كلمة المرور الجديدة مختلفة عن كلمة المرور المستخدمة سابقاً'},
    'newPassword': {'en': 'New Password', 'ar': 'كلمة المرور الجديدة'},

    // ── Browse ──
    'availableMedicines': {'en': 'Available Medicines', 'ar': 'الأدوية المتاحة'},
    'browseDescription': {'en': 'Browse and request Medicines donated by our community members', 'ar': 'تصفح واطلب الأدوية المتبرع بها من أعضاء مجتمعنا'},
    'searchMedicines': {'en': 'Search medicines...', 'ar': 'ابحث عن أدوية...'},
    'category': {'en': 'Category', 'ar': 'الفئة'},
    'allCategories': {'en': 'All Categories', 'ar': 'جميع الفئات'},
    'noMedicinesFound': {'en': 'No medicines found', 'ar': 'لم يتم العثور على أدوية'},
    'noMedicinesAvailable': {'en': 'No medicines available', 'ar': 'لا توجد أدوية متاحة'},
    'clearFilters': {'en': 'Clear Filters', 'ar': 'مسح الفلاتر'},

    // ── Donate ──
    'donateMedicineTitle': {'en': 'Donate Medicine', 'ar': 'تبرع بدواء'},
    'importantGuidelines': {'en': 'Important Guidelines', 'ar': 'إرشادات مهمة'},
    'continueToDonate': {'en': 'Continue to Donate', 'ar': 'المتابعة للتبرع'},
    'medicineDetails': {'en': 'Medicine Details', 'ar': 'تفاصيل الدواء'},
    'medicineName': {'en': 'Medicine Name', 'ar': 'اسم الدواء'},
    'quantity': {'en': 'Quantity', 'ar': 'الكمية'},
    'unit': {'en': 'Unit', 'ar': 'الوحدة'},
    'expirationDate': {'en': 'Expiration Date', 'ar': 'تاريخ الانتهاء'},
    'manufacturer': {'en': 'Manufacturer', 'ar': 'الشركة المصنعة'},
    'condition': {'en': 'Condition', 'ar': 'الحالة'},
    'yourLocation': {'en': 'Your Location', 'ar': 'موقعك'},
    'submitDonation': {'en': 'Register', 'ar': 'تسجيل'},

    // ── Request ──
    'requestMedicineTitle': {'en': 'Request Medicine', 'ar': 'طلب دواء'},
    'continueToRequest': {'en': 'Continue to Request', 'ar': 'المتابعة للطلب'},
    'requestDetails': {'en': 'Request Details', 'ar': 'تفاصيل الطلب'},
    'prescriptionDate': {'en': 'Prescription Date', 'ar': 'تاريخ الوصفة'},
    'contactNumber': {'en': 'Contact Number', 'ar': 'رقم التواصل'},
    'deliveryLocation': {'en': 'Delivery/Pickup Location', 'ar': 'موقع التوصيل/الاستلام'},

    // ── Profile ──
    'memberSince': {'en': 'Member since', 'ar': 'عضو منذ'},
    'donated': {'en': 'Donated', 'ar': 'تبرعات'},
    'requested': {'en': 'Requested', 'ar': 'طلبات'},
    'active': {'en': 'Active', 'ar': 'نشط'},
    'myActivity': {'en': 'My Activity', 'ar': 'نشاطي'},
    'myDonations': {'en': 'My Donations', 'ar': 'تبرعاتي'},
    'myRequests': {'en': 'My Requests', 'ar': 'طلباتي'},
    'account': {'en': 'Account', 'ar': 'الحساب'},
    'editProfile': {'en': 'Edit Profile', 'ar': 'تعديل الملف'},
    'changePassword': {'en': 'Change Password', 'ar': 'تغيير كلمة المرور'},
    'settings': {'en': 'Settings', 'ar': 'الإعدادات'},
    'logOut': {'en': 'Log Out', 'ar': 'تسجيل الخروج'},
    'logOutConfirm': {'en': 'Are you sure you want to log out?', 'ar': 'هل أنت متأكد من تسجيل الخروج؟'},
    'cancel': {'en': 'Cancel', 'ar': 'إلغاء'},

    // ── Settings ──
    'notifications': {'en': 'Notifications', 'ar': 'الإشعارات'},
    'darkMode': {'en': 'Dark Mode', 'ar': 'الوضع الداكن'},
    'language': {'en': 'Language', 'ar': 'اللغة'},
    'arabic': {'en': 'العربية', 'ar': 'العربية'},
    'english': {'en': 'English', 'ar': 'English'},
    'appVersion': {'en': 'App Version', 'ar': 'إصدار التطبيق'},
    'termsOfService': {'en': 'Terms of Service', 'ar': 'شروط الخدمة'},
    'privacyPolicy': {'en': 'Privacy Policy', 'ar': 'سياسة الخصوصية'},
    'deleteAccount': {'en': 'Delete Account', 'ar': 'حذف الحساب'},
    'deleteAccountMsg': {'en': 'Contact support to delete your account.', 'ar': 'تواصل مع الدعم لحذف حسابك.'},
    'view': {'en': 'View', 'ar': 'عرض'},

    // ── Edit Profile ──
    'email': {'en': 'Email (Optional)', 'ar': 'البريد الإلكتروني (اختياري)'},
    'location': {'en': 'Location', 'ar': 'الموقع'},
    'saveChanges': {'en': 'Save Changes', 'ar': 'حفظ التغييرات'},
    'profileUpdated': {'en': 'Profile updated!', 'ar': 'تم تحديث الملف!'},

    // ── Success ──
    'successTitle': {'en': 'Successfully Submitted!', 'ar': 'تم الإرسال بنجاح!'},
    'donationSuccess': {'en': "Your medicine donation has been registered. We'll notify you when someone requests it.", 'ar': 'تم تسجيل تبرعك بالدواء. سنخبرك عندما يطلبه أحد.'},
    'requestSuccess': {'en': "Your medicine request has been submitted. We'll match you with available donations.", 'ar': 'تم إرسال طلبك. سنطابقك مع التبرعات المتاحة.'},
    'backToHome': {'en': 'Back to Home', 'ar': 'العودة للرئيسية'},
    'viewMyDonations': {'en': 'View My Donations', 'ar': 'عرض تبرعاتي'},
    'viewMyRequests': {'en': 'View My Requests', 'ar': 'عرض طلباتي'},

    // ── Common ──
    'required': {'en': 'Required', 'ar': 'مطلوب'},
    'optional': {'en': 'Optional', 'ar': 'اختياري'},
    'available': {'en': 'Available', 'ar': 'متاح'},
    'pending': {'en': 'Pending', 'ar': 'معلق'},
    'approved': {'en': 'Approved', 'ar': 'موافق عليه'},
    'completed': {'en': 'Completed', 'ar': 'مكتمل'},
    'continueToForm': {'en': 'Continue to Form', 'ar': 'المتابعة للنموذج'},
    'selectCategory': {'en': 'Select Category', 'ar': 'اختر الفئة'},
    'selectCondition': {'en': 'Select Condition', 'ar': 'اختر الحالة'},

    // ── Donate Guidelines ──
    'donateGuidelineDesc': {'en': 'Your contribution helps provide critical care to those in need. Please review the guidelines before donating.', 'ar': 'مساهمتك تساعد في توفير رعاية حيوية للمحتاجين. يرجى مراجعة الإرشادات قبل التبرع.'},
    'sealedUnexpired': {'en': 'Sealed & Unexpired', 'ar': 'مختوم وغير منتهي الصلاحية'},
    'sealedUnexpiredDesc': {'en': 'Medicine must be in its original, unopened packaging with intact seals.', 'ar': 'يجب أن يكون الدواء في عبوته الأصلية غير المفتوحة مع الأختام سليمة.'},
    'threeMonthsMin': {'en': '3 Months Minimum', 'ar': '3 أشهر كحد أدنى'},
    'threeMonthsMinDesc': {'en': 'Items must have at least 3 months remaining before their printed expiration date.', 'ar': 'يجب أن يتبقى 3 أشهر على الأقل قبل تاريخ انتهاء الصلاحية.'},
    'originalPackaging': {'en': 'Original Packaging', 'ar': 'العبوة الأصلية'},
    'originalPackagingDesc': {'en': 'All donations must include the original manufacturer packaging and information.', 'ar': 'يجب أن تتضمن جميع التبرعات العبوة الأصلية من الشركة المصنعة.'},
    'donateWarning': {'en': 'Note: We cannot accept temperature-controlled medicines (like insulin) or scheduled narcotics.', 'ar': 'ملاحظة: لا يمكننا قبول الأدوية التي تتطلب تبريد (مثل الأنسولين) أو المواد المخدرة.'},

    // ── Request Guidelines ──
    'requestGuidelineDesc': {'en': "Don't hesitate, We are here to help you get the medicine you need.", 'ar': 'لا تتردد، نحن هنا لمساعدتك في الحصول على الدواء الذي تحتاجه.'},
    'guidelinesForRequesting': {'en': 'Guidelines for Requesting', 'ar': 'إرشادات الطلب'},
    'accurateDosage': {'en': 'Accurate Dosage', 'ar': 'الجرعة الدقيقة'},
    'accurateDosageDesc': {'en': 'Please ensure you provide the exact dosage and quantity needed as prescribed by your doctor.', 'ar': 'يرجى التأكد من تقديم الجرعة والكمية المطلوبة كما وصفها الطبيب.'},
    'uploadPrescription': {'en': 'Upload Prescription', 'ar': 'رفع الوصفة الطبية'},
    'uploadPrescriptionDesc': {'en': 'A clear, readable photo or scan of a valid prescription is required for all medicine requests.', 'ar': 'صورة واضحة أو نسخة ممسوحة من وصفة طبية سارية مطلوبة لجميع طلبات الأدوية.'},
    'honestyIntegrity': {'en': 'Honesty & Integrity', 'ar': 'الصدق والنزاهة'},
    'honestyIntegrityDesc': {'en': 'Only request medicines you genuinely need to ensure resources are available for all community members.', 'ar': 'اطلب فقط الأدوية التي تحتاجها فعلاً لضمان توفر الموارد لجميع أعضاء المجتمع.'},
    'promptResponse': {'en': 'Prompt Response', 'ar': 'استجابة سريعة'},
    'promptResponseDesc': {'en': 'We aim to review requests within 24 hours. Please monitor your notifications for updates.', 'ar': 'نهدف لمراجعة الطلبات خلال 24 ساعة. يرجى متابعة الإشعارات للحصول على التحديثات.'},

    // ── Donate Form ──
    'donateFormInfo': {'en': 'Please provide accurate details about the medicine you wish to donate to ensure it meets our safety guidelines.', 'ar': 'يرجى تقديم تفاصيل دقيقة عن الدواء الذي ترغب في التبرع به لضمان استيفاء إرشادات السلامة.'},
    'medicineNameRequired': {'en': 'Medicine Name *', 'ar': 'اسم الدواء *'},
    'categoryRequired': {'en': 'Category *', 'ar': 'الفئة *'},
    'quantityRequired': {'en': 'Quantity *', 'ar': 'الكمية *'},
    'unitRequired': {'en': 'Unit *', 'ar': 'الوحدة *'},
    'expirationDateRequired': {'en': 'Expiration Date *', 'ar': 'تاريخ الانتهاء *'},
    'expiryNote': {'en': 'Medicines must have at least 3 months until expiration.', 'ar': 'يجب أن يتبقى 3 أشهر على الأقل حتى انتهاء الصلاحية.'},
    'manufacturerOptional': {'en': 'Manufacturer (Optional)', 'ar': 'الشركة المصنعة (اختياري)'},
    'conditionRequired': {'en': 'Condition *', 'ar': 'الحالة *'},
    'locationRequired': {'en': 'Your Location *', 'ar': 'موقعك *'},

    // ── Request Form ──
    'requestFormInfo': {'en': 'Please provide accurate details for the medicine you are requesting. This helps us match your request with available donations quickly.', 'ar': 'يرجى تقديم تفاصيل دقيقة للدواء الذي تطلبه. هذا يساعدنا في مطابقة طلبك مع التبرعات المتاحة بسرعة.'},
    'prescriptionDateRequired': {'en': 'Prescription Date *', 'ar': 'تاريخ الوصفة *'},
    'prescriptionNote': {'en': 'Required to verify ongoing medical need.', 'ar': 'مطلوب للتحقق من الحاجة الطبية المستمرة.'},
    'contactRequired': {'en': 'Contact Number *', 'ar': 'رقم التواصل *'},
    'deliveryRequired': {'en': 'Delivery/Pickup Location *', 'ar': 'موقع التوصيل/الاستلام *'},

    // ── Medicine Details ──
    'description': {'en': 'Description', 'ar': 'الوصف'},
    'expiryDate': {'en': 'Expiry Date', 'ar': 'تاريخ الانتهاء'},
    'requestThisMedicine': {'en': 'Request This Medicine', 'ar': 'اطلب هذا الدواء'},
    'requestSubmitted': {'en': 'Request submitted! We will notify you.', 'ar': 'تم إرسال الطلب! سنخبرك.'},
    'unavailable': {'en': 'UNAVAILABLE', 'ar': 'غير متاح'},

    // ── Snackbar / Feedback ──
    'verificationSent': {'en': 'Verification code sent!', 'ar': 'تم إرسال رمز التحقق!'},
    'passwordUpdated': {'en': 'Password updated successfully!', 'ar': 'تم تحديث كلمة المرور بنجاح!'},
    'nameRequired': {'en': 'Name is required', 'ar': 'الاسم مطلوب'},
    'phoneRequired': {'en': 'Phone number is required', 'ar': 'رقم الهاتف مطلوب'},
    'passwordRequired': {'en': 'Password is required', 'ar': 'كلمة المرور مطلوبة'},
    'passwordMinLength': {'en': 'Password must be at least 8 characters', 'ar': 'كلمة المرور يجب أن تكون 8 أحرف على الأقل'},
    'confirmPasswordError': {'en': 'Please confirm your password', 'ar': 'يرجى تأكيد كلمة المرور'},
    'passwordsNoMatch': {'en': 'Passwords do not match', 'ar': 'كلمات المرور غير متطابقة'},
    'nameMinLength': {'en': 'Name must be at least 2 characters', 'ar': 'الاسم يجب أن يكون حرفين على الأقل'},
    'minEightChars': {'en': 'Minimum 8 characters', 'ar': '8 أحرف على الأقل'},

    // ── Medicine Card ──
    'qty': {'en': 'Qty', 'ar': 'الكمية'},
    'exp': {'en': 'Exp', 'ar': 'انتهاء'},

    // ── Categories ──
    'catAntibiotics': {'en': 'Antibiotics', 'ar': 'مضادات حيوية'},
    'catPainRelief': {'en': 'Pain Relief', 'ar': 'مسكنات الألم'},
    'catVitamins': {'en': 'Vitamins', 'ar': 'فيتامينات'},
    'catChronicCare': {'en': 'Chronic Care', 'ar': 'رعاية مزمنة'},
    'catFirstAid': {'en': 'First Aid', 'ar': 'إسعافات أولية'},

    // ── Hint Texts ──
    'hintFullName': {'en': 'John Doe', 'ar': 'محمد أحمد'},
    'hintEnterName': {'en': 'Enter your name', 'ar': 'أدخل اسمك'},

    // ── Profile placeholders ──
    'medicinesDonated': {'en': 'medicines donated', 'ar': 'أدوية تم التبرع بها'},
    'medicinesRequested': {'en': 'medicines requested', 'ar': 'أدوية تم طلبها'},

    // ── Form Hints ──
    'hintMedicineExample': {'en': 'e.g. Amoxicillin, Paracetamol', 'ar': 'مثال: أموكسيسيلين، باراسيتامول'},
    'hintMedicineWithDose': {'en': 'e.g. Amoxicillin 500mg', 'ar': 'مثال: أموكسيسيلين 500 مجم'},
    'hintManufacturer': {'en': 'e.g. Pfizer, GSK', 'ar': 'مثال: فايزر، GSK'},
    'hintSpecificBrand': {'en': 'Specific brand if required', 'ar': 'علامة تجارية محددة إن لزم'},
    'hintCityArea': {'en': 'City, Area', 'ar': 'المدينة، المنطقة'},
    'hintFullAddress': {'en': 'Enter full address or preferred clinic', 'ar': 'أدخل العنوان الكامل أو العيادة المفضلة'},
    'hintPhone': {'en': '100 123 4567', 'ar': '100 123 4567'},
    'hintPhoneIntl': {'en': '+20 100 000 0000', 'ar': '+20 100 000 0000'},
    'hintDateFormat': {'en': 'mm/dd/yyyy', 'ar': 'yyyy/mm/dd'},

    // ── Activity Statuses ──
    'statusPending': {'en': 'Pending', 'ar': 'قيد الانتظار'},
    'statusApproved': {'en': 'Approved', 'ar': 'موافق عليه'},
    'statusCompleted': {'en': 'Completed', 'ar': 'مكتمل'},

    // ── Empty States ──
    'noDonationsYet': {'en': 'No donations yet', 'ar': 'لا توجد تبرعات بعد'},
    'noRequestsYet': {'en': 'No requests yet', 'ar': 'لا توجد طلبات بعد'},
    'startDonating': {'en': 'Start by donating medicine to the community', 'ar': 'ابدأ بالتبرع بالأدوية للمجتمع'},
    'startRequesting': {'en': 'Browse medicines and make your first request', 'ar': 'تصفح الأدوية وقدم طلبك الأول'},

    // ── Medicine Form Dropdown Options ──
    'formCatAntibiotic': {'en': 'Antibiotic', 'ar': 'مضاد حيوي'},
    'formCatPainkiller': {'en': 'Painkiller', 'ar': 'مسكن'},
    'formCatDiabetes': {'en': 'Diabetes', 'ar': 'سكري'},
    'formCatVitamins': {'en': 'Vitamins', 'ar': 'فيتامينات'},
    'formCatHeart': {'en': 'Heart', 'ar': 'قلب'},
    'formCatAllergy': {'en': 'Allergy', 'ar': 'حساسية'},
    'formCatOther': {'en': 'Other', 'ar': 'أخرى'},

    'unitTablets': {'en': 'Tablets', 'ar': 'أقراص'},
    'unitCapsules': {'en': 'Capsules', 'ar': 'كبسولات'},
    'unitBottles': {'en': 'Bottles', 'ar': 'زجاجات'},
    'unitBoxes': {'en': 'Boxes', 'ar': 'علب'},
    'unitStrips': {'en': 'Strips', 'ar': 'شرائح'},
    'unitVials': {'en': 'Vials', 'ar': 'قوارير'},
    'unitTubes': {'en': 'Tubes', 'ar': 'أنابيب'},

    'condSealed': {'en': 'Sealed', 'ar': 'مغلق'},
    'condUnopened': {'en': 'Unopened', 'ar': 'غير مفتوح'},
    'condPartiallyUsed': {'en': 'Partially Used', 'ar': 'مستخدم جزئياً'},
    'condNew': {'en': 'New', 'ar': 'جديد'},

    // ── Request Medicine Screen (new design) ──
    'requestSubtitleMotivation': {'en': "Don't hesitate, We are here\nto help you", 'ar': 'لا تتردد، نحن هنا\nلمساعدتك'},
    'searchForMedicine': {'en': 'Search for a medicine...', 'ar': 'ابحث عن دواء...'},
    'withMedicineImage': {'en': 'With medicine image', 'ar': 'بصورة الدواء'},
    'withPrescription': {'en': 'With Prescription', 'ar': 'بالروشتة'},
    'catDiabetes': {'en': 'Diabetes', 'ar': 'السكري'},
    'catChronicDiseases': {'en': 'Chronic Diseases', 'ar': 'أمراض مزمنة'},
    'catPainkillers': {'en': 'Painkillers', 'ar': 'مسكنات'},
    'catAntibioticsGrid': {'en': 'Antibiotics', 'ar': 'مضادات حيوية'},
    'catBloodPressure': {'en': 'Blood Pressure', 'ar': 'ضغط الدم'},
    'catSkinCare': {'en': 'Skin Care', 'ar': 'العناية بالبشرة'},
  };

  String _t(String key) {
    return _localizedValues[key]?[locale.languageCode] ??
        _localizedValues[key]?['en'] ??
        key;
  }

  // App Identity
  String get appName => _t('appName');
  String get appTagline => _t('appTagline');

  // Navigation
  String get home => _t('home');
  String get browse => _t('browse');
  String get profile => _t('profile');

  // Home
  String get welcomeBack => _t('welcomeBack');
  String get whatToDo => _t('whatToDo');
  String get donateMedicine => _t('donateMedicine');
  String get donateSubtitle => _t('donateSubtitle');
  String get requestMedicine => _t('requestMedicine');
  String get requestSubtitle => _t('requestSubtitle');
  String get browseAvailable => _t('browseAvailable');
  String get browseSubtitle => _t('browseSubtitle');

  // Auth
  String get profileLogin => _t('profileLogin');
  String get loginSubtitle => _t('loginSubtitle');
  String get phoneNumber => _t('phoneNumber');
  String get password => _t('password');
  String get forgotPassword => _t('forgotPassword');
  String get logIn => _t('logIn');
  String get noAccount => _t('noAccount');
  String get signUp => _t('signUp');
  String get signUpTitle => _t('signUpTitle');
  String get signUpSubtitle => _t('signUpSubtitle');
  String get fullName => _t('fullName');
  String get setPassword => _t('setPassword');
  String get confirmPassword => _t('confirmPassword');
  String get register => _t('register');
  String get alreadyAccount => _t('alreadyAccount');
  String get login => _t('login');
  String get forgotPasswordTitle => _t('forgotPasswordTitle');
  String get forgotPasswordSubtitle => _t('forgotPasswordSubtitle');
  String get resetPassword => _t('resetPassword');
  String get tryAnotherWay => _t('tryAnotherWay');
  String get createNewPassword => _t('createNewPassword');
  String get createPasswordSubtitle => _t('createPasswordSubtitle');
  String get newPassword => _t('newPassword');

  // Browse
  String get availableMedicines => _t('availableMedicines');
  String get browseDescription => _t('browseDescription');
  String get searchMedicines => _t('searchMedicines');
  String get category => _t('category');
  String get allCategories => _t('allCategories');
  String get noMedicinesFound => _t('noMedicinesFound');
  String get noMedicinesAvailable => _t('noMedicinesAvailable');
  String get clearFilters => _t('clearFilters');

  // Profile
  String get memberSince => _t('memberSince');
  String get donated => _t('donated');
  String get requested => _t('requested');
  String get active => _t('active');
  String get myActivity => _t('myActivity');
  String get myDonations => _t('myDonations');
  String get myRequests => _t('myRequests');
  String get account => _t('account');
  String get editProfile => _t('editProfile');
  String get changePassword => _t('changePassword');
  String get settings => _t('settings');
  String get logOut => _t('logOut');
  String get logOutConfirm => _t('logOutConfirm');
  String get cancel => _t('cancel');

  // Settings
  String get notifications => _t('notifications');
  String get darkMode => _t('darkMode');
  String get language => _t('language');
  String get arabic => _t('arabic');
  String get english => _t('english');
  String get appVersion => _t('appVersion');
  String get termsOfService => _t('termsOfService');
  String get privacyPolicy => _t('privacyPolicy');
  String get deleteAccount => _t('deleteAccount');
  String get deleteAccountMsg => _t('deleteAccountMsg');
  String get view => _t('view');

  // Edit Profile
  String get email => _t('email');
  String get location => _t('location');
  String get saveChanges => _t('saveChanges');
  String get profileUpdated => _t('profileUpdated');

  // Success
  String get successTitle => _t('successTitle');
  String get donationSuccess => _t('donationSuccess');
  String get requestSuccess => _t('requestSuccess');
  String get backToHome => _t('backToHome');
  String get viewMyDonations => _t('viewMyDonations');
  String get viewMyRequests => _t('viewMyRequests');

  // Common
  String get required => _t('required');
  String get optional => _t('optional');
  String get available => _t('available');
  String get pending => _t('pending');
  String get approved => _t('approved');
  String get completed => _t('completed');

  // Donate & Request
  String get medicineName => _t('medicineName');
  String get quantity => _t('quantity');
  String get medicineDetails => _t('medicineDetails');
  String get continueToForm => _t('continueToForm');
  String get selectCategory => _t('selectCategory');
  String get selectCondition => _t('selectCondition');
  String get manufacturer => _t('manufacturer');
  String get condition => _t('condition');

  // Donate Guidelines
  String get donateGuidelineDesc => _t('donateGuidelineDesc');
  String get sealedUnexpired => _t('sealedUnexpired');
  String get sealedUnexpiredDesc => _t('sealedUnexpiredDesc');
  String get threeMonthsMin => _t('threeMonthsMin');
  String get threeMonthsMinDesc => _t('threeMonthsMinDesc');
  String get originalPackaging => _t('originalPackaging');
  String get originalPackagingDesc => _t('originalPackagingDesc');
  String get donateWarning => _t('donateWarning');
  String get importantGuidelines => _t('importantGuidelines');

  // Request Guidelines
  String get requestGuidelineDesc => _t('requestGuidelineDesc');
  String get guidelinesForRequesting => _t('guidelinesForRequesting');
  String get accurateDosage => _t('accurateDosage');
  String get accurateDosageDesc => _t('accurateDosageDesc');
  String get uploadPrescription => _t('uploadPrescription');
  String get uploadPrescriptionDesc => _t('uploadPrescriptionDesc');
  String get honestyIntegrity => _t('honestyIntegrity');
  String get honestyIntegrityDesc => _t('honestyIntegrityDesc');
  String get promptResponse => _t('promptResponse');
  String get promptResponseDesc => _t('promptResponseDesc');

  // Donate Form
  String get donateFormInfo => _t('donateFormInfo');
  String get medicineNameRequired => _t('medicineNameRequired');
  String get categoryRequired => _t('categoryRequired');
  String get quantityRequired => _t('quantityRequired');
  String get unitRequired => _t('unitRequired');
  String get expirationDateRequired => _t('expirationDateRequired');
  String get expiryNote => _t('expiryNote');
  String get manufacturerOptional => _t('manufacturerOptional');
  String get conditionRequired => _t('conditionRequired');
  String get locationRequired => _t('locationRequired');

  // Request Form
  String get requestFormInfo => _t('requestFormInfo');
  String get prescriptionDateRequired => _t('prescriptionDateRequired');
  String get prescriptionNote => _t('prescriptionNote');
  String get contactRequired => _t('contactRequired');
  String get deliveryRequired => _t('deliveryRequired');

  // Medicine Details
  String get description => _t('description');
  String get expiryDate => _t('expiryDate');
  String get requestThisMedicine => _t('requestThisMedicine');
  String get requestSubmitted => _t('requestSubmitted');
  String get unavailable => _t('unavailable');

  // Validation
  String get verificationSent => _t('verificationSent');
  String get passwordUpdated => _t('passwordUpdated');
  String get nameRequired => _t('nameRequired');
  String get phoneRequired => _t('phoneRequired');
  String get passwordRequired => _t('passwordRequired');
  String get passwordMinLength => _t('passwordMinLength');
  String get confirmPasswordError => _t('confirmPasswordError');
  String get passwordsNoMatch => _t('passwordsNoMatch');
  String get nameMinLength => _t('nameMinLength');
  String get minEightChars => _t('minEightChars');

  // Medicine Card
  String get qty => _t('qty');
  String get exp => _t('exp');

  // Categories
  String get catAntibiotics => _t('catAntibiotics');
  String get catPainRelief => _t('catPainRelief');
  String get catVitamins => _t('catVitamins');
  String get catChronicCare => _t('catChronicCare');
  String get catFirstAid => _t('catFirstAid');

  // Hints
  String get hintFullName => _t('hintFullName');
  String get hintEnterName => _t('hintEnterName');

  // Profile placeholders
  String get medicinesDonated => _t('medicinesDonated');
  String get medicinesRequested => _t('medicinesRequested');

  // Form Hints
  String get hintMedicineExample => _t('hintMedicineExample');
  String get hintMedicineWithDose => _t('hintMedicineWithDose');
  String get hintManufacturer => _t('hintManufacturer');
  String get hintSpecificBrand => _t('hintSpecificBrand');
  String get hintCityArea => _t('hintCityArea');
  String get hintFullAddress => _t('hintFullAddress');
  String get hintPhone => _t('hintPhone');
  String get hintPhoneIntl => _t('hintPhoneIntl');
  String get hintDateFormat => _t('hintDateFormat');

  // Activity Statuses
  String get statusPending => _t('statusPending');
  String get statusApproved => _t('statusApproved');
  String get statusCompleted => _t('statusCompleted');

  // Empty States
  String get noDonationsYet => _t('noDonationsYet');
  String get noRequestsYet => _t('noRequestsYet');
  String get startDonating => _t('startDonating');
  String get startRequesting => _t('startRequesting');

  // Medicine Form Dropdown Options (as lists)
  List<String> get formCategories => [
    _t('formCatAntibiotic'), _t('formCatPainkiller'), _t('formCatDiabetes'),
    _t('formCatVitamins'), _t('formCatHeart'), _t('formCatAllergy'), _t('formCatOther'),
  ];
  List<String> get formUnits => [
    _t('unitTablets'), _t('unitCapsules'), _t('unitBottles'),
    _t('unitBoxes'), _t('unitStrips'), _t('unitVials'), _t('unitTubes'),
  ];
  List<String> get formConditions => [
    _t('condSealed'), _t('condUnopened'), _t('condPartiallyUsed'), _t('condNew'),
  ];
  String get unitTablets => _t('unitTablets');
  String get unitCapsules => _t('unitCapsules');
  String get unitBoxes => _t('unitBoxes');
  String get condSealed => _t('condSealed');
  String get condUnopened => _t('condUnopened');
  String get condNew => _t('condNew');

  // Request Medicine Screen (new design)
  String get requestSubtitleMotivation => _t('requestSubtitleMotivation');
  String get searchForMedicine => _t('searchForMedicine');
  String get withMedicineImage => _t('withMedicineImage');
  String get withPrescription => _t('withPrescription');
  String get catDiabetes => _t('catDiabetes');
  String get catChronicDiseases => _t('catChronicDiseases');
  String get catPainkillers => _t('catPainkillers');
  String get catAntibioticsGrid => _t('catAntibioticsGrid');
  String get catBloodPressure => _t('catBloodPressure');
  String get catSkinCare => _t('catSkinCare');
}

/// Delegate for loading [S] localizations.
class AppLocalizationsDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<S> load(Locale locale) async => S(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

/// Extension for easy access: `context.l10n.appName`
extension AppLocalizationsX on BuildContext {
  S get l10n => S.of(this);
}
