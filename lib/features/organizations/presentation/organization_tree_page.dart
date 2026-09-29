import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/colors.dart';
import '../../../core/design_system/motion.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/organizations_controller.dart';
import '../data/organization_models.dart';

const organizationTabs = [
  (label: 'Organigrama', path: '/organizacion/organigrama'),
  (label: 'Empresas', path: '/organizacion/empresas'),
];

// Ancho fijo de cada columna de línea del árbol — constante para que las
// líneas de todas las filas queden alineadas entre sí sin importar la
// profundidad de cada nodo.
const _cellWidth = 16.0;

class OrganizationTreePage extends ConsumerWidget {
  const OrganizationTreePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tree = ref.watch(organizationTreeProvider);
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
          onPressed: () => ref.invalidate(organizationTreeProvider),
        ),
      ],
      child: tree.when(
        skipLoadingOnRefresh: false,
        data: (value) => OrganizationTreeView(tree: value),
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(
          error: error,
          onRetry: () => ref.invalidate(organizationTreeProvider),
        ),
      ),
    );
  }
}

class OrganizationTreeView extends StatefulWidget {
  const OrganizationTreeView({super.key, required this.tree});
  final OrganizationTree tree;
  @override
  State<OrganizationTreeView> createState() => _OrganizationTreeViewState();
}

class _OrganizationTreeViewState extends State<OrganizationTreeView> {
  final _expanded = <String>{};

  @override
  Widget build(BuildContext context) {
    final nodes = widget.tree.nodes;
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
    final levels = {
      for (final level in widget.tree.levels) level.id: level.name,
    };

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
      final open = _expanded.contains(node.id);
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
                    onPressed: () => setState(() {
                      if (open) {
                        _expanded.remove(node.id);
                      } else {
                        _expanded.add(node.id);
                      }
                    }),
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
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      if (open) {
        for (var i = 0; i < branch.length; i++) {
          append(branch[i], [...ancestorContinues, !isLast], i == branch.length - 1);
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
            widget.tree.tenants.map((tenant) => tenant.name).join(' · '),
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
  });
  final OrganizationNode node;
  final String levelLabel;
  final bool parentMissing;

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
        BoxShadow(color: Color(0x14000000), blurRadius: 6, offset: Offset(0, 2)),
      ],
    ),
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
            Text(node.name, style: Theme.of(context).textTheme.titleSmall),
            if (!node.isActive) const AppBadge(label: 'Inactivo'),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          levelLabel,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        if (parentMissing)
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text('Nodo padre no disponible'),
          ),
      ],
    ),
  );
}
