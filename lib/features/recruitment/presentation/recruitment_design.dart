import 'package:flutter/material.dart';

import '../../../core/design_system/colors.dart';
import '../../../core/widgets/app_card.dart';

/// Composición de las páginas de trabajo de Reclutamiento (Requisición y
/// Descriptivo). Los colores son los del tema activo.
abstract final class RecruitmentDesign {
  static const contentWidth = 1040.0;
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
  Widget build(BuildContext context) => ColoredBox(
    color: context.colors.background,
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
                foregroundColor: context.colors.textSecondary,
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
              ?.copyWith(color: context.colors.textSecondary),
        ),
      ],
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
    decoration: BoxDecoration(
      color: context.colors.surface,
      border: Border(top: BorderSide(color: context.colors.border)),
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
                          ? context.colors.warning
                          : context.colors.textSecondary,
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
