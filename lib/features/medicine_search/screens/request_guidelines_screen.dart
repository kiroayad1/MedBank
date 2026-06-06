import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';

/// Request Medicine screen — new design with search, action buttons,
/// and category grid. Fully localized and RTL-aware.
class RequestGuidelinesScreen extends StatelessWidget {
  const RequestGuidelinesScreen({super.key});

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null && context.mounted) {
        // Navigate to form and pass the image path
        context.pushNamed(RouteNames.requestForm, queryParameters: {
          'imagePath': image.path,
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.appName)), // Fallback error msg
        );
      }
    }
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(context, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(context, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // ── Logo Circle ──
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [colors.primary, colors.primary.withValues(alpha: 0.7)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.medication_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),

              // ── Title ──
              Text(
                l.requestMedicine,
                style: AppTypography.displaySmall.copyWith(
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l.requestSubtitleMotivation,
                textAlign: TextAlign.center,
                style: AppTypography.titleMedium.copyWith(
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),

              // ── Search Bar ──
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : const Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isDark ? AppColors.dividerDark : const Color(0xFFE8E8EC),
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: l.searchForMedicine,
                    hintStyle: AppTypography.bodyLarge.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    suffixIcon: Icon(
                      Icons.search_rounded,
                      color: colors.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                  style: AppTypography.bodyLarge.copyWith(
                    color: colors.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Action Buttons ──
              _ActionButton(
                icon: Icons.camera_alt_outlined,
                text: l.withMedicineImage,
                colors: colors,
                isDark: isDark,
                onTap: () => _showImageSourceSheet(context),
              ),
              const SizedBox(height: 12),
              _ActionButton(
                icon: Icons.receipt_long_outlined,
                text: l.withPrescription,
                colors: colors,
                isDark: isDark,
                onTap: () => _showImageSourceSheet(context),
              ),
              const SizedBox(height: 28),

              // ── Category Grid ──
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.3,
                children: [
                  _CategoryCard(
                    title: l.catDiabetes,
                    icon: Icons.bloodtype_outlined,
                    bgColor: isDark ? const Color(0xFF3D1F22) : const Color(0xFFF9D1D5),
                    iconColor: const Color(0xFFD64550),
                    onTap: () => context.pushNamed(RouteNames.categoryMedicines, pathParameters: {'category': l.catDiabetes}),
                  ),
                  _CategoryCard(
                    title: l.catChronicDiseases,
                    icon: Icons.favorite_border_rounded,
                    bgColor: isDark ? const Color(0xFF3A1A1B) : const Color(0xFFF5A3A4),
                    iconColor: const Color(0xFFA1171A),
                    onTap: () => context.pushNamed(RouteNames.categoryMedicines, pathParameters: {'category': l.catChronicDiseases}),
                  ),
                  _CategoryCard(
                    title: l.catPainkillers,
                    icon: Icons.bolt_outlined,
                    bgColor: isDark ? const Color(0xFF3A3520) : const Color(0xFFEBE0A6),
                    iconColor: const Color(0xFFB59A27),
                    onTap: () => context.pushNamed(RouteNames.categoryMedicines, pathParameters: {'category': l.catPainkillers}),
                  ),
                  _CategoryCard(
                    title: l.catAntibioticsGrid,
                    icon: Icons.medication_liquid_outlined,
                    bgColor: isDark ? const Color(0xFF2D1F3A) : const Color(0xFFD6B9E8),
                    iconColor: const Color(0xFF8B1FA9),
                    onTap: () => context.pushNamed(RouteNames.categoryMedicines, pathParameters: {'category': l.catAntibioticsGrid}),
                  ),
                  _CategoryCard(
                    title: l.catBloodPressure,
                    icon: Icons.medical_services_outlined,
                    bgColor: isDark ? const Color(0xFF352825) : const Color(0xFFDFBDB9),
                    iconColor: isDark ? Colors.white70 : Colors.black87,
                    onTap: () => context.pushNamed(RouteNames.categoryMedicines, pathParameters: {'category': l.catBloodPressure}),
                  ),
                  _CategoryCard(
                    title: l.catSkinCare,
                    icon: Icons.health_and_safety_outlined,
                    bgColor: isDark ? const Color(0xFF352D22) : const Color(0xFFE5C5AB),
                    iconColor: const Color(0xFFB34A29),
                    onTap: () => context.pushNamed(RouteNames.categoryMedicines, pathParameters: {'category': l.catSkinCare}),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Action Button ──
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.text,
    required this.colors,
    required this.isDark,
    required this.onTap,
  });
  final IconData icon;
  final String text;
  final ColorScheme colors;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.cardDark : const Color(0xFFF4F4F6),
      borderRadius: AppShapes.borderRadiusMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppShapes.borderRadiusMd,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: colors.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                text,
                style: AppTypography.titleSmall.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Category Card ──
class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: AppShapes.borderRadiusMd,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppShapes.borderRadiusMd,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: iconColor),
            const SizedBox(height: 10),
            Text(
              title,
              style: AppTypography.titleSmall.copyWith(
                color: iconColor,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
