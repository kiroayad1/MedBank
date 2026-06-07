import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';

/// Reusable success/confirmation screen with animated checkmark.
class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key, this.type = 'donation'});
  final String type;

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  late final String _reference;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: AppDurations.slow);
    _scale = CurvedAnimation(parent: _ctrl, curve: AppDurations.overshoot);
    _fade = CurvedAnimation(parent: _ctrl, curve: AppDurations.entrance);
    _ctrl.forward();
    // Generate dynamic reference: MB-YYYYMMDD-XXXX
    final now = DateTime.now();
    final random = Random().nextInt(9000) + 1000;
    _reference =
        '#MB-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-$random';
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    final isDonation = widget.type == 'donation';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Animated checkmark
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
              ),
              AppSpacing.gapXxxl,
              // Title
              FadeTransition(
                opacity: _fade,
                child: Text(
                  l.successTitle,
                  style: AppTypography.headlineLarge.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              AppSpacing.gapMd,
              FadeTransition(
                opacity: _fade,
                child: Text(
                  isDonation ? l.donationSuccess : l.requestSuccess,
                  style: AppTypography.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              AppSpacing.gapXxl,
              // Reference card
              FadeTransition(
                opacity: _fade,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.06),
                    borderRadius: AppShapes.borderRadiusMd,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.tag_rounded,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${l.reference}: $_reference',
                        style: AppTypography.titleSmall.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 3),
              // Buttons
              AppButton(
                label: l.backToHome,
                onPressed: () => context.goNamed(RouteNames.home),
              ),
              AppSpacing.gapMd,
              AppButton(
                label: isDonation ? l.viewMyDonations : l.viewMyRequests,
                variant: AppButtonVariant.text,
                onPressed: () => context.pushNamed(
                  isDonation ? RouteNames.myDonations : RouteNames.myRequests,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
