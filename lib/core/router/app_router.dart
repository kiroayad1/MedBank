import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/create_password_screen.dart';
import '../../features/auth/screens/edit_profile_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/profile_screen.dart';
import '../../features/auth/screens/settings_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/medicine_details/screens/medicine_details_screen.dart';
import '../../features/medicine_details/screens/order_confirmation_screen.dart';
import '../../features/medicine_search/screens/browse_screen.dart';
import '../../features/medicine_search/screens/category_medicines_screen.dart';
import '../../features/medicine_search/screens/donate_form_screen.dart';
import '../../features/medicine_search/screens/donate_guidelines_screen.dart';
import '../../features/medicine_search/screens/request_form_screen.dart';
import '../../features/medicine_search/screens/request_guidelines_screen.dart';
import '../../features/saved_medicines/screens/my_activity_list_screen.dart';
import '../../shared/widgets/app_shell_scaffold.dart';
import '../../shared/widgets/success_screen.dart';
import 'route_names.dart';

/// GoRouter — declarative, Riverpod-integrated routing.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RoutePaths.home,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final loc = state.matchedLocation;
      final isAuthRoute = loc == RoutePaths.login || loc == RoutePaths.signUp ||
          loc == RoutePaths.forgotPassword || loc == RoutePaths.createPassword;
      if (!isLoggedIn && !isAuthRoute) return RoutePaths.login;
      if (isLoggedIn && isAuthRoute) return RoutePaths.home;
      return null;
    },
    routes: [
      // AUTH
      GoRoute(path: RoutePaths.login, name: RouteNames.login,
          builder: (context, state) => const LoginScreen()),
      GoRoute(path: RoutePaths.signUp, name: RouteNames.signUp,
          builder: (context, state) => const SignUpScreen()),
      GoRoute(path: RoutePaths.forgotPassword, name: RouteNames.forgotPassword,
          builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: RoutePaths.createPassword, name: RouteNames.createPassword,
          builder: (context, state) => const CreatePasswordScreen()),

      // MAIN SHELL
      StatefulShellRoute.indexedStack(
        builder: (context, state, nav) => AppShellScaffold(navigationShell: nav),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: RoutePaths.home, name: RouteNames.home,
                builder: (context, state) => const _HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RoutePaths.browse, name: RouteNames.browse,
                builder: (context, state) => const BrowseScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: RoutePaths.profile, name: RouteNames.profile,
                builder: (context, state) => const ProfileScreen()),
          ]),
        ],
      ),

      // DONATE FLOW
      GoRoute(path: RoutePaths.donateGuidelines, name: RouteNames.donateGuidelines,
          builder: (context, state) => const DonateGuidelinesScreen()),
      GoRoute(path: RoutePaths.donateForm, name: RouteNames.donateForm,
          builder: (context, state) => DonateFormScreen(imagePath: state.uri.queryParameters['imagePath'])),

      // REQUEST FLOW
      GoRoute(path: RoutePaths.requestGuidelines, name: RouteNames.requestGuidelines,
          builder: (context, state) => const RequestGuidelinesScreen()),
      GoRoute(path: RoutePaths.requestForm, name: RouteNames.requestForm,
          builder: (context, state) {
            final params = state.uri.queryParameters;
            return RequestFormScreen(
              imagePath: params['imagePath'],
              initialName: params['name'],
              initialCategory: params['category'],
              initialUnit: params['unit'],
            );
          }),
      GoRoute(path: RoutePaths.categoryMedicines, name: RouteNames.categoryMedicines,
          builder: (context, state) => CategoryMedicinesScreen(category: state.pathParameters['category'] ?? '')),

      // MEDICINE DETAILS
      GoRoute(path: RoutePaths.medicineDetails, name: RouteNames.medicineDetails,
          builder: (_, state) => MedicineDetailsScreen(medicineId: state.pathParameters['id'] ?? '1')),

      // ORDER CONFIRMATION
      GoRoute(path: RoutePaths.orderConfirmation, name: RouteNames.orderConfirmation,
          builder: (_, state) => OrderConfirmationScreen(medicineId: state.pathParameters['id'] ?? '1')),

      // PROFILE SUB-ROUTES
      GoRoute(path: RoutePaths.editProfile, name: RouteNames.editProfile,
          builder: (context, state) => const EditProfileScreen()),
      GoRoute(path: RoutePaths.changePassword, name: RouteNames.changePassword,
          builder: (context, state) => const CreatePasswordScreen()),
      GoRoute(path: RoutePaths.settings, name: RouteNames.settings,
          builder: (context, state) => const SettingsScreen()),
      GoRoute(path: RoutePaths.myDonations, name: RouteNames.myDonations,
          builder: (context, state) => const MyActivityListScreen(isDonations: true)),
      GoRoute(path: RoutePaths.myRequests, name: RouteNames.myRequests,
          builder: (context, state) => const MyActivityListScreen(isDonations: false)),

      // SUCCESS
      GoRoute(path: RoutePaths.success, name: RouteNames.success,
          builder: (_, state) => SuccessScreen(type: state.uri.queryParameters['type'] ?? 'donation')),
    ],
  );
});

/// Home screen with quick action cards.
class _HomeScreen extends StatelessWidget {
  const _HomeScreen();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(l.appName, style: theme.appBarTheme.titleTextStyle),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Text(l.welcomeBack, style: theme.textTheme.displaySmall),
        const SizedBox(height: 8),
        Text(l.whatToDo,
            style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurfaceVariant)),
        const SizedBox(height: 32),
        _QuickActionCard(icon: Icons.volunteer_activism_rounded, title: l.donateMedicine,
            subtitle: l.donateSubtitle,
            color: colors.primary, onTap: () => context.pushNamed(RouteNames.donateGuidelines)),
        const SizedBox(height: 16),
        _QuickActionCard(icon: Icons.medication_rounded, title: l.requestMedicine,
            subtitle: l.requestSubtitle,
            color: const Color(0xFF5BC0EB), onTap: () => context.pushNamed(RouteNames.requestGuidelines)),
        const SizedBox(height: 16),
        _QuickActionCard(icon: Icons.search_rounded, title: l.browseAvailable,
            subtitle: l.browseSubtitle,
            color: const Color(0xFF34C759), onTap: () => context.goNamed(RouteNames.browse)),
      ]),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.icon, required this.title,
      required this.subtitle, required this.color, required this.onTap});
  final IconData icon; final String title; final String subtitle;
  final Color color; final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Material(
      color: isDark ? const Color(0xFF222836) : Colors.white,
      borderRadius: BorderRadius.circular(16), clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.all(20),
        child: Row(children: [
          Container(width: 56, height: 56,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 28)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant)),
          ])),
          Icon(
            isRtl ? Icons.arrow_back_ios_rounded : Icons.arrow_forward_ios_rounded,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ]),
      )),
    );
  }
}
