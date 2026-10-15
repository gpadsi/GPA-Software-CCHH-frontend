import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/spacing.dart';
import 'app_button.dart';
import 'app_dialog.dart';
import 'confirm_dialog.dart';

export 'app_dialog.dart' show AppDialogSize;

/// Formulario en ventana centrada: título, cuerpo desplazable y acciones
/// fijas. Es la única forma de capturar o editar un registro fuera de las
/// páginas de trabajo (Requisición, Descriptivo): todas las altas y
/// ediciones se ven y se comportan igual. Se abre con `showAppDialog`.
///
/// Los formularios solo aportan su cuerpo y qué hacer al guardar; este widget
/// pone el marco, el estado de carga, el mensaje de error y la pregunta de
/// descartar cambios al cerrar.
class AppFormDialog extends StatelessWidget {
  const AppFormDialog({
    super.key,
    required this.title,
    required this.child,
    required this.onSave,
    this.subtitle,
    this.busy = false,
    this.error,
    this.saveLabel = 'Guardar',
    this.canSave = true,
    this.size = AppDialogSize.medium,
    this.minBodyHeight,
    this.dirty,
    this.discardMessage = 'Lo que capturaste en este formulario se perderá.',
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback onSave;

  /// Guardando: bloquea cerrar y muestra el progreso en el botón.
  final bool busy;
  final String? error;
  final String saveLabel;

  /// false mientras el cuerpo todavía no puede guardarse (ej. catálogos sin
  /// cargar).
  final bool canSave;
  final AppDialogSize size;

  /// Ver `AppDialog.minBodyHeight`.
  final double? minBodyHeight;

  /// ¿Hay algo capturado sin guardar? Con true, cerrar de cualquier forma (X,
  /// Cancelar, Escape o clic fuera) pregunta antes de descartar; con false
  /// cierra directo. null: el formulario aún no lo sabe decir, y entonces
  /// Escape y el clic fuera no cierran (solo la X y Cancelar), para no perder
  /// lo capturado por un clic accidental.
  final bool? dirty;
  final String discardMessage;

  void _close(BuildContext context) {
    final navigator = Navigator.of(context);
    // Sin saber si hay cambios, la X y Cancelar cierran sin preguntar (como
    // siempre); con `dirty` pasan por el PopScope de abajo.
    dirty == null ? navigator.pop() : navigator.maybePop();
  }

  Future<void> _confirmDiscard(BuildContext context) async {
    final discard = await confirmDiscardChanges(
      context,
      message: discardMessage,
    );
    if (discard && context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !busy && dirty == false,
    onPopInvokedWithResult: (didPop, _) {
      if (didPop || busy || dirty != true) return;
      _confirmDiscard(context);
    },
    child: AppDialog(
      title: title,
      subtitle: subtitle,
      size: size,
      minBodyHeight: minBodyHeight,
      error: error,
      onClose: busy ? null : () => _close(context),
      actions: [
        AppButton(
          label: 'Cancelar',
          variant: AppButtonVariant.secondary,
          onPressed: busy ? null : () => _close(context),
        ),
        AppButton(
          label: saveLabel,
          isLoading: busy,
          onPressed: canSave ? onSave : null,
        ),
      ],
      child: child,
    ),
  );
}

/// Un grupo de campos dentro de un formulario: título, nota opcional y los
/// campos, siempre con la misma separación. A partir del segundo grupo lo
/// separa una línea del anterior. Sin [title] (formularios de un solo grupo)
/// solo ordena los campos.
class AppFormSection extends StatelessWidget {
  const AppFormSection({
    super.key,
    required this.children,
    this.title,
    this.description,
    this.first = false,
  });

  final String? title;
  final String? description;
  final List<Widget> children;

  /// El primer grupo del formulario no lleva línea arriba.
  final bool first;

  @override
  Widget build(BuildContext context) {
    final type = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!first) ...[
          const SizedBox(height: AppSpacing.lg),
          Divider(height: 1, color: context.colors.border),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (title != null) ...[
          Semantics(
            header: true,
            child: Text(
              title!,
              style: type.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              description!,
              style: type.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
        ],
        for (final (index, child) in children.indexed) ...[
          if (index > 0) const SizedBox(height: 20),
          child,
        ],
      ],
    );
  }
}

/// Para el State de un formulario en ventana: le dice a `AppFormDialog.dirty`
/// si hay algo sin guardar. El State compara lo capturado con lo que se abrió
/// en [hasChanges] (y lo pasa como `dirty` en su `build`) y registra sus
/// campos de texto con [watchChanges]. Al escribir solo se redibuja cuando la
/// respuesta cambia, no con cada tecla; los cambios que ya pasan por
/// `setState` (casillas, listas, fechas) se ven en el siguiente `build`.
mixin FormChangeTracking<T extends StatefulWidget> on State<T> {
  bool _changed = false;

  /// ¿Lo capturado difiere de lo que se abrió?
  bool get hasChanges;

  void watchChanges(Iterable<Listenable> fields) {
    for (final field in fields) {
      field.addListener(_onFieldChanged);
    }
  }

  void _onFieldChanged() {
    if (!mounted) return;
    final changed = hasChanges;
    if (changed != _changed) setState(() => _changed = changed);
  }
}

/// ¿Cambió una fecha respecto a la que se abrió? Compara solo el día: la
/// fecha de hoy que se propone al abrir lleva la hora en que se abrió.
bool dateChanged(DateTime? current, DateTime? initial) =>
    current == null || initial == null
    ? current != initial
    : !DateUtils.isSameDay(current, initial);
