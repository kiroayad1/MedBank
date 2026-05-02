import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';

import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

/// Edit Profile screen matching Stitch design.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController(text: 'Kiro Ayad');
  final _phoneCtrl = TextEditingController(text: '100 123 4567');
  final _emailCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.profileUpdated)),
      );
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
        title: Text(l.editProfile,
            style: AppTypography.appBarBrand.copyWith(color: colors.primary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          // Avatar with camera icon
          Stack(children: [
            Container(
              width: 96, height: 96,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.primary, colors.primary.withValues(alpha: 0.7)],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(child: Text('KA',
                  style: AppTypography.headlineLarge.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700))),
            ),
            Positioned(bottom: 0, right: 0, child: Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle,
                  border: Border.all(color: isDark ? AppColors.cardDark : AppColors.cardLight, width: 2)),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
            )),
          ]),
          AppSpacing.gapXxl,
          // Form
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: AppShapes.borderRadiusLg,
              boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
            ),
            child: Form(key: _formKey, child: Column(children: [
              AppTextField(controller: _nameCtrl, label: l.fullName, hint: l.hintEnterName,
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (v) => v == null || v.trim().isEmpty ? l.required : null),
              const SizedBox(height: AppSpacing.formFieldGap),
              AppTextField(controller: _phoneCtrl, label: l.phoneNumber, hint: '100 123 4567',
                  keyboardType: TextInputType.phone,
                  prefix: Padding(padding: const EdgeInsetsDirectional.only(end: 8),
                      child: Text('+20', style: AppTypography.bodyLarge.copyWith(color: colors.onSurface)))),
              const SizedBox(height: AppSpacing.formFieldGap),
              AppTextField(controller: _emailCtrl, label: l.email, hint: 'example@email.com',
                  prefixIcon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: AppSpacing.formFieldGap),
              AppTextField(controller: _locationCtrl, label: l.location, hint: 'City, Area',
                  prefixIcon: Icons.location_on_outlined),
              const SizedBox(height: AppSpacing.formSectionGap),
              AppButton(label: l.saveChanges, onPressed: _save, isLoading: _isLoading),
            ])),
          ),
        ]),
      ),
    );
  }
}
