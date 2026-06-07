import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_header.dart';

/// Sign Up screen matching reference design.
///
/// Full Name, Phone, Password, Confirm Password + Register CTA.
class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authProvider.notifier).clearError();
    final cleanPhone = _phoneController.text.replaceAll(RegExp(r'\s+'), '');
    await ref.read(authProvider.notifier).register(
          name: _nameController.text.trim(),
          phone: cleanPhone,
          password: _passwordController.text,
        );
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
          gradient: isDark
              ? AppColors.darkBackgroundGradient
              : AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: AppShapes.borderRadiusXl,
                  boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Header ──
                      AuthHeader(
                        title: l.signUpTitle,
                        subtitle: l.signUpSubtitle,
                      ),
                      AppSpacing.gapXxxl,

                      // ── Error Banner ──
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

                      // ── Full Name ──
                      AppTextField(
                        controller: _nameController,
                        label: l.fullName,
                        hint: l.hintFullName,
                        prefixIcon: Icons.person_outline_rounded,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l.nameRequired;
                          }
                          if (value.trim().length < 2) {
                            return l.nameMinLength;
                          }
                          return null;
                        },
                      ),
                      AppSpacing.gapXl,

                      // ── Phone Number ──
                      AppTextField(
                        controller: _phoneController,
                        label: l.phoneNumber,
                        hint: '(555) 000-0000',
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        prefix: Padding(
                          padding: const EdgeInsetsDirectional.only(end: 8),
                          child: Text(
                            '+20',
                            style: AppTypography.bodyLarge.copyWith(
                              color: colors.onSurface,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l.phoneRequired;
                          }
                          return null;
                        },
                      ),
                      AppSpacing.gapXl,

                      // ── Set Password ──
                      AppTextField(
                        controller: _passwordController,
                        label: l.setPassword,
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: true,
                        showObscureToggle: true,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l.passwordRequired;
                          }
                          if (value.length < 8) {
                            return l.passwordMinLength;
                          }
                          return null;
                        },
                      ),
                      AppSpacing.gapXl,

                      // ── Confirm Password ──
                      AppTextField(
                        controller: _confirmPasswordController,
                        label: l.confirmPassword,
                        hint: '••••••••',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: true,
                        showObscureToggle: true,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l.confirmPasswordError;
                          }
                          if (value != _passwordController.text) {
                            return l.passwordsNoMatch;
                          }
                          return null;
                        },
                      ),
                      AppSpacing.gapXxxl,

                      // ── Register Button ──
                      AppButton(
                        label: l.register,
                        onPressed: _handleRegister,
                        isLoading: authState.isLoading,
                      ),
                      AppSpacing.gapXxl,

                      // ── Login Link ──
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            l.alreadyAccount,
                            style: AppTypography.bodyMedium.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Text(
                              l.login,
                              style: AppTypography.titleSmall.copyWith(
                                color: colors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
