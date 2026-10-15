import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import 'app_shimmer.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key, this.width, this.height = 16})
    : assert(height > 0);

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final phase = AppShimmer.maybeOf(context);
    final base = context.colors.border;
    final radius = BorderRadius.circular(6);
    return Semantics(
      label: 'Cargando contenido',
      child: ExcludeSemantics(
        child: phase == null
            ? Container(
                width: width,
                height: height,
                decoration: BoxDecoration(color: base, borderRadius: radius),
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
                    // El brillo es el mismo borde mezclado hacia la
                    // tarjeta: un destello sutil del propio tema, no un
                    // blanco ajeno.
                    colors: [
                      base,
                      Color.lerp(base, context.colors.surface, 0.6)!,
                      base,
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
