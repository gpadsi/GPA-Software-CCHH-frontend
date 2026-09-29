import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'colors.dart';

abstract final class AppMotion {
  static const curve = Curves.easeOutCubic;
  static const page = Duration(milliseconds: 300);
  static const interaction = Duration(milliseconds: 140);
  static const content = Duration(milliseconds: 160);
  static const stagger = Duration(milliseconds: 30);
  static Duration duration(BuildContext context, Duration value) =>
      MediaQuery.disableAnimationsOf(context) ? Duration.zero : value;
}

/// Aparición de contenido nuevo (tarjetas, listas): fade + slide sutil de
/// 10px, escalonado por [index] — ver sección 3 del plan de frontend. Se
/// omite por completo con movimiento reducido en vez de pasar duraciones en
/// cero: `flutter_animate` no tolera bien un `AnimationController` de
/// duración cero, a diferencia de los widgets `Animated*` nativos ya usados
/// en el resto de la app.
extension AppEntranceMotion on Widget {
  Widget appEnter(BuildContext context, {int index = 0}) {
    if (MediaQuery.disableAnimationsOf(context)) return this;
    return animate(delay: AppMotion.stagger * index)
        .fadeIn(duration: AppMotion.content, curve: AppMotion.curve)
        .moveY(
          begin: 10,
          end: 0,
          duration: AppMotion.content,
          curve: AppMotion.curve,
        );
  }
}

/// Transición entre páginas de nivel superior (destinos de la barra
/// lateral), como Navigator.push directo (fuera de go_router).
///
/// A propósito NO es un simple FadeTransition: la página saliente y la
/// entrante casi siempre tienen contenidos y alturas distintas, y un fade
/// cruzado ingenuo las deja superpuestas — el texto de ambas se ve al
/// mismo tiempo, mezclado, durante toda la transición. Se ve exactamente
/// como "se queda pegada la pantalla anterior". FadeThroughTransition (del
/// paquete oficial `animations` de Flutter) resuelve esto pintando un fondo
/// sólido: la saliente se desvanece primero, LUEGO aparece la entrante — es
/// el patrón que Material Design recomienda para navegar entre secciones
/// sin relación visual directa (justo este caso). Ver también
/// app_router.dart, donde go_router usa el mismo patrón.
class AppPageTransitionsBuilder extends PageTransitionsBuilder {
  const AppPageTransitionsBuilder();
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.disableAnimationsOf(context)) return child;
    return FadeThroughTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      fillColor: AppColors.background,
      child: child,
    );
  }
}
