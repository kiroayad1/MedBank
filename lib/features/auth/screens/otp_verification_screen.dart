import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';

/// OTP Verification screen for the Forgot Password flow.
///
/// Accepts the user's phone number from the previous screen and displays
/// 6 individual digit input boxes. Matches the visual style of the
/// Forgot Password screen exactly.
class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  /// The phone number entered on the Forgot Password screen.
  final String phoneNumber;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  static const int _otpLength = 6;
  static const int _resendSeconds = 60;

  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;

  bool _isLoading = false;
  String? _errorText;
  int _resendCountdown = _resendSeconds;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(_otpLength, (_) => TextEditingController());
    _focusNodes = List.generate(_otpLength, (_) => FocusNode());
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // ──────────────────────────────────────────────
  //  RESEND TIMER
  // ──────────────────────────────────────────────

  void _startResendTimer() {
    _resendCountdown = _resendSeconds;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown <= 0) {
        timer.cancel();
      } else {
        setState(() => _resendCountdown--);
      }
    });
  }

  Future<void> _handleResend() async {
    if (_resendCountdown > 0) return;
    // Simulate OTP re-send
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.verificationSent)),
      );
      _startResendTimer();
    }
  }

  // ──────────────────────────────────────────────
  //  OTP INPUT HANDLING
  // ──────────────────────────────────────────────

  bool get _isOtpComplete =>
      _controllers.every((c) => c.text.length == 1);

  String get _otpCode =>
      _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    // Clear any previous error when the user starts typing again.
    if (_errorText != null) {
      setState(() => _errorText = null);
    }

    // Extract only digits.
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    if (digits.isEmpty) {
      _controllers[index].clear();
      setState(() {});
      return;
    }

    // Handle paste: if the value has multiple digits starting from this box.
    if (digits.length > 1) {
      // Fill from current index onward.
      for (int i = 0; i < digits.length && (index + i) < _otpLength; i++) {
        _controllers[index + i].text = digits[i];
      }
      final lastFilled = (index + digits.length - 1).clamp(0, _otpLength - 1);
      if (lastFilled < _otpLength - 1) {
        _focusNodes[lastFilled + 1].requestFocus();
      } else {
        _focusNodes[lastFilled].requestFocus();
      }
      setState(() {});
      return;
    }

    // Single digit: keep only this digit in the box.
    _controllers[index].text = digits;
    _controllers[index].selection = TextSelection.collapsed(offset: 1);

    // Auto-advance to the next box.
    if (index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    setState(() {}); // Rebuild to update button enabled state.
  }



  /// Handle backspace: if current box is empty, retreat to previous box.
  KeyEventResult _handleKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _controllers[index - 1].clear();
      _focusNodes[index - 1].requestFocus();
      setState(() {});
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  // ──────────────────────────────────────────────
  //  VERIFY
  // ──────────────────────────────────────────────

  Future<void> _handleVerify() async {
    if (!_isOtpComplete) return;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    // Simulate verification with a delay.
    await Future.delayed(const Duration(seconds: 1));
    final code = _otpCode;

    // Mock validation: "000000" fails, everything else succeeds.
    final isValid = code != '000000';

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (isValid) {
      context.pushNamed(RouteNames.createPassword);
    } else {
      setState(() => _errorText = context.l10n.invalidOtp);
    }
  }

  // ──────────────────────────────────────────────
  //  PHONE MASKING
  // ──────────────────────────────────────────────

  /// Partially masks the phone number for display.
  /// E.g. "5550001234" → "+20 555 000-**34"
  String get _maskedPhone {
    final raw = widget.phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.length < 4) return '+20 $raw';
    final visible = raw.substring(0, raw.length - 4);
    final masked = '**${raw.substring(raw.length - 2)}';
    return '+20 $visible$masked';
  }

  // ──────────────────────────────────────────────
  //  BUILD
  // ──────────────────────────────────────────────

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSpacing.gapXxl,

                // ── Title ──
                Text(
                  l.verifyYourNumber,
                  style: AppTypography.displaySmall.copyWith(
                    color: colors.onSurface,
                  ),
                ),
                AppSpacing.gapSm,

                // ── Subtitle ──
                Text(
                  '${l.otpSentTo} $_maskedPhone',
                  style: AppTypography.bodyMedium.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                AppSpacing.gapXxxl,

                // ── OTP Digit Boxes ──
                _buildOtpRow(colors, isDark),

                // ── Error Text ──
                if (_errorText != null) ...[
                  AppSpacing.gapSm,
                  Text(
                    _errorText!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ],
                AppSpacing.gapXxxl,

                // ── Verify Button ──
                AppButton(
                  label: l.verifyCode,
                  onPressed: _isOtpComplete ? _handleVerify : null,
                  isLoading: _isLoading,
                ),

                AppSpacing.gapXl,

                // ── Resend Section ──
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${l.didntReceiveCode} ',
                        style: AppTypography.bodyMedium.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                      GestureDetector(
                        onTap: _resendCountdown == 0 ? _handleResend : null,
                        child: Text(
                          _resendCountdown > 0
                              ? '${l.resend} (${_resendCountdown}s)'
                              : l.resend,
                          style: AppTypography.titleSmall.copyWith(
                            color: _resendCountdown > 0
                                ? colors.onSurfaceVariant
                                : AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                AppSpacing.gapXxl,
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  //  OTP ROW WIDGET
  // ──────────────────────────────────────────────

  Widget _buildOtpRow(ColorScheme colors, bool isDark) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_otpLength, (index) {
        return SizedBox(
          width: 48,
          height: 56,
          child: KeyboardListener(
            focusNode: FocusNode(), // Wrapper focus for key events
            onKeyEvent: (event) => _handleKeyEvent(index, event),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              textDirection: TextDirection.ltr,
              style: AppTypography.headlineMedium.copyWith(
                color: colors.onSurface,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: isDark ? AppColors.cardDark : AppColors.cardLight,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: AppShapes.inputBorder(
                  color: _errorText != null
                      ? AppColors.error
                      : (isDark
                          ? AppColors.outlineDark
                          : AppColors.outlineLight),
                ),
                focusedBorder: AppShapes.inputBorderFocused(
                  color: _errorText != null
                      ? AppColors.error
                      : AppColors.primary,
                ),
              ),
              onChanged: (value) => _onDigitChanged(index, value),
            ),
          ),
        );
      }),
    ),
  );
}
}
