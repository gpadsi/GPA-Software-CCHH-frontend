import 'dart:async';

import 'package:flutter/material.dart';

import '../design_system/colors.dart';

/// Selector que busca en el servidor mientras se escribe, para elegir uno
/// entre cientos de registros (personas, posiciones) donde un menú plano con
/// todo sería lento de abrir y de recorrer. Espera [debounce] sin teclear antes
/// de consultar, no consulta con menos de [minChars] letras y descarta las
/// respuestas de búsquedas que ya no son la última.
///
/// [onChanged] avisa el registro elegido, o null cuando el texto ya no
/// corresponde a él (se siguió escribiendo).
class SearchPickerField<T extends Object> extends StatefulWidget {
  const SearchPickerField({
    super.key,
    required this.label,
    required this.search,
    required this.labelOf,
    required this.onChanged,
    this.hint,
    this.detailOf,
    this.errorText,
    this.enabled = true,
    this.initialText,
    this.debounce = const Duration(milliseconds: 300),
    this.minChars = 2,
  });

  final String label;
  final String? hint;
  final Future<List<T>> Function(String text) search;

  /// El texto con que se muestra cada registro (y se queda en el campo al
  /// elegirlo).
  final String Function(T item) labelOf;

  /// Una segunda línea que ayuda a distinguir homónimos (opcional).
  final String? Function(T item)? detailOf;
  final ValueChanged<T?> onChanged;
  final String? errorText;
  final bool enabled;

  /// Texto inicial del campo (ej. al reabrir algo ya elegido).
  final String? initialText;
  final Duration debounce;
  final int minChars;

  @override
  State<SearchPickerField<T>> createState() => _SearchPickerFieldState<T>();
}

class _SearchPickerFieldState<T extends Object>
    extends State<SearchPickerField<T>> {
  int _search = 0;
  T? _selected;

  Future<Iterable<T>> _options(TextEditingValue value) async {
    final text = value.text.trim();
    final id = ++_search;
    final selected = _selected;
    if (text.length < widget.minChars ||
        (selected != null && text == widget.labelOf(selected))) {
      return const [];
    }
    await Future<void>.delayed(widget.debounce);
    if (!mounted || id != _search) return const [];
    try {
      final result = await widget.search(text);
      return !mounted || id != _search ? const [] : result;
    } on Object {
      return const [];
    }
  }

  @override
  Widget build(BuildContext context) => RawAutocomplete<T>(
    displayStringForOption: widget.labelOf,
    initialValue: widget.initialText == null
        ? null
        : TextEditingValue(text: widget.initialText!),
    optionsBuilder: _options,
    onSelected: (item) {
      _selected = item;
      widget.onChanged(item);
    },
    fieldViewBuilder: (context, controller, focusNode, onSubmit) =>
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          enabled: widget.enabled,
          decoration: InputDecoration(
            labelText: widget.label,
            hintText: widget.hint,
            errorText: widget.errorText,
            suffixIcon: const Icon(Icons.search),
          ),
          onChanged: (text) {
            final selected = _selected;
            if (selected != null && text != widget.labelOf(selected)) {
              _selected = null;
              widget.onChanged(null);
            }
          },
        ),
    optionsViewBuilder: (context, onSelected, options) => Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4,
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 280, maxWidth: 480),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final item = options.elementAt(index);
              final detail = widget.detailOf?.call(item);
              return ListTile(
                title: Text(widget.labelOf(item)),
                subtitle: detail == null || detail.isEmpty
                    ? null
                    : Text(detail),
                onTap: () => onSelected(item),
              );
            },
          ),
        ),
      ),
    ),
  );
}
