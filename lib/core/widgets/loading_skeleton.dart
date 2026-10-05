import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import 'app_shimmer.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key, this.width, this.height = 16})
    : assert(height > 0);

  final double? width;
  final double height;

  // El brillo es el mismo borde mezclado hacia la tarjeta: un destello
  // sutil de la propia paleta, no un blanco ajeno.
  static final _highlight = Color.lerp(
    AppColors.border,
    AppColors.surface,
    0.6,
  )!;

  @override
  Widget build(BuildContext context) {
    final phase = AppShimmer.maybeOf(context);
    final radius = BorderRadius.circular(6);
    return Semantics(
      label: 'Cargando contenido',
      child: ExcludeSemantics(
        child: phase == null
            ? Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: radius,
                ),
              )
            // Sin AnimatedBuilder: AppShimmer.maybeOf ya registra a este
            // widget como dependiente del reloj, así que se reconstruye solo
            // en cada cuadro.
            : Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  borderRadius: radius,
                  gradient: LinearGradient(
                    // El destello viaja de izquierda a derecha y sale por el
                    // otro lado antes de repetirse.
                    begin: Alignment(-2 + 4 * phase.value, 0),
                    end: Alignment(-1 + 4 * phase.value, 0),
                    colors: [AppColors.border, _highlight, AppColors.border],
                  ),
                ),
              ),
      ),
    );
  }
}
