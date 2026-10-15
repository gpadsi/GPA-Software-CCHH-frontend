import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/colors.dart';
import '../../../core/widgets/app_user_menu.dart';
import 'recruitment_design.dart';

/// El editor ocupa la cabecera de la página: acciones arriba, sin pie fijo.
/// El formulario conserva un solo desplazamiento y toda la altura restante.
class RequisicionEditorLayout extends ConsumerWidget {
  const RequisicionEditorLayout({
    super.key,
    required this.title,
    required this.onBack,
    required this.child,
    this.status,
    this.saveStatus,
    this.compactSaveStatus,
    this.actions = const [],
    this.tabs,
  });

  final String title;
  final VoidCallback? onBack;
  final Widget? status;
  final String? saveStatus;
  final String? compactSaveStatus;
  final List<Widget> actions;
  final Widget? tabs;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionControllerProvider);
    final type = Theme.of(context).textTheme;
    final shell = Scaffold.maybeOf(context);
    return ColoredBox(
      color: context.colors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: context.colors.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final narrow = constraints.maxWidth < 600;
                  final inlineActions =
                      constraints.maxWidth >= 960 &&
                      MediaQuery.textScalerOf(context).scale(14) <= 18;
                  final account = AppUserMenu(
                    user: session.user,
                    onLogout: () =>
                        ref.read(sessionControllerProvider.notifier).logout(),
                    compact: true,
                  );
                  final identity = Row(
                    children: [
                      if (shell?.hasDrawer ?? false)
                        IconButton(
                          tooltip: 'Abrir menú de navegación',
                          onPressed: shell!.openDrawer,
                          icon: const Icon(Icons.menu_rounded, size: 20),
                        ),
                      if (narrow)
                        IconButton(
                          tooltip: 'Volver',
                          onPressed: onBack,
                          icon: const Icon(Icons.arrow_back_rounded, size: 20),
                        )
                      else
                        TextButton.icon(
                          onPressed: onBack,
                          icon: const Icon(Icons.arrow_back_rounded, size: 18),
                          label: const Text('Volver'),
                        ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: narrow
                                  ? type.titleMedium
                                  : type.titleLarge,
                            ),
                            if (status != null || saveStatus != null) ...[
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  if (status != null)
                                    Semantics(
                                      label: narrow ? saveStatus : null,
                                      child: status!,
                                    ),
                                  if (saveStatus != null && !narrow)
                                    Text(saveStatus!, style: type.bodySmall),
                                  if (compactSaveStatus != null && narrow)
                                    Text(
                                      compactSaveStatus!,
                                      style: type.bodySmall,
                                    ),
                                ],
                              ),
                            ],
                          ],
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
                  if (inlineActions) {
                    return Row(
                      children: [
                        Expanded(child: identity),
                        const SizedBox(width: 16),
                        buttons,
                        const SizedBox(width: 12),
                        account,
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(child: identity),
                          const SizedBox(width: 8),
                          account,
                        ],
                      ),
                      if (actions.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        buttons,
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
          if (tabs != null)
            ColoredBox(color: context.colors.surface, child: tabs!),
          Expanded(
            child: SizedBox.expand(
              key: const ValueKey('requisicion-workspace'),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: RecruitmentDesign.contentWidth,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
