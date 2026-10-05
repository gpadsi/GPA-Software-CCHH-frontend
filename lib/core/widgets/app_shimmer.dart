import 'package:flutter/material.dart';

import '../design_system/motion.dart';

/// Reloj compartido del brillo del esqueleto de carga. Todos los
/// `LoadingSkeleton` dentro de un mismo [AppShimmer] leen la MISMA fase, así
/// el brillo cruza los bloques en sincronía en lugar de cada uno por su
/// cuenta. Sin un [AppShimmer] arriba (o con movimiento reducido) el esqueleto
/// queda estático, como antes.
class AppShimmer extends StatefulWidget {
  const AppShimmer({super.key, required this.child});
  final Widget child;

  /// La fase 0..1 del brillo, o null si no hay movimiento (sin [AppShimmer]
  /// arriba, o movimiento reducido).
  static Animation<double>? maybeOf(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return null;
    return context
        .dependOnInheritedWidgetOfExactType<_ShimmerPhase>()
        ?.notifier;
  }

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.shimmer,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      _ShimmerPhase(notifier: _controller, child: widget.child);
}

class _ShimmerPhase extends InheritedNotifier<AnimationController> {
  const _ShimmerPhase({
    required AnimationController notifier,
    required super.child,
  }) : super(notifier: notifier);
}
