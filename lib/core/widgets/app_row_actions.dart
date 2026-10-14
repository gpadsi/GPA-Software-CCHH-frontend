import 'package:flutter/material.dart';

import '../design_system/spacing.dart';

/// Una acción de fila: ícono, tooltip (que también es su nombre accesible) y
/// qué hace al tocarla.
class AppRowAction {
  const AppRowAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
}

/// Íconos de acción al final de una fila de tabla.
///
/// Lo común (ver, editar, eliminar) se arma con el constructor por defecto:
/// solo se dibujan los que tengan callback, así una pantalla que no deja
/// borrar, o una cuenta que no puede editar, no deja huecos ni botones
/// muertos, y [subject] completa el tooltip ("Editar $subject"). Las filas con
/// otras acciones usan [AppRowActions.list].
///
/// Cada ícono es un [_RowAction] y no un `IconButton`: una página de 25 filas
/// lleva hasta 100 de estos botones y el `IconButton` de Material (estilo,
/// estados, tinta, restricciones) era más de la mitad del trabajo de dibujar
/// la tabla (medido en R5: ~130 ms de ~250 ms con la CPU a 4x). Se conservan
/// el tooltip, la semántica de botón, el foco con teclado, el hover y el área
/// táctil de 48 px. La tabla conoce su ancho sin medirlo ([width]).
class AppRowActions extends StatelessWidget {
  const AppRowActions({
    super.key,
    required String this.subject,
    this.onView,
    this.onEdit,
    this.onDelete,
  }) : _list = null;

  const AppRowActions.list(List<AppRowAction> actions, {super.key})
    : _list = actions,
      subject = null,
      onView = null,
      onEdit = null,
      onDelete = null;

  final String? subject;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final List<AppRowAction>? _list;

  /// Las acciones que se dibujan, en orden.
  List<AppRowAction> get actions =>
      _list ??
      [
        if (onView != null)
          AppRowAction(
            icon: Icons.visibility_outlined,
            tooltip: 'Ver $subject',
            onPressed: onView,
          ),
        if (onEdit != null)
          AppRowAction(
            icon: Icons.edit_outlined,
            tooltip: 'Editar $subject',
            onPressed: onEdit,
          ),
        if (onDelete != null)
          AppRowAction(
            icon: Icons.delete_outline,
            tooltip: 'Eliminar $subject',
            onPressed: onDelete,
          ),
      ];

  /// Ancho que ocupan [count] acciones, para que la tabla no tenga que medirlo.
  static double width(int count) => count <= 0
      ? 0
      : count * AppSpacing.touchTarget + (count - 1) * AppSpacing.xs;

  @override
  Widget build(BuildContext context) {
    final items = actions;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (index, action) in items.indexed) ...[
          if (index > 0) const SizedBox(width: AppSpacing.xs),
          _RowAction(action),
        ],
      ],
    );
  }
}

class _RowAction extends StatelessWidget {
  const _RowAction(this.action);

  final AppRowAction action;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Tooltip(
      message: action.tooltip,
      child: Semantics(
        button: true,
        enabled: action.onPressed != null,
        child: InkResponse(
          onTap: action.onPressed,
          customBorder: const CircleBorder(),
          hoverColor: color.withValues(alpha: 0.08),
          focusColor: color.withValues(alpha: 0.1),
          highlightColor: color.withValues(alpha: 0.1),
          splashColor: color.withValues(alpha: 0.1),
          child: SizedBox.square(
            dimension: AppSpacing.touchTarget,
            child: Icon(action.icon, size: 24, color: color),
          ),
        ),
      ),
    );
  }
}
