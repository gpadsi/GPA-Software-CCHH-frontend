import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../design_system/app_themes.dart';
import '../design_system/colors.dart';
import '../design_system/brand.dart';
import '../design_system/font_controller.dart';
import '../design_system/typography.dart';
import '../design_system/motion.dart';
import '../design_system/spacing.dart';
import '../design_system/theme_controller.dart';
import 'app_badge.dart';
import 'app_button.dart';
import 'app_dialog.dart';
import 'app_overlays.dart';

Future<void> showAppearanceDialog(BuildContext context) => showAppDialog<void>(
  context: context,
  builder: (_) => const AppearanceDialog(),
);

/// Apariencia: cada usuario elige el tema con el que ve la app. El cambio se
/// aplica al momento, también a este mismo diálogo.
class AppearanceDialog extends ConsumerWidget {
  const AppearanceDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(themeControllerProvider);
    return AppDialog(
      title: 'Apariencia',
      subtitle:
          'Personaliza los colores y la letra de Capital Humano. '
          'Tus preferencias se recuerdan en este navegador.',
      size: AppDialogSize.medium,
      onClose: () => Navigator.of(context).pop(),
      actions: [
        AppButton(label: 'Listo', onPressed: () => Navigator.of(context).pop()),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _FontSelector(),
          const SizedBox(height: AppSpacing.lg),
          Text('Tema de color', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 480 ? 2 : 1;
              final width =
                  (constraints.maxWidth - AppSpacing.md * (columns - 1)) /
                  columns;
              return Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  for (final theme in AppThemeId.values)
                    SizedBox(
                      width: width,
                      child: _ThemeOption(
                        theme: theme,
                        selected: theme == current,
                        onTap: () => ref
                            .read(themeControllerProvider.notifier)
                            .select(theme),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FontSelector extends ConsumerWidget {
  const _FontSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(fontControllerProvider);
    final type = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<AppFontChoice>(
          key: ValueKey(current),
          initialValue: current,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Fuente'),
          items: [
            for (final font in AppFontChoice.values)
              DropdownMenuItem(value: font, child: Text(font.label)),
          ],
          onChanged: (font) {
            if (font != null) {
              ref.read(fontControllerProvider.notifier).select(font);
            }
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          current == AppFontChoice.themeDefault
              ? 'Usa la combinación de letras de cada tema.'
              : 'Esta fuente se conserva al cambiar de tema.',
          style: type.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: context.colors.background,
            borderRadius: BorderRadius.circular(context.shape.control),
            border: Border.all(color: context.colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tu equipo, en un mismo lugar', style: type.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text('Áreas · Reclutamiento · 0123456789', style: type.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.theme,
    required this.selected,
    required this.onTap,
  });

  final AppThemeId theme;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final type = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(context.shape.control + 4);
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      label: '${theme.label}. ${theme.description}',
      onTap: onTap,
      child: ExcludeSemantics(
        child: AnimatedContainer(
          duration: AppMotion.duration(context, AppMotion.interaction),
          curve: AppMotion.curve,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: selected ? colors.primary : colors.border,
              width: 2,
            ),
          ),
          child: Material(
            color: colors.surface,
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.sm + 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ThemePreview(theme: theme),
                    const SizedBox(height: AppSpacing.sm + 2),
                    Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.xs,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(theme.label, style: type.titleSmall),
                              if (theme == AppThemeId.fallback)
                                const AppBadge(label: 'Predeterminado'),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        AnimatedOpacity(
                          opacity: selected ? 1 : 0,
                          duration: AppMotion.duration(
                            context,
                            AppMotion.interaction,
                          ),
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      theme.description,
                      style: type.bodySmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Miniatura de la app pintada con los colores del tema: barra lateral,
/// encabezado y una tarjeta con su botón principal.
class _ThemePreview extends StatelessWidget {
  const _ThemePreview({required this.theme});

  final AppThemeId theme;

  @override
  Widget build(BuildContext context) {
    final c = theme.colors;
    Widget bar(double width, Color color, {double height = 5}) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 104,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 42,
              padding: const EdgeInsets.fromLTRB(6, 8, 6, 8),
              decoration: BoxDecoration(
                color: c.sidebar,
                border: Border(right: BorderSide(color: c.sidebarBorder)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const GpaEmblem(size: 12),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            bar(13, c.sidebarText, height: 2),
                            const SizedBox(height: 2),
                            bar(10, c.sidebarText, height: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  for (var i = 0; i < 4; i++)
                    Container(
                      height: 12,
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: i == 1 ? c.sidebarSelected : null,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: bar(
                        i == 1 ? 18 : 14,
                        i == 1
                            ? c.sidebarSelectedText
                            : c.sidebarText.withValues(alpha: 0.7),
                        height: 3,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: c.background,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 22,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: c.header,
                        border: Border(
                          bottom: BorderSide(color: c.headerBorder),
                        ),
                      ),
                      child: bar(44, c.text, height: 6),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: c.surface,
                            border: Border.all(color: c.border),
                            borderRadius: BorderRadius.circular(
                              math.min(theme.shape.card / 2, 9),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  bar(
                                    40,
                                    c.textSecondary.withValues(alpha: 0.5),
                                  ),
                                  const Spacer(),
                                  Container(
                                    width: 30,
                                    height: 11,
                                    decoration: BoxDecoration(
                                      color: c.primary,
                                      borderRadius: BorderRadius.circular(
                                        math.min(theme.shape.button / 2, 6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              for (final tone in [
                                c.successSurface,
                                c.warningSurface,
                              ])
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: c.primarySurface,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      bar(34, c.text.withValues(alpha: 0.6)),
                                      const Spacer(),
                                      bar(16, tone, height: 6),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
