import 'package:flutter/material.dart';

import '../design_system/colors.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key, this.width, this.height = 16})
    : assert(height > 0);

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Cargando contenido',
    child: ExcludeSemantics(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    ),
  );
}
