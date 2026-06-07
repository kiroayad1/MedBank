import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

/// Forgot Password screen matching reference design.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (mounted) {
      context.pushNamed(
        RouteNames.otpVerification,
        queryParameters: {'phone': _phoneController.text},
      );
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.gapXxl,

                  Text(
                    l.forgotPasswordTitle,
                    style: AppTypography.displaySmall.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  AppSpacing.gapSm,
                  Text(
                    l.forgotPasswordSubtitle,
                    style: AppTypography.bodyMedium.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  AppSpacing.gapXxxl,

                  // ── Phone Field ──
                  AppTextField(
                    controller: _phoneController,
                    label: l.phoneNumber,
                    hint: '(555) 000-0000',
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
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
                  AppSpacing.gapXxxl,

                  // ── Reset Button ──
                  AppButton(
                    label: l.resetPassword,
                    onPressed: _handleReset,
                    isLoading: _isLoading,
                  ),


                  AppSpacing.gapXxl,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
