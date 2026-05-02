import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

/// Request Form screen matching reference design.
class RequestFormScreen extends StatefulWidget {
  const RequestFormScreen({super.key});

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
  DateTime? _prescDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _mfgCtrl.dispose();
    _contactCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _prescDate = picked);
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
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField(
                      controller: _nameCtrl, label: l.medicineNameRequired,
                      hint: l.hintMedicineWithDose,
                      prefixIcon: Icons.medication_outlined,
                      validator: (v) => v == null || v.trim().isEmpty ? l.required : null,
                    ),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    _dropdown(l.category, _category, l.selectCategory,
                        l.formCategories, (v) => setState(() => _category = v),
                        prefixIcon: Icons.category_outlined),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    Row(children: [
                      Expanded(child: AppTextField(
                        controller: _qtyCtrl, label: l.quantityRequired, hint: '5',
                        keyboardType: TextInputType.number,
                        validator: (v) => v == null || v.trim().isEmpty ? l.required : null,
                      )),
                      AppSpacing.gapHLg,
                      Expanded(child: _dropdown(l.unitRequired, _unit, l.unitTablets,
                          l.formUnits, (v) => setState(() => _unit = v))),
                    ]),
                    const SizedBox(height: AppSpacing.formFieldGap),
                    _dateField(l.prescriptionDateRequired, _prescDate, _pickDate),
                    AppSpacing.gapXs,
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(l.prescriptionNote,
                          style: AppTypography.bodySmall.copyWith(color: AppColors.accent)),
                    ),
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

  Widget _dropdown(String label, String? value, String hint, List<String> items,
      ValueChanged<String?> onChanged, {IconData? prefixIcon}) {
    final colors = Theme.of(context).colorScheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AppTypography.titleSmall.copyWith(color: colors.onSurface)),
      AppSpacing.gapSm,
      DropdownButtonFormField<String>(
        initialValue: value, hint: Text(hint),
        icon: Icon(Icons.keyboard_arrow_down_rounded, color: colors.onSurfaceVariant),
        decoration: InputDecoration(prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
        onChanged: onChanged,
      ),
    ]);
  }

  Widget _dateField(String label, DateTime? value, VoidCallback onTap) {
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
            value != null ? '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}' : l.hintDateFormat,
            style: AppTypography.bodyLarge.copyWith(color: value != null ? colors.onSurface : colors.onSurfaceVariant),
          ),
        ),
      ),
    ]);
  }
}
