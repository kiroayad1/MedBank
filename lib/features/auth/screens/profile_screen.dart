import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../auth/providers/auth_provider.dart';

/// Profile Screen — user info, account actions, and logout.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final l = context.l10n;
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.profile, style: theme.appBarTheme.titleTextStyle),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ── Avatar + Info ──
            _AvatarSection(
              colors: colors,
              isDark: isDark,
              fullName: authState.fullName ?? 'User',
              phoneNumber: authState.phoneNumber ?? '+20 100 000 0000',
            ),
            AppSpacing.gapXxl,

            // ── Account Section ──
            _SectionCard(
              title: l.account,
              icon: Icons.manage_accounts_rounded,
              isDark: isDark,
              children: [
                _ActionTile(
                  icon: Icons.edit_rounded,
                  title: l.editProfile,
                  color: colors.primary,
                  onTap: () => context.pushNamed(RouteNames.editProfile),
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
                _ActionTile(
                  icon: Icons.lock_outline_rounded,
                  title: l.changePassword,
                  color: const Color(0xFF8B5CF6),
                  onTap: () => context.pushNamed(RouteNames.changePassword),
                ),
                Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.dividerDark
                      : AppColors.dividerLight,
                ),
                _ActionTile(
                  icon: Icons.settings_outlined,
                  title: l.settings,
                  color: const Color(0xFF6B7280),
                  onTap: () => context.pushNamed(RouteNames.settings),
                ),
              ],
            ),
            AppSpacing.gapXxl,

            // ── Logout ──
            AppButton(
              label: l.logOut,
              variant: AppButtonVariant.secondary,
              icon: Icons.logout_rounded,
              onPressed: () => _showLogoutDialog(context, ref),
            ),
            AppSpacing.gapSection,
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) {
        final l = S.of(ctx);
        return AlertDialog(
          title: Text(l.logOut),
          content: Text(l.logOutConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                ref.read(authProvider.notifier).logout();
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: Text(l.logOut),
            ),
          ],
        );
      },
    );
  }
}

// ── Avatar Section ──
class _AvatarSection extends StatelessWidget {
  const _AvatarSection({
    required this.colors,
    required this.isDark,
    required this.fullName,
    required this.phoneNumber,
  });

  final ColorScheme colors;
  final bool isDark;
  final String fullName;
  final String phoneNumber;

  String get initials {
    final parts = fullName.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colors.primary, colors.primary.withValues(alpha: 0.7)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: Text(
              initials,
              style: AppTypography.headlineLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        AppSpacing.gapLg,
        Text(
          fullName,
          style: AppTypography.headlineMedium.copyWith(color: colors.onSurface),
        ),
        AppSpacing.gapXs,
        Text(
          phoneNumber,
          style: AppTypography.bodyMedium.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
        AppSpacing.gapXs,
        Text(
          '${context.l10n.memberSince} Apr 2026',
          style: AppTypography.labelSmall.copyWith(
            color: colors.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}

// ── Section Card ──
class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.isDark,
    required this.children,
  });
  final String title;
  final IconData icon;
  final bool isDark;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: AppShapes.borderRadiusLg,
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Icon(icon, size: 18, color: colors.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.titleSmall.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

// ── Action Tile ──
class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: AppShapes.borderRadiusSm,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.titleSmall.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ),
              Icon(
                isRtl
                    ? Icons.chevron_left_rounded
                    : Icons.chevron_right_rounded,
                color: colors.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
