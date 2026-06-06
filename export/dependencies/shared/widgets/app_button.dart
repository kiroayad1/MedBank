import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';

/// Primary CTA button with loading state and optional icon.
///
/// Wraps [ElevatedButton] with app-specific styling,
/// a built-in loading spinner, and a subtle press animation.
///
/// When an [icon] is provided, it is placed at the trailing end
/// in LTR and at the leading end in RTL, and auto-mirrors directional
/// icons (arrows).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.isExpanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final AppButtonVariant variant;
  final bool isExpanded;

  /// Returns the correct icon for RTL, mirroring forward/back arrows.
  IconData? _resolvedIcon(BuildContext context) {
    if (icon == null) return null;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    if (!isRtl) return icon;
    // Mirror common directional icons
    if (icon == Icons.arrow_forward_rounded) return Icons.arrow_back_rounded;
    if (icon == Icons.arrow_forward_ios_rounded) return Icons.arrow_back_ios_rounded;
    if (icon == Icons.chevron_right_rounded) return Icons.chevron_left_rounded;
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedIcon = _resolvedIcon(context);

    final Widget child = AnimatedSwitcher(
      duration: AppDurations.fast,
      child: isLoading
          ? SizedBox(
              key: const ValueKey('loading'),
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation(
                  variant == AppButtonVariant.primary
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                ),
              ),
            )
          : Row(
              key: const ValueKey('content'),
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label),
                if (resolvedIcon != null) ...[
                  AppSpacing.gapHSm,
                  Icon(resolvedIcon, size: AppSpacing.iconMd),
                ],
              ],
            ),
    );

    final effectiveOnPressed = isLoading ? null : onPressed;

    switch (variant) {
      case AppButtonVariant.primary:
        return SizedBox(
          width: isExpanded ? double.infinity : null,
          child: ElevatedButton(
            onPressed: effectiveOnPressed,
            child: child,
          ),
        );
      case AppButtonVariant.secondary:
        return SizedBox(
          width: isExpanded ? double.infinity : null,
          child: OutlinedButton(
            onPressed: effectiveOnPressed,
            child: child,
          ),
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: effectiveOnPressed,
          child: child,
        );
    }
  }
}

enum AppButtonVariant { primary, secondary, text }
