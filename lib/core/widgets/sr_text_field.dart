import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class SrTextField extends StatelessWidget {
  const SrTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool autofocus;
  final int maxLines;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          enabled: enabled,
          autofocus: autofocus,
          maxLines: maxLines,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

class SrPasswordField extends StatefulWidget {
  const SrPasswordField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.errorText,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.textInputAction,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  @override
  State<SrPasswordField> createState() => _SrPasswordFieldState();
}

class _SrPasswordFieldState extends State<SrPasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return SrTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint ?? '••••••••',
      errorText: widget.errorText,
      obscureText: !_visible,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.textInputAction,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
      focusNode: widget.focusNode,
      prefixIcon: const Icon(Icons.lock_outline,
          size: 20, color: AppColors.onSurfaceSecondary),
      suffixIcon: IconButton(
        onPressed: () => setState(() => _visible = !_visible),
        icon: Icon(
          _visible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20,
          color: AppColors.onSurfaceSecondary,
        ),
      ),
    );
  }
}
