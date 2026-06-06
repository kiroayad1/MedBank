import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';

/// Login screen with inline error messages and shake animation.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _shakeAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).clearError();
    await ref.read(authProvider.notifier).login(
      phone: _phoneCtrl.text.trim(), password: _passwordCtrl.text,
    );
    if (ref.read(authProvider).hasError) {
      _shakeCtrl.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l = context.l10n;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkBackgroundGradient : AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: AnimatedBuilder(
                animation: _shakeAnim,
                builder: (context, child) {
                  final dx = _shakeAnim.value * 8 *
                      ((_shakeCtrl.value * 8).toInt().isEven ? 1 : -1);
                  return Transform.translate(offset: Offset(dx, 0), child: child);
                },
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: AppShapes.borderRadiusXl,
                    boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      // ── Header with logo ──
                      AuthHeader(title: l.profileLogin,
                          subtitle: l.loginSubtitle),
                      AppSpacing.gapXxxl,

                      // Error message
                      if (authState.hasError) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.08),
                            borderRadius: AppShapes.borderRadiusMd,
                            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                          ),
                          child: Row(children: [
                            const Icon(Icons.error_outline, color: AppColors.error, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(authState.errorMessage!,
                                style: AppTypography.bodySmall.copyWith(color: AppColors.error))),
                          ]),
                        ),
                        AppSpacing.gapLg,
                      ],

                      // Phone
                      AppTextField(controller: _phoneCtrl, label: l.phoneNumber,
                          hint: '100 123 4567', keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.next,
                          prefix: Padding(padding: const EdgeInsetsDirectional.only(end: 8),
                              child: Text('+2', style: AppTypography.bodyLarge.copyWith(color: colors.onSurface))),
                          validator: (v) => v == null || v.trim().isEmpty ? l.phoneRequired : null),
                      AppSpacing.gapXl,

                      // Password
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(l.password, style: AppTypography.titleSmall.copyWith(color: colors.onSurface)),
                          GestureDetector(
                              onTap: () => context.pushNamed(RouteNames.forgotPassword),
                              child: Text(l.forgotPassword,
                                  style: AppTypography.titleSmall.copyWith(color: colors.primary))),
                        ]),
                        AppSpacing.gapSm,
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: TextFormField(controller: _passwordCtrl, obscureText: true,
                              textInputAction: TextInputAction.done,
                              textDirection: TextDirection.ltr,
                              textAlign: TextAlign.left,
                              onFieldSubmitted: (_) => _handleLogin(),
                              style: AppTypography.bodyLarge.copyWith(color: colors.onSurface),
                              decoration: const InputDecoration(hintText: '••••••••', hintTextDirection: TextDirection.ltr),
                              validator: (v) => v == null || v.isEmpty ? l.passwordRequired : null),
                        ),
                      ]),
                      AppSpacing.gapXxxl,
                      AppButton(label: l.logIn, onPressed: _handleLogin, isLoading: authState.isLoading),
                      AppSpacing.gapXxl,
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(l.noAccount,
                            style: AppTypography.bodyMedium.copyWith(color: colors.onSurfaceVariant)),
                        GestureDetector(
                            onTap: () => context.pushNamed(RouteNames.signUp),
                            child: Text(l.signUp,
                                style: AppTypography.titleSmall.copyWith(color: colors.primary))),
                      ]),
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Simplified animated builder.
class AnimatedBuilder extends AnimatedWidget {
  const AnimatedBuilder({super.key, required Animation<double> animation,
    required this.builder, this.child}) : super(listenable: animation);
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;
  @override
  Widget build(BuildContext context) => builder(context, child);
}
