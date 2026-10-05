import 'package:flutter/material.dart';

import '../design_system/spacing.dart';

/// Íconos de acción al final de una fila de tabla (ver, editar, eliminar).
/// Solo se dibujan los que tengan callback: así una pantalla que no deja
/// borrar, o una cuenta que no puede editar, no deja huecos ni botones
/// muertos. [subject] completa el tooltip ("Editar $subject").
class AppRowActions extends StatelessWidget {
  const AppRowActions({
    super.key,
    required this.subject,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  final String subject;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[
      if (onView != null)
        IconButton(
          tooltip: 'Ver $subject',
          onPressed: onView,
          icon: const Icon(Icons.visibility_outlined),
        ),
      if (onEdit != null)
        IconButton(
          tooltip: 'Editar $subject',
          onPressed: onEdit,
          icon: const Icon(Icons.edit_outlined),
        ),
      if (onDelete != null)
        IconButton(
          tooltip: 'Eliminar $subject',
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline),
        ),
    ];
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (index, button) in buttons.indexed) ...[
          if (index > 0) const SizedBox(width: AppSpacing.xs),
          button,
        ],
      ],
    );
  }
}
