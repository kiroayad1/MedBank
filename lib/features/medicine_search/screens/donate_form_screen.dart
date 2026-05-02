import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/theme.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

/// Donate Form screen matching reference design.
class DonateFormScreen extends StatefulWidget {
  const DonateFormScreen({super.key});

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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _mfgCtrl.dispose();
    _locCtrl.dispose();
    super.dispose();
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
        initialValue: val, hint: Text(hint),
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
