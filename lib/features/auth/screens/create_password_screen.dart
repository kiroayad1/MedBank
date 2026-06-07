import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

/// Create New Password screen matching reference design.
class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.passwordUpdated)));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.appName, style: theme.appBarTheme.titleTextStyle),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkBackgroundGradient
              : AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              children: [
                AppSpacing.gapXxl,
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: AppShapes.borderRadiusXl,
                    boxShadow: isDark
                        ? AppShadows.cardDark
                        : AppShadows.cardLight,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l.createNewPassword,
                          style: AppTypography.headlineLarge.copyWith(
                            color: colors.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.gapSm,
                        Text(
                          l.createPasswordSubtitle,
                          style: AppTypography.bodyMedium.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.gapXxxl,

                        // ── New Password ──
                        AppTextField(
                          controller: _passwordController,
                          label: l.newPassword,
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
                              return l.minEightChars;
                            }
                            return null;
                          },
                        ),
                        AppSpacing.gapXl,

                        // ── Confirm Password ──
                        AppTextField(
                          controller: _confirmController,
                          label: l.confirmPassword,
                          hint: '••••••••',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: true,
                          showObscureToggle: true,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return l.passwordsNoMatch;
                            }
                            return null;
                          },
                        ),
                        AppSpacing.gapXxxl,

                        // ── Reset Button ──
                        AppButton(
                          label: l.resetPassword,
                          onPressed: _handleReset,
                          isLoading: _isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
                AppSpacing.gapSection,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
