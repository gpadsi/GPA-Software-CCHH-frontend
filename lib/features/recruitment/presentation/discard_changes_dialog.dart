import 'package:flutter/material.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_overlays.dart';

/// Pregunta si se descartan los cambios sin guardar de una página de
/// Reclutamiento. Devuelve `true` solo si la persona elige descartar.
Future<bool> confirmDiscardChanges(
  BuildContext context, {
  required String message,
}) => showAppDialog<bool>(
  context: context,
  builder: (dialogContext) => AlertDialog(
    title: const Text('¿Descartar cambios?'),
    content: Text(message),
    actions: [
      AppButton(
        label: 'Seguir editando',
        variant: AppButtonVariant.secondary,
        onPressed: () => Navigator.of(dialogContext).pop(false),
      ),
      AppButton(
        label: 'Descartar',
        onPressed: () => Navigator.of(dialogContext).pop(true),
      ),
    ],
  ),
).then((value) => value == true);
