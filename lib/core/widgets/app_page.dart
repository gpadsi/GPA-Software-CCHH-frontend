import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design_system/colors.dart';
import '../design_system/motion.dart';
import '../design_system/spacing.dart';
import 'app_fade_switcher.dart';

/// La página de todas las secciones: ruta del módulo arriba, título,
/// descripción, acciones a la derecha del título y las pestañas del módulo
/// debajo. Es la composición que estrenó Reclutamiento; antes el resto de los
/// módulos tenía otra (pestañas arriba del título y botones debajo).
class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.section,
    required this.title,
    required this.description,
    required this.child,
    this.actions = const [],
    this.tabs,
  });

  /// El módulo al que pertenece (ej. «Reclutamiento», «Organización»): se
  /// muestra como ruta arriba del título.
  final String section;
  final String title;
  final String description;
  final Widget child;
  final List<Widget> actions;

  /// Pestañas del módulo, debajo del encabezado (ver [AppRouteTabs]).
  final Widget? tabs;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final type = Theme.of(context).textTheme;
      final compact = constraints.maxWidth < 760;
      final heading = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CAPITAL HUMANO / ${section.toUpperCase()}',
            style: type.labelSmall?.copyWith(
              color: context.colors.textSecondary,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Semantics(
            header: true,
            child: Text(
              title,
              style: type.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.6,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: type.bodyMedium?.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      );
      final buttons = Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: actions,
      );
      return SingleChildScrollView(
        padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.xl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.contentMaxWidth,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (compact || actions.length > 2)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heading,
                      if (actions.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        buttons,
                      ],
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(child: heading),
                      const SizedBox(width: AppSpacing.lg),
                      Flexible(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: buttons,
                        ),
                      ),
                    ],
                  ),
                if (tabs != null) ...[
                  const SizedBox(height: AppSpacing.lg),
                  tabs!,
                ],
                const SizedBox(height: AppSpacing.lg),
                // Fundido entre cargando / error / datos (ver AppFadeSwitcher).
                AppFadeSwitcher(child: child),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Pestañas de las páginas de un módulo: cada una lleva a su ruta.
class AppRouteTabs extends StatelessWidget {
  const AppRouteTabs({
    super.key,
    required this.current,
    required this.destinations,
  });
  final String current;
  final List<({String label, String path})> destinations;

  @override
  Widget build(BuildContext context) => AppSectionTabs(
    // Alineadas con el título de la página.
    padding: const EdgeInsets.fromLTRB(0, 0, AppSpacing.md, 10),
    labels: [for (final item in destinations) item.label],
    selected: destinations.indexWhere((item) => item.path == current),
    onSelected: (index) {
      final path = destinations[index].path;
      if (path != current) context.go(path);
    },
  );
}

/// Pestañas de sección: chips sin borde sobre una línea. Las usan los
/// módulos ([AppRouteTabs]), las fichas y las páginas de trabajo.
class AppSectionTabs extends StatelessWidget {
  const AppSectionTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.md,
      0,
      AppSpacing.md,
      10,
    ),
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: context.colors.border)),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding,
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChoiceChip(
                label: Text(labels[i]),
                showCheckmark: false,
                selected: i == selected,
                onSelected: (_) => onSelected(i),
                backgroundColor: Colors.transparent,
                selectedColor: context.colors.primarySurface,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: i == selected
                      ? context.colors.onPrimarySurface
                      : context.colors.textSecondary,
                  fontWeight: i == selected ? FontWeight.w700 : FontWeight.w500,
                ),
                chipAnimationStyle: MediaQuery.disableAnimationsOf(context)
                    ? ChipAnimationStyle(
                        enableAnimation: AnimationStyle.noAnimation,
                        selectAnimation: AnimationStyle.noAnimation,
                        avatarDrawerAnimation: AnimationStyle.noAnimation,
                        deleteDrawerAnimation: AnimationStyle.noAnimation,
                      )
                    : ChipAnimationStyle(
                        selectAnimation: AnimationStyle(
                          duration: AppMotion.interaction,
                          curve: AppMotion.curve,
                        ),
                      ),
              ),
            ),
        ],
      ),
    ),
  );
}

/// Una columna en móvil; pares de campos relacionados cuando cabe, sin altos
/// fijos. Lo usan los formularios anchos y las páginas de trabajo.
class AppFieldGrid extends StatelessWidget {
  const AppFieldGrid({
    super.key,
    required this.children,
    this.minTwoColumnWidth = 600,
  });
  final List<Widget> children;

  /// Ancho disponible a partir del cual se arma en dos columnas.
  final double minTwoColumnWidth;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final twoColumns =
          constraints.maxWidth >= minTwoColumnWidth &&
          MediaQuery.textScalerOf(context).scale(14) <= 20;
      final width = twoColumns
          ? (constraints.maxWidth - 20) / 2
          : constraints.maxWidth;
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          for (final field in children) SizedBox(width: width, child: field),
        ],
      );
    },
  );
}
