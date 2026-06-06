import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

/// Request Form screen matching reference design.
class RequestFormScreen extends StatefulWidget {
  final String? imagePath;
  final String? initialName;
  final String? initialCategory;
  final String? initialUnit;

  const RequestFormScreen({
    super.key,
    this.imagePath,
    this.initialName,
    this.initialCategory,
    this.initialUnit,
  });

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _mfgCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();

  String? _category;
  String? _unit;
  bool _isLoading = false;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _imagePath = widget.imagePath;
    _nameCtrl.text = widget.initialName ?? '';
    _category = widget.initialCategory;
    _unit = widget.initialUnit;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _mfgCtrl.dispose();
    _contactCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (mounted) {
      context.pushReplacementNamed(RouteNames.success,
          queryParameters: {'type': 'request'});
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
        title: Text(l.requestMedicine,
            style: AppTypography.appBarBrand.copyWith(color: colors.primary)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Info banner
            Container(
              margin: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? colors.primary.withValues(alpha: 0.08) : AppColors.primarySurface,
                borderRadius: AppShapes.borderRadiusMd,
              ),
              child: Text(
                l.requestFormInfo,
                style: AppTypography.bodySmall.copyWith(color: colors.onSurfaceVariant),
              ),
            ),
            
            if (_imagePath != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: ClipRRect(
                  borderRadius: AppShapes.borderRadiusMd,
                  child: Stack(
                    children: [
                      Image.file(
                        File(_imagePath!),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 8, right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => setState(() => _imagePath = null),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Automatically fill name and make read-only if provided
                    if (widget.initialName == null)
                      AppTextField(
                        controller: _nameCtrl, label: l.medicineNameRequired,
                        hint: l.hintMedicineWithDose,
                        prefixIcon: Icons.medication_outlined,
                        validator: (v) => v == null || v.trim().isEmpty ? l.required : null,
                      )
                    else
                      _readonlyField(l.medicineName, _nameCtrl.text, Icons.medication_outlined),
                    
                    const SizedBox(height: AppSpacing.formFieldGap),
                    
                    if (widget.initialCategory == null)
                      _dropdown(l.category, _category, l.selectCategory,
                          l.formCategories, (v) => setState(() => _category = v),
                          prefixIcon: Icons.category_outlined)
                    else
                      _readonlyField(l.category, _category!, Icons.category_outlined),

                    const SizedBox(height: AppSpacing.formFieldGap),
                    Row(children: [
                      Expanded(child: AppTextField(
                        controller: _qtyCtrl, label: l.quantityRequired, hint: '1',
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.trim().isEmpty ? l.required : null,
                      )),
                      AppSpacing.gapHLg,
                      Expanded(
                        child: widget.initialUnit == null 
                          ? _dropdown(l.unitRequired, _unit, l.unitTablets,
                              l.formUnits, (v) => setState(() => _unit = v))
                          : _readonlyField(l.unitRequired, _unit!, null)
                      ),
                    ]),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    AppTextField(
                      controller: _mfgCtrl, label: l.manufacturerOptional,
                      hint: l.hintSpecificBrand,
                      prefixIcon: Icons.factory_outlined,
                    ),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    AppTextField(
                      controller: _contactCtrl, label: l.contactRequired,
                      hint: l.hintPhoneIntl,
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v == null || v.trim().isEmpty ? l.required : null,
                    ),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    AppTextField(
                      controller: _locationCtrl, label: l.deliveryRequired,
                      hint: l.hintFullAddress,
                      prefixIcon: Icons.location_on_outlined,
                      validator: (v) => v == null || v.trim().isEmpty ? l.required : null,
                    ),
                    const SizedBox(height: AppSpacing.formSectionGap),
                    AppButton(
                      label: l.register, icon: Icons.check_circle_outline,
                      onPressed: _submit, isLoading: _isLoading,
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.gapSection,
          ],
        ),
      ),
    );
  }

  Widget _readonlyField(String label, String value, IconData? icon) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.titleSmall.copyWith(color: colors.onSurface)),
        AppSpacing.gapSm,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withAlpha(77), // ~0.3 opacity
            borderRadius: AppShapes.borderRadiusMd,
            border: Border.all(color: colors.outlineVariant.withAlpha(128)), // ~0.5 opacity
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: colors.onSurfaceVariant),
                const SizedBox(width: 12),
              ],
              Text(value, style: AppTypography.bodyLarge.copyWith(color: colors.onSurface)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dropdown(String label, String? value, String hint, List<String> items,
      ValueChanged<String?> onChanged, {IconData? prefixIcon}) {
    final colors = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.titleSmall.copyWith(color: colors.onSurface)),
      AppSpacing.gapSm,
      DropdownButtonFormField<String>(
        value: value, hint: Text(hint),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.onSurfaceVariant),
        decoration: InputDecoration(prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        onChanged: onChanged,
      ),
    ]);
  }
}
