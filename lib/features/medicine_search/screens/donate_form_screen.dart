import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

/// Donate Form screen matching reference design.
class DonateFormScreen extends StatefulWidget {
  final String? imagePath;
  const DonateFormScreen({super.key, this.imagePath});

  @override
  State<DonateFormScreen> createState() => _DonateFormScreenState();
}

class _DonateFormScreenState extends State<DonateFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _mfgCtrl = TextEditingController();
  final _locCtrl = TextEditingController();
  String? _category, _unit, _condition;
  DateTime? _expiry;
  bool _isLoading = false;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.imagePath;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _mfgCtrl.dispose();
    _locCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() => _imagePath = image.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error picking image')),
        );
      }
    }
  }

  void _showImageSourceSheet() {
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
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 90)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _expiry = picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (mounted) {
      context.pushReplacementNamed(RouteNames.success,
          queryParameters: {'type': 'donation'});
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
        title: Text(l.medicineDetails,
            style: AppTypography.appBarBrand.copyWith(color: colors.primary)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? colors.primary.withValues(alpha: 0.08) : AppColors.primarySurface,
                borderRadius: AppShapes.borderRadiusMd,
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.info_outline_rounded, color: colors.primary, size: 20),
                AppSpacing.gapHSm,
                Expanded(child: Text(
                  l.donateFormInfo,
                  style: AppTypography.bodySmall.copyWith(color: colors.onSurfaceVariant),
                )),
              ]),
            ),

            // Image Picker Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: InkWell(
                onTap: _showImageSourceSheet,
                borderRadius: AppShapes.borderRadiusLg,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: AppShapes.borderRadiusLg,
                    border: Border.all(
                      color: colors.primary.withValues(alpha: 0.2),
                      style: _imagePath == null ? BorderStyle.solid : BorderStyle.none,
                    ),
                  ),
                  child: _imagePath != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: AppShapes.borderRadiusLg,
                              child: Image.file(File(_imagePath!), fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: 8, right: 8,
                              child: CircleAvatar(
                                backgroundColor: Colors.black54,
                                radius: 18,
                                child: IconButton(
                                  icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                                  onPressed: _showImageSourceSheet,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo_outlined, size: 40, color: colors.primary),
                            AppSpacing.gapSm,
                            Text(l.withMedicineImage, style: AppTypography.titleSmall.copyWith(color: colors.primary)),
                          ],
                        ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: AppShapes.borderRadiusLg,
                  boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    AppTextField(controller: _nameCtrl, label: l.medicineNameRequired,
                      hint: l.hintMedicineExample,
                      validator: (v) => v == null || v.trim().isEmpty ? l.required : null),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    _dropdown(l.categoryRequired, _category, l.selectCategory,
                      l.formCategories, (v) => setState(() => _category = v)),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    Row(children: [
                      Expanded(child: AppTextField(controller: _qtyCtrl, label: l.quantityRequired,
                        hint: '5', keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.trim().isEmpty ? l.required : null)),
                      AppSpacing.gapHLg,
                      Expanded(child: _dropdown(l.unitRequired, _unit, l.unitTablets,
                        l.formUnits, (v) => setState(() => _unit = v))),
                    ]),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    _dateField(l.expirationDateRequired, _expiry, _pickDate),
                    AppSpacing.gapXs,
                    Text(l.expiryNote,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.accent)),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    AppTextField(controller: _mfgCtrl, label: l.manufacturerOptional,
                      hint: l.hintManufacturer),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    _dropdown(l.conditionRequired, _condition, l.selectCondition,
                      l.formConditions, (v) => setState(() => _condition = v)),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    AppTextField(controller: _locCtrl, label: l.locationRequired,
                      hint: l.hintCityArea, prefixIcon: Icons.location_on_outlined,
                      validator: (v) => v == null || v.trim().isEmpty ? l.required : null),
                    const SizedBox(height: AppSpacing.formSectionGap),
                    AppButton(label: l.register, onPressed: _submit, isLoading: _isLoading),
                  ]),
                ),
              ),
            ),
            AppSpacing.gapSection,
          ],
        ),
      ),
    );
  }

  Widget _dropdown(String label, String? val, String hint, List<String> items,
      ValueChanged<String?> onChanged) {
    final colors = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.titleSmall.copyWith(color: colors.onSurface)),
      AppSpacing.gapSm,
      DropdownButtonFormField<String>(
        value: val, hint: Text(hint),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.onSurfaceVariant),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        onChanged: onChanged,
      ),
    ]);
  }

  Widget _dateField(String label, DateTime? val, VoidCallback onTap) {
    final colors = Theme.of(context).colorScheme;
    final l = context.l10n;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.titleSmall.copyWith(color: colors.onSurface)),
      AppSpacing.gapSm,
      InkWell(
        onTap: onTap, borderRadius: AppShapes.borderRadiusMd,
        child: InputDecorator(
          decoration: const InputDecoration(prefixIcon: Icon(Icons.calendar_today_outlined, size: 18)),
          child: Text(
            val != null ? '${val.day.toString().padLeft(2, '0')}/${val.month.toString().padLeft(2, '0')}/${val.year}' : l.hintDateFormat,
            style: AppTypography.bodyLarge.copyWith(color: val != null ? colors.onSurface : colors.onSurfaceVariant),
          ),
        ),
      ),
    ]);
  }
}
