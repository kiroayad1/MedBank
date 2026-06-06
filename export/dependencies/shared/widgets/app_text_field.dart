import 'package:flutter/material.dart';

import '../../core/theme/theme.dart';

/// Reusable styled text field used across all forms.
///
/// Wraps Material's [TextFormField] with the app's design tokens.
/// Supports label, hint, prefix/suffix icons, obscure toggle, and validation.
///
/// **RTL handling**: When [keyboardType] is phone or number, the input text
/// direction is forced to LTR so numbers display correctly even in Arabic mode.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.showObscureToggle = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.maxLines = 1,
    this.autofocus = false,
    this.focusNode,
    this.prefix,
    this.textDirection,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final bool showObscureToggle;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;
  final int maxLines;
  final bool autofocus;
  final FocusNode? focusNode;
  final Widget? prefix;
  /// Force a specific text direction. If null, auto-detects based on keyboardType.
  final TextDirection? textDirection;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  /// Determines the text direction for the input field.
  /// Forces LTR for phone numbers, numeric, email, URL, and password fields.
  TextDirection _resolveTextDirection() {
    if (widget.textDirection != null) return widget.textDirection!;
    final kt = widget.keyboardType;
    if (kt == TextInputType.phone ||
        kt == TextInputType.number ||
        kt == TextInputType.emailAddress ||
        kt == TextInputType.url ||
        kt == const TextInputType.numberWithOptions(decimal: true) ||
        kt == const TextInputType.numberWithOptions(signed: true) ||
        widget.obscureText) {
      return TextDirection.ltr;
    }
    return Directionality.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textDir = _resolveTextDirection();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.titleSmall.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          AppSpacing.gapSm,
        ],
        _buildField(theme, textDir),
      ],
    );
  }

  Widget _buildField(ThemeData theme, TextDirection textDir) {
    final isLtrForced = textDir == TextDirection.ltr &&
        Directionality.of(context) == TextDirection.rtl;

    final field = TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      autofocus: widget.autofocus,
      focusNode: widget.focusNode,
      textDirection: textDir,
      textAlign: isLtrForced ? TextAlign.left : TextAlign.start,
      style: AppTypography.bodyLarge.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintTextDirection: textDir,
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, size: AppSpacing.iconMd)
            : null,
        prefix: widget.prefix,
        suffixIcon: _buildSuffix(),
      ),
    );

    // When text direction is forced LTR in an RTL context, wrap the entire
    // field in Directionality so prefix widgets, icons, and hint all
    // render left-to-right — matching native phone/number UX.
    if (isLtrForced) {
      return Directionality(
        textDirection: TextDirection.ltr,
        child: field,
      );
    }
    return field;
  }

  Widget? _buildSuffix() {
    if (widget.showObscureToggle) {
      return IconButton(
        icon: Icon(
          _isObscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: AppSpacing.iconMd,
        ),
        onPressed: () => setState(() => _isObscured = !_isObscured),
      );
    }
    return widget.suffixIcon;
  }
}
