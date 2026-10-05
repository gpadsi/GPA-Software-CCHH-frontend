import 'package:flutter/material.dart';

import '../design_system/motion.dart';

/// Cambia entre estados de una pantalla (cargando, error, datos) con un
/// fundido, en lugar de reemplazar el contenido de golpe. Sin esto el
/// esqueleto de carga desaparecía y la tabla "aparecía" de un salto — la
/// sensación de que la interfaz se traba.
///
/// El fundido solo se dispara cuando cambia el TIPO del widget hijo (justo
/// lo que pasa entre esqueleto, error y datos); un hijo del mismo tipo se
/// actualiza en sitio sin animar, así que cambiar de página en una tabla no
/// parpadea.
class AppFadeSwitcher extends StatelessWidget {
  const AppFadeSwitcher({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: AppMotion.duration(context, AppMotion.content),
    switchInCurve: AppMotion.curve,
    switchOutCurve: AppMotion.curve,
    transitionBuilder: (child, animation) =>
        FadeTransition(opacity: animation, child: child),
    // `passthrough`: ambos hijos reciben las MISMAS restricciones que el
    // switcher (ancho completo), no unas sueltas que los encogerían.
    layoutBuilder: (current, previous) => Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.topCenter,
      children: [...previous, ?current],
    ),
    child: child,
  );
}
