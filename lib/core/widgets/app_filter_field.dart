import 'package:flutter/material.dart';

import '../design_system/spacing.dart';

/// Filtro desplegable de una tabla ("Estado", "Tipo"): una opción por valor y
/// «Todos» para quitarlo. Va junto a la barra de búsqueda.
class AppFilterField<T extends Object> extends StatelessWidget {
  const AppFilterField({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.allLabel = 'Todos',
  });

  final String label;

  /// El valor aplicado; null = sin filtro.
  final T? value;
  final List<({T value, String label})> options;
  final ValueChanged<T?> onChanged;
  final String allLabel;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 220,
    child: DropdownButtonFormField<T?>(
      // La clave sigue al valor aplicado: si cambia desde fuera (ej. limpiar
      // filtros) el campo se reconstruye con él.
      key: ValueKey('$label:$value'),
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: label,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
      ),
      items: [
        DropdownMenuItem<T?>(value: null, child: Text(allLabel)),
        for (final option in options)
          DropdownMenuItem<T?>(
            value: option.value,
            child: Text(
              option.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: onChanged,
    ),
  );
}
