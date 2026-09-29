import 'package:flutter/material.dart';

import '../design_system/colors.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, this.name = 'Vista previa', this.size = 40})
    : assert(size > 0);

  final String name;
  final double size;

  String get _initials {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.first.isEmpty) return '?';
    return [
      words.first,
      if (words.length > 1) words.last,
    ].map((word) => word.characters.first.toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    label: name.trim().isEmpty ? 'Perfil' : name,
    image: true,
    child: ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.primarySurface,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(size * .18),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _initials,
              style: Theme.of(context).textTheme.labelLarge
                  ?.copyWith(color: AppColors.primary),
            ),
          ),
        ),
      ),
    ),
  );
}
