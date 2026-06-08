import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:medicine_bank/core/l10n/app_localizations.dart';
import 'package:medicine_bank/core/router/route_names.dart';
import 'package:medicine_bank/core/theme/theme.dart';
import 'package:medicine_bank/features/auth/screens/otp_verification_screen.dart';

void main() {
  Widget createTestableWidget({required Widget child}) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => child,
        ),
        // Mock the next screen so context.pushNamed works
        GoRoute(
          path: '/create-password',
          name: RouteNames.createPassword,
          builder: (context, state) => const Scaffold(
            body: Text('Create Password Screen (Mock)'),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.light(),
      localizationsDelegates: const [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
    );
  }

  group('OtpVerificationScreen Tests', () {
    testWidgets('renders OTP screen with phone number and 6 input boxes',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        child: const OtpVerificationScreen(phoneNumber: '01012345678'),
      ));

      // Wait for any animations to settle
      await tester.pumpAndSettle();

      // Verify Title exists (in English)
      expect(find.text('Verify Your Number'), findsOneWidget);

      // Verify masked phone is displayed
      expect(find.textContaining('**78'), findsOneWidget);

      // Verify there are exactly 6 TextField widgets for the OTP digits
      expect(find.byType(TextField), findsNWidgets(6));

      // Verify 'Verify Code' button exists
      expect(find.text('Verify Code'), findsOneWidget);
    });

    testWidgets('Verify Code button is disabled until 6 digits are entered',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        child: const OtpVerificationScreen(phoneNumber: '01012345678'),
      ));
      await tester.pumpAndSettle();

      // Find the Verify button (ElevatedButton is inside AppButton)
      final verifyButtonFinder = find.byType(ElevatedButton);
      expect(verifyButtonFinder, findsOneWidget);

      // Get the button widget to check if it's disabled (onPressed == null)
      ElevatedButton button = tester.widget(verifyButtonFinder);
      expect(button.onPressed, isNull);

      // Enter 3 digits
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), '1');
      await tester.enterText(textFields.at(1), '2');
      await tester.enterText(textFields.at(2), '3');
      await tester.pumpAndSettle();

      // Button should still be disabled
      button = tester.widget(verifyButtonFinder);
      expect(button.onPressed, isNull);

      // Enter remaining 3 digits
      await tester.enterText(textFields.at(3), '4');
      await tester.enterText(textFields.at(4), '5');
      await tester.enterText(textFields.at(5), '6');
      await tester.pumpAndSettle();

      // Button should now be enabled
      button = tester.widget(verifyButtonFinder);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('shows invalid OTP error when entering 000000',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        child: const OtpVerificationScreen(phoneNumber: '01012345678'),
      ));
      await tester.pumpAndSettle();

      // Enter '000000' (the mock failure code)
      final textFields = find.byType(TextField);
      for (int i = 0; i < 6; i++) {
        await tester.enterText(textFields.at(i), '0');
      }
      await tester.pumpAndSettle();

      // Tap Verify
      await tester.tap(find.text('Verify Code'));
      
      // Pump twice to handle the Future.delayed in the mock verification
      await tester.pump(); 
      await tester.pump(const Duration(seconds: 1)); // Wait out the fake delay
      await tester.pumpAndSettle();

      // Verify error text is shown
      expect(find.text('Invalid verification code. Please try again.'),
          findsOneWidget);
    });

    testWidgets('navigates to create password screen on valid OTP',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        child: const OtpVerificationScreen(phoneNumber: '01012345678'),
      ));
      await tester.pumpAndSettle();

      // Enter '123456' (valid code)
      final textFields = find.byType(TextField);
      for (int i = 0; i < 6; i++) {
        await tester.enterText(textFields.at(i), (i + 1).toString());
      }
      await tester.pumpAndSettle();

      // Tap Verify
      await tester.tap(find.text('Verify Code'));
      
      // Wait out the mock API delay
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Verify we navigated to the mock Create Password screen
      expect(find.text('Create Password Screen (Mock)'), findsOneWidget);
    });
  });
}
