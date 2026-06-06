import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/app_localizations.dart';
import '../core/router/route_names.dart';

/// Home screen with quick action cards.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 32,
              width: 32,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(l.appName, style: theme.appBarTheme.titleTextStyle),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Text(l.welcomeBack, style: theme.textTheme.displaySmall),
        const SizedBox(height: 8),
        Text(l.whatToDo,
            style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurfaceVariant)),
        const SizedBox(height: 32),
        _QuickActionCard(icon: Icons.volunteer_activism_rounded, title: l.donateMedicine,
            subtitle: l.donateSubtitle,
            color: colors.primary, onTap: () => context.pushNamed(RouteNames.donateGuidelines)),
        const SizedBox(height: 16),
        _QuickActionCard(icon: Icons.medication_rounded, title: l.requestMedicine,
            subtitle: l.requestSubtitle,
            color: const Color(0xFF5BC0EB), onTap: () => context.pushNamed(RouteNames.requestGuidelines)),
        const SizedBox(height: 16),
        _QuickActionCard(icon: Icons.search_rounded, title: l.browseAvailable,
            subtitle: l.browseSubtitle,
            color: const Color(0xFF34C759), onTap: () => context.goNamed(RouteNames.browse)),
      ]),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.icon, required this.title,
      required this.subtitle, required this.color, required this.onTap});
  final IconData icon; final String title; final String subtitle;
  final Color color; final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return Material(
      color: isDark ? const Color(0xFF222836) : Colors.white,
      borderRadius: BorderRadius.circular(16), clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: Padding(padding: const EdgeInsets.all(20),
        child: Row(children: [
          Container(width: 56, height: 56,
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: color, size: 28)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant)),
          ])),
          Icon(
            isRtl ? Icons.arrow_back_ios_rounded : Icons.arrow_forward_ios_rounded,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ]),
      )),
    );
  }
}
