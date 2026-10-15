import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/motion.dart';

/// Tinte del fondo detrás de una ventana: sale del texto del tema activo, no
/// del negro puro genérico de Material.
Color _scrim(BuildContext context) =>
    context.colors.text.withValues(alpha: 0.5);

/// Abre una ventana de la app (formulario, confirmación, Apariencia) con la
/// animación de la app: fundido con una escala leve. Es la única forma de
/// abrir una — así todas aparecen, se van y se cierran igual.
///
/// El clic fuera y Escape equivalen a Cancelar: cada ventana decide con su
/// `PopScope` si cierra directo, si primero pregunta por descartar lo
/// capturado (`AppFormDialog.dirty`) o si no cierra (mientras guarda).
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) => showGeneralDialog<T>(
  context: context,
  barrierDismissible: true,
  barrierLabel: 'Cerrar',
  barrierColor: _scrim(context),
  transitionDuration: AppMotion.duration(context, AppMotion.dialog),
  pageBuilder: (context, _, _) => builder(context),
  transitionBuilder: (context, animation, _, child) {
    final curved = animation.drive(CurveTween(curve: AppMotion.curve));
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: curved.drive(Tween<double>(begin: 0.96, end: 1)),
        child: child,
      ),
    );
  },
);
