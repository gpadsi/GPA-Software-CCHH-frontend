import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.color,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// Por defecto, la superficie y el borde del tema activo.
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(context.shape.card);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: context.shape.cardShadow,
      ),
      child: Material(
        color: color ?? context.colors.surface,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: borderColor ?? context.colors.border),
        ),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
