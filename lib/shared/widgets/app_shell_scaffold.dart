import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/theme.dart';

/// App shell with animated bottom navigation bar.
///
/// This wraps the main tabs (Home, Browse, Profile) and
/// persists state across tab switches via [StatefulShellRoute].
class AppShellScaffold extends StatelessWidget {
  const AppShellScaffold({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _AnimatedBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}

/// Custom animated bottom navigation bar with a morphing indicator.
class _AnimatedBottomNav extends StatelessWidget {
  const _AnimatedBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static List<_NavItem> _getItems(S l) => [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: l.home),
    _NavItem(icon: Icons.search_rounded, activeIcon: Icons.search_rounded, label: l.browse),
    _NavItem(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: l.profile),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        boxShadow: isDark ? AppShadows.bottomNavDark : AppShadows.bottomNavLight,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppSpacing.bottomNavHeight,
          child: Row(
            children: List.generate(_getItems(context.l10n).length, (index) {
              final item = _getItems(context.l10n)[index];
              final isActive = index == currentIndex;

              return Expanded(
                child: _NavItemWidget(
                  item: item,
                  isActive: isActive,
                  activeColor: colors.primary,
                  inactiveColor: colors.onSurfaceVariant,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _NavItemWidget extends StatelessWidget {
  const _NavItemWidget({
    required this.item,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated indicator dot
          AnimatedContainer(
            duration: AppDurations.normal,
            curve: AppDurations.entrance,
            width: isActive ? 24 : 0,
            height: 3,
            margin: const EdgeInsets.only(bottom: 4),
            decoration: BoxDecoration(
              color: activeColor,
              borderRadius: AppShapes.borderRadiusFull,
            ),
          ),
          // Icon with animated transition
          AnimatedSwitcher(
            duration: AppDurations.fast,
            child: Icon(
              isActive ? item.activeIcon : item.icon,
              key: ValueKey(isActive),
              color: isActive ? activeColor : inactiveColor,
              size: AppSpacing.iconLg,
            ),
          ),
          AppSpacing.gapXs,
          // Label
          AnimatedDefaultTextStyle(
            duration: AppDurations.fast,
            style: AppTypography.labelMedium.copyWith(
              color: isActive ? activeColor : inactiveColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
            child: Text(item.label),
          ),
        ],
      ),
    );
  }
}
