import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';

import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/network/api_config.dart';
import '../../../core/network/services/auth_service.dart';

/// Edit Profile screen matching Stitch design.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  final _emailCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    _nameCtrl = TextEditingController(text: authState.fullName ?? '');
    _phoneCtrl = TextEditingController(text: authState.phoneNumber ?? '');
    _nameCtrl.addListener(() => setState(() {})); // Rebuild to update initials
  }

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
    
    try {
      if (ApiConfig.useLiveBackend) {
        await AuthService.instance.updateProfile(
          fullName: _nameCtrl.text.trim(),
          phoneNumber: _phoneCtrl.text.trim(),
        );
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }
      
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(context.l10n.profileUpdated)));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
        title: Text(
          l.editProfile,
          style: AppTypography.appBarBrand.copyWith(color: colors.primary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar with camera icon
            Stack(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.primary,
                        colors.primary.withValues(alpha: 0.7),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Builder(
                      builder: (context) {
                        final name = _nameCtrl.text.trim();
                        final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
                        String initials = 'U';
                        if (parts.isNotEmpty) {
                          if (parts.length == 1) {
                            initials = parts[0][0].toUpperCase();
                          } else {
                            initials = '${parts[0][0]}${parts.last[0]}'.toUpperCase();
                          }
                        }
                        return Text(
                          initials,
                          style: AppTypography.headlineLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        );
                      }
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? AppColors.cardDark
                            : AppColors.cardLight,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapXxl,
            // Form
            Container(
              padding: AppSpacing.cardPaddingLarge,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: AppShapes.borderRadiusLg,
                boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      controller: _nameCtrl,
                      label: l.fullName,
                      hint: l.hintEnterName,
                      prefixIcon: Icons.person_outline_rounded,
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? l.required : null,
                    ),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    AppTextField(
                      controller: _phoneCtrl,
                      label: l.phoneNumber,
                      hint: '100 123 4567',
                      keyboardType: TextInputType.phone,
                      prefix: Padding(
                        padding: const EdgeInsetsDirectional.only(end: 8),
                        child: Text(
                          '+20',
                          style: AppTypography.bodyLarge.copyWith(
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    AppTextField(
                      controller: _emailCtrl,
                      label: l.email,
                      hint: 'example@email.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    AppTextField(
                      controller: _locationCtrl,
                      label: l.location,
                      hint: 'City, Area',
                      prefixIcon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: AppSpacing.formSectionGap),
                    AppButton(
                      label: l.saveChanges,
                      onPressed: _save,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
