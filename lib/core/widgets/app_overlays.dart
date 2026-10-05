import 'package:flutter/material.dart';

import '../design_system/breakpoints.dart';
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
/// diálogo centrado — un formulario largo necesita altura completa y su
/// botón de guardar siempre a la vista, no una ventana flotante con scroll.
///
/// El widget que devuelve [builder] debe ser un `AppFormPanel` (él mismo se
/// ancla al borde correcto).
Future<T?> showAppPanel<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) => showGeneralDialog<T>(
  context: context,
  barrierDismissible: false,
  barrierLabel: 'Cerrar',
  barrierColor: _scrim,
  transitionDuration: AppMotion.duration(context, AppMotion.page),
  pageBuilder: (context, _, _) => builder(context),
  transitionBuilder: (context, animation, _, child) {
    final wide = MediaQuery.sizeOf(context).width >= AppBreakpoints.mobile;
    return SlideTransition(
      position: animation
          .drive(CurveTween(curve: AppMotion.curve))
          .drive(
            Tween<Offset>(
              begin: wide ? const Offset(1, 0) : const Offset(0, 1),
              end: Offset.zero,
            ),
          ),
      child: child,
    );
  },
);
