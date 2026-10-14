import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/motion.dart';

/// Tinte del fondo detrás de un diálogo o panel: sale de la paleta (texto
/// casi negro con vino), no del negro puro genérico de Material.
final _scrim = AppColors.text.withValues(alpha: 0.5);

/// Abre un diálogo corto (confirmaciones) con la animación de la app:
/// fundido con una escala leve. Es la única forma de abrir un diálogo — así
/// todos aparecen y se van igual, en lugar de cada uno con su propio
/// comportamiento por defecto de Material.
///
/// `barrierDismissible` es false a propósito, igual que antes: un clic
/// accidental fuera no debe descartar algo a medias.
Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) => showGeneralDialog<T>(
  context: context,
  barrierDismissible: false,
  barrierLabel: 'Cerrar',
  barrierColor: _scrim,
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

/// Abre un formulario en un panel lateral: entra desde la derecha en
/// pantallas anchas y desde abajo en móvil. Reemplaza a los formularios en
/// diálogo genérico: `AppFormPanel` mantiene las acciones a la vista y permite
/// elegir la presentación lateral o centrada según la extensión del formulario.
///
/// El widget que devuelve [builder] debe ser un `AppFormPanel`: él mismo se
/// ancla al borde correcto y se desliza con la animación de esta ruta. Aquí
/// solo se oscurece el fondo; antes se deslizaba la capa de pantalla completa
/// (1440 px para un panel de 520) y el panel tardaba en asomar.
Future<T?> showAppPanel<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = false,
}) => showGeneralDialog<T>(
  context: context,
  barrierDismissible: barrierDismissible,
  barrierLabel: 'Cerrar',
  barrierColor: _scrim,
  transitionDuration: AppMotion.duration(context, AppMotion.page),
  pageBuilder: (context, _, _) => builder(context),
);
