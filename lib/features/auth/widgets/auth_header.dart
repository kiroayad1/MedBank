import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

/// Auth header with app logo, title, and subtitle.
///
/// Used at the top of Login & Sign Up screens.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showLogo = true,
  });

  final String title;
  final String subtitle;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Logo / Icon circle
        if (showLogo)
          Container(
            width: AppSpacing.iconCircleLarge,
            height: AppSpacing.iconCircleLarge,
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        AppSpacing.gapXxl,
        Text(
          title,
          style: AppTypography.headlineLarge.copyWith(
            color: colors.onSurface,
          ),
        ),
        AppSpacing.gapSm,
        Text(
          subtitle,
          style: AppTypography.bodyMedium.copyWith(
            color: colors.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
