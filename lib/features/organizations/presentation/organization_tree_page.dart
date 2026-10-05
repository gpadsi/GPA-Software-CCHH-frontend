import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/colors.dart';
import '../../../core/design_system/motion.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/organizations_controller.dart';
import '../data/organization_models.dart';
import 'node_form.dart';

const organizationTabs = [
  (label: 'Organigrama', path: '/organizacion/organigrama'),
  (label: 'Empresas', path: '/organizacion/empresas'),
];

// Ancho fijo de cada columna de línea del árbol — constante para que las
// líneas de todas las filas queden alineadas entre sí sin importar la
// profundidad de cada nodo.
const _cellWidth = 16.0;

class OrganizationTreePage extends ConsumerStatefulWidget {
  const OrganizationTreePage({super.key});
  @override
  ConsumerState<OrganizationTreePage> createState() =>
      _OrganizationTreePageState();
}

class _OrganizationTreePageState extends ConsumerState<OrganizationTreePage> {
  // Qué nodos están abiertos vive aquí y no en la vista del árbol: al guardar
  // o borrar se recarga el árbol y la vista se reconstruye; si el estado
  // viviera en ella, todo se cerraría de golpe.
  final _expanded = <String>{};

  void _toggle(String id) => setState(() {
    if (!_expanded.remove(id)) _expanded.add(id);
  });

  void _refresh() => ref.invalidate(organizationTreeProvider);

  void _say(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  Future<void> _addChild(OrganizationTree tree, OrganizationNode parent) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => NodeForm(tree: tree, parent: parent),
    );
    if (saved == true && mounted) {
      // Se abre el padre para que se vea el nodo recién creado.
      setState(() => _expanded.add(parent.id));
      _refresh();
      _say('Unidad guardada.');
    }
  }

  Future<void> _edit(OrganizationTree tree, OrganizationNode node) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => NodeForm(tree: tree, node: node),
    );
    if (saved == true && mounted) {
      _refresh();
      _say('Unidad guardada.');
    }
  }

  Future<void> _delete(OrganizationNode node) async {
    final deleted = await showConfirmDialog(
      context,
      title: 'Eliminar unidad',
      message: '¿Eliminar «${node.name}»? Esta acción no se puede deshacer.',
      details: 'Si tiene unidades dentro, posiciones o una empresa asociada, el sistema no lo permitirá.',
      onConfirm: () =>
          ref.read(organizationsRepositoryProvider).deleteNode(node.id),
    );
    if (deleted && mounted) {
      setState(() => _expanded.remove(node.id));
      _refresh();
      _say('Unidad eliminada.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final tree = ref.watch(organizationTreeProvider);
    final canManage = ref.watch(canManageHrProvider);
    return FeaturePage(
      title: 'Organigrama',
      description: 'Explora la estructura de la organización, desde cada empresa hasta sus unidades.',
      tabs: const FeatureTabs(
        current: '/organizacion/organigrama',
        destinations: organizationTabs,
      ),
      actions: [
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: _refresh,
        ),
      ],
      child: tree.when(
        skipLoadingOnRefresh: false,
        data: (value) => OrganizationTreeView(
          tree: value,
          expanded: _expanded,
          onToggle: _toggle,
          actions: canManage
              ? OrgNodeActions(
                  onAddChild: (node) => _addChild(value, node),
                  onEdit: (node) => _edit(value, node),
                  onDelete: _delete,
                )
              : null,
        ),
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(error: error, onRetry: _refresh),
      ),
    );
  }
}

/// Lo que se puede hacer con un nodo desde su menú. Sin esto (cuentas que no
/// pueden escribir) las tarjetas no muestran menú.
class OrgNodeActions {
  const OrgNodeActions({
    required this.onAddChild,
    required this.onEdit,
    required this.onDelete,
  });
  final ValueChanged<OrganizationNode> onAddChild;
  final ValueChanged<OrganizationNode> onEdit;
  final ValueChanged<OrganizationNode> onDelete;
}

class OrganizationTreeView extends StatelessWidget {
  const OrganizationTreeView({
    super.key,
    required this.tree,
    required this.expanded,
    required this.onToggle,
    this.actions,
  });
  final OrganizationTree tree;
  final Set<String> expanded;
  final ValueChanged<String> onToggle;
  final OrgNodeActions? actions;

  @override
  Widget build(BuildContext context) {
    final nodes = tree.nodes;
    if (nodes.isEmpty) {
      return const AppCard(
        child: EmptyState(
          icon: Icons.account_tree_outlined,
          title: 'Sin estructura disponible',
          message: 'Todavía no hay nodos organizacionales disponibles para tu cuenta.',
        ),
      );
    }
    final ids = nodes.map((node) => node.id).toSet();
    final children = <String, List<OrganizationNode>>{};
    final roots = <OrganizationNode>[];
    for (final node in nodes) {
      if (node.parent == null || !ids.contains(node.parent)) {
        roots.add(node);
      } else {
        children.putIfAbsent(node.parent!, () => []).add(node);
      }
    }
    int compare(OrganizationNode a, OrganizationNode b) =>
        a.name.compareTo(b.name);
    roots.sort(compare);
    for (final branch in children.values) {
      branch.sort(compare);
    }
    final levels = {for (final level in tree.levels) level.id: level.name};

    // Recorrido profundidad-primero: cada nodo recibe, además de su
    // profundidad, qué columnas ancestro todavía tienen hermanos pendientes
    // (para dibujar la línea vertical continua) y si él mismo tiene
    // hermanos después (para extender su propia línea hacia abajo).
    final rows = <Widget>[];
    void append(
      OrganizationNode node,
      List<bool> ancestorContinues,
      bool isLast,
    ) {
      final branch = children[node.id] ?? [];
      final open = expanded.contains(node.id);
      final hasChildren = branch.isNotEmpty;
      rows.add(
        Padding(
          key: ValueKey(node.id),
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: _cellWidth * (ancestorContinues.length + 1),
                  child: CustomPaint(
                    painter: _TreeConnectorPainter(
                      ancestorContinues: ancestorContinues,
                      continuesBelow: !isLast,
                    ),
                  ),
                ),
                if (hasChildren)
                  IconButton(
                    tooltip: '${open ? 'Contraer' : 'Expandir'} ${node.name}',
                    onPressed: () => onToggle(node.id),
                    icon: AnimatedRotation(
                      turns: open ? 0.25 : 0,
                      duration: AppMotion.duration(context, AppMotion.content),
                      curve: AppMotion.curve,
                      child: const Icon(Icons.chevron_right),
                    ),
                  )
                else
                  const SizedBox(width: AppSpacing.touchTarget),
                Expanded(
                  child: _OrgNodeCard(
                    node: node,
                    levelLabel: levels[node.level] ?? 'Nivel no disponible',
                    parentMissing:
                        node.parent != null && !ids.contains(node.parent),
                    menu: actions == null
                        ? null
                        : _NodeMenu(
                            node: node,
                            actions: actions!,
                            canAddChild: childLevelsFor(
                              tree.levels,
                              node,
                            ).isNotEmpty,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      if (open) {
        for (var i = 0; i < branch.length; i++) {
          append(branch[i], [
            ...ancestorContinues,
            !isLast,
          ], i == branch.length - 1);
        }
      }
    }

    for (var i = 0; i < roots.length; i++) {
      append(roots[i], const [], i == roots.length - 1);
    }

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            tree.tenants.map((tenant) => tenant.name).join(' · '),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${nodes.length} nodos disponibles · selecciona una flecha para explorar',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          AnimatedSize(
            duration: AppMotion.duration(context, AppMotion.content),
            curve: AppMotion.curve,
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rows,
            ),
          ),
        ],
      ),
    );
  }
}

enum _NodeAction { addChild, edit, delete }

class _NodeMenu extends StatelessWidget {
  const _NodeMenu({
    required this.node,
    required this.actions,
    required this.canAddChild,
  });
  final OrganizationNode node;
  final OrgNodeActions actions;
  final bool canAddChild;

  @override
  Widget build(BuildContext context) => PopupMenuButton<_NodeAction>(
    tooltip: 'Acciones de ${node.name}',
    icon: const Icon(Icons.more_vert),
    onSelected: (action) => switch (action) {
      _NodeAction.addChild => actions.onAddChild(node),
      _NodeAction.edit => actions.onEdit(node),
      _NodeAction.delete => actions.onDelete(node),
    },
    itemBuilder: (_) => [
      if (canAddChild)
        const PopupMenuItem(
          value: _NodeAction.addChild,
          child: Text('Agregar unidad dentro'),
        ),
      const PopupMenuItem(value: _NodeAction.edit, child: Text('Editar')),
      const PopupMenuItem(value: _NodeAction.delete, child: Text('Eliminar')),
    ],
  );
}

/// Dibuja las líneas de un árbol de jerarquía: una vertical continua por
/// cada columna ancestro que todavía tiene hermanos pendientes, y el "codo"
/// (vertical + horizontal) que conecta esta fila con su tarjeta.
class _TreeConnectorPainter extends CustomPainter {
  const _TreeConnectorPainter({
    required this.ancestorContinues,
    required this.continuesBelow,
  });
  final List<bool> ancestorContinues;
  final bool continuesBelow;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;
    final midY = size.height / 2;
    for (var i = 0; i < ancestorContinues.length; i++) {
      if (!ancestorContinues[i]) continue;
      final x = _cellWidth * i + _cellWidth / 2;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    final ownX = _cellWidth * ancestorContinues.length + _cellWidth / 2;
    canvas.drawLine(Offset(ownX, 0), Offset(ownX, midY), paint);
    canvas.drawLine(Offset(ownX, midY), Offset(size.width, midY), paint);
    if (continuesBelow) {
      canvas.drawLine(Offset(ownX, midY), Offset(ownX, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _TreeConnectorPainter oldDelegate) => true;
}

class _OrgNodeCard extends StatelessWidget {
  const _OrgNodeCard({
    required this.node,
    required this.levelLabel,
    required this.parentMissing,
    this.menu,
  });
  final OrganizationNode node;
  final String levelLabel;
  final bool parentMissing;
  final Widget? menu;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.controlRadius),
      border: Border.all(color: AppColors.border),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      child: Text(
                        node.code,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    node.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  if (!node.isActive) const AppBadge(label: 'Inactivo'),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                levelLabel,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              if (parentMissing)
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text('Nodo padre no disponible'),
                ),
            ],
          ),
        ),
        ?menu,
      ],
    ),
  );
}
