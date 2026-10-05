import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design_system/colors.dart';
import '../design_system/motion.dart';
import '../design_system/spacing.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.onChanged,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.autofillHints,
    this.textInputAction,
    this.onFieldSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;

  /// Se ve y se puede seleccionar el texto, pero no se edita (a diferencia de
  /// `enabled: false`, que lo atenúa como si no estuviera disponible).
  final bool readOnly;

  /// Varias líneas: `maxLines: null, minLines: 3` crece con el contenido.
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _focus = FocusNode();
  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  void _onFocus() => setState(() {});
  @override
  void dispose() {
    _focus.removeListener(_onFocus);
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: AppMotion.duration(context, AppMotion.interaction),
    curve: AppMotion.curve,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppSpacing.controlRadius),
      boxShadow: [
        BoxShadow(
          color: _focus.hasFocus
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.transparent,
          spreadRadius: 3,
        ),
      ],
    ),
    child: TextFormField(
      focusNode: _focus,
      controller: widget.controller,
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      keyboardType:
          widget.keyboardType ??
          (widget.maxLines == 1 ? null : TextInputType.multiline),
      inputFormatters: widget.inputFormatters,
      enableSuggestions: !widget.obscureText,
      autocorrect: false,
      validator: widget.validator,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon == null
            ? null
            : Icon(widget.prefixIcon, size: 20),
        suffixIcon: widget.suffixIcon,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
      ),
    ),
  );
}
