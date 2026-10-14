import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/colors.dart';
import '../../../core/design_system/motion.dart';
import '../../../core/widgets/app_card.dart';

/// Superficies y composición de Reclutamiento. Se aplican únicamente al módulo.
abstract final class RecruitmentDesign {
  static const canvas = Color(0xFFF5F2F3);
  static const surface = Color(0xFFFFFDFD);
  static const border = Color(0xFFE3DADD);
  static const soft = Color(0xFFF0E7EA);
  static const contentWidth = 1040.0;
}

class RecruitmentSurface extends StatelessWidget {
  const RecruitmentSurface({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: RecruitmentDesign.border),
    );
    return Theme(
      data: theme.copyWith(
        inputDecorationTheme: theme.inputDecorationTheme.copyWith(
          fillColor: RecruitmentDesign.surface,
          enabledBorder: border,
          border: border,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        chipTheme: theme.chipTheme.copyWith(
          backgroundColor: RecruitmentDesign.surface,
          selectedColor: RecruitmentDesign.soft,
          side: const BorderSide(color: RecruitmentDesign.border),
        ),
      ),
      child: ColoredBox(color: RecruitmentDesign.canvas, child: child),
    );
  }
}

/// Encabezado de las listas y fichas: la acción principal está junto al título.
class RecruitmentPage extends StatelessWidget {
  const RecruitmentPage({
    super.key,
    required this.title,
    required this.description,
    required this.child,
    this.actions = const [],
    this.tabs,
  });
  final String title;
  final String description;
  final Widget child;
  final List<Widget> actions;
  final Widget? tabs;

  @override
  Widget build(BuildContext context) => RecruitmentSurface(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 760;
        final heading = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CAPITAL HUMANO / RECLUTAMIENTO',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.6),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        );
        final buttons = Wrap(spacing: 8, runSpacing: 8, children: actions);
        return SingleChildScrollView(
          padding: EdgeInsets.all(compact ? 16 : 32),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320),
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: heading),
                        const SizedBox(width: 24),
                        Flexible(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: buttons,
                          ),
                        ),
                      ],
                    ),
                  if (tabs != null) ...[const SizedBox(height: 24), tabs!],
                  const SizedBox(height: 24),
                  child,
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}

class RecruitmentModuleTabs extends StatelessWidget {
  const RecruitmentModuleTabs({super.key, required this.current});
  final String current;

  @override
  Widget build(BuildContext context) => RecruitmentSectionTabs(
    labels: const ['Requisiciones', 'Descriptivos de puesto'],
    selected: current == '/reclutamiento' ? 0 : 1,
    onSelected: (index) => context.go(
      index == 0 ? '/reclutamiento' : '/reclutamiento/descriptivos',
    ),
  );
}

class RecruitmentEditorLayout extends StatelessWidget {
  const RecruitmentEditorLayout({
    super.key,
    required this.header,
    required this.tabs,
    required this.child,
    this.footer,
  });
  final Widget header;
  final Widget tabs;
  final Widget child;
  final Widget? footer;

  @override
  Widget build(BuildContext context) => RecruitmentSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: RecruitmentDesign.contentWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  header,
                  tabs,
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ),
        ?footer,
      ],
    ),
  );
}

class RecruitmentEditorHeader extends StatelessWidget {
  const RecruitmentEditorHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.status,
  });
  final String title;
  final String subtitle;
  final VoidCallback? onBack;
  final Widget? status;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded, size: 17),
              label: const Text('Volver'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Reclutamiento',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Tooltip(
                message: title,
                excludeFromSemantics: true,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),
            if (status != null) ...[const SizedBox(width: 12), status!],
          ],
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall
              ?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    ),
  );
}

class RecruitmentSectionTabs extends StatelessWidget {
  const RecruitmentSectionTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: RecruitmentDesign.border)),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
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
                selectedColor: RecruitmentDesign.soft,
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
                      ? AppColors.primary
                      : AppColors.textSecondary,
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

class RecruitmentActionBar extends StatelessWidget {
  const RecruitmentActionBar({
    super.key,
    required this.status,
    required this.actions,
    this.dirty = false,
  });
  final String status;
  final List<Widget> actions;
  final bool dirty;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: const BoxDecoration(
      color: RecruitmentDesign.surface,
      border: Border(top: BorderSide(color: RecruitmentDesign.border)),
    ),
    child: SafeArea(
      top: false,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: RecruitmentDesign.contentWidth,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final message = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      dirty ? Icons.edit_outlined : Icons.check_circle_outline,
                      size: 16,
                      color: dirty
                          ? AppColors.warning
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        status,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                );
                final buttons = Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: actions,
                );
                return constraints.maxWidth < 660
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          message,
                          const SizedBox(height: 10),
                          buttons,
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: message),
                          const SizedBox(width: 16),
                          buttons,
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    ),
  );
}

class RecruitmentFormSection extends StatelessWidget {
  const RecruitmentFormSection({
    super.key,
    required this.title,
    required this.description,
    required this.children,
  });
  final String title;
  final String description;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: AppCard(
      color: RecruitmentDesign.surface,
      borderColor: RecruitmentDesign.border,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(description, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    ),
  );
}

/// Una columna en móvil; pares relacionados en escritorio, sin altos fijos.
class RecruitmentFieldGrid extends StatelessWidget {
  const RecruitmentFieldGrid({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final twoColumns =
          constraints.maxWidth >= 600 &&
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
