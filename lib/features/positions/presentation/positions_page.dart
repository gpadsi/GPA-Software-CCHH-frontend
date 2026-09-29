import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/network/api_page.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../application/positions_controller.dart';
import '../data/position_models.dart';
import 'position_form.dart';

const positionsTabs = [
  (label: 'Posiciones', path: '/posiciones'),
  (label: 'Puestos', path: '/posiciones/puestos'),
];

class PositionsPage extends ConsumerStatefulWidget {
  const PositionsPage({super.key});
  @override
  ConsumerState<PositionsPage> createState() => _PositionsPageState();
}

class _PositionDeleteDialog extends ConsumerStatefulWidget {
  const _PositionDeleteDialog({required this.posicion, required this.label});
  final Posicion posicion;
  final String label;
  @override
  ConsumerState<_PositionDeleteDialog> createState() =>
      _PositionDeleteDialogState();
}

class _PositionDeleteDialogState extends ConsumerState<_PositionDeleteDialog> {
  bool _busy = false;

  Future<void> _delete() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref.read(positionsRepositoryProvider).delete(widget.posicion.id);
      if (mounted) Navigator.of(context).pop(true);
    } on Object {
      if (mounted) Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: AlertDialog(
      title: const Text('Eliminar posición'),
      content: Text(
        '¿Eliminar «${widget.label}»? Esta acción no se puede deshacer.',
      ),
      actions: [
        AppButton(
          label: 'Cancelar',
          variant: AppButtonVariant.secondary,
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
        ),
        AppButton(
          label: 'Eliminar',
          variant: AppButtonVariant.danger,
          isLoading: _busy,
          onPressed: _delete,
        ),
      ],
    ),
  );
}

class _PositionsPageState extends ConsumerState<PositionsPage> {
  int _page = 0;

  void _refresh() {
    ref.invalidate(posicionesPageProvider);
    ref.invalidate(allPosicionesForPickerProvider);
  }

  Future<void> _addOrEdit([Posicion? posicion]) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PositionForm(posicion: posicion),
    );
    if (saved == true && mounted) {
      _refresh();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Posición guardada.')));
    }
  }

  Future<void> _delete(Posicion posicion, String label, int pageLength) async {
    final deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _PositionDeleteDialog(posicion: posicion, label: label),
    );
    if (deleted == true && mounted) {
      if (pageLength == 1 && _page > 0) setState(() => _page--);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogs = ref.watch(positionCatalogsProvider);
    final page = ref.watch(posicionesPageProvider(_page));
    return FeaturePage(
      title: 'Posiciones',
      description: 'Puestos ocupados y vacantes, con su línea de reporte.',
      tabs: const FeatureTabs(current: '/posiciones', destinations: positionsTabs),
      actions: [
        AppButton(
          label: 'Agregar posición',
          icon: Icons.add,
          onPressed: () => _addOrEdit(),
        ),
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: _refresh,
        ),
      ],
      child: switch ((catalogs, page)) {
        (AsyncError(:final error), _) || (_, AsyncError(:final error)) =>
          FeatureError(error: error, onRetry: _refresh),
        (AsyncData(value: final catalogs), AsyncData(value: final page)) =>
          _table(catalogs, page),
        _ => const FeatureLoading(),
      },
    );
  }

  Widget _table(PositionCatalogs catalogs, ApiPage<Posicion> page) => AppDataTable(
    columns: const [
      DataColumn(label: Text('Puesto')),
      DataColumn(label: Text('Área')),
      DataColumn(label: Text('Unidad organizacional')),
      DataColumn(label: Text('Estatus')),
      DataColumn(label: Text('Reporta a')),
      DataColumn(label: Text('Acciones')),
    ],
    rows: [
      for (final posicion in page.results)
        DataRow(
          cells: [
            DataCell(
              tableText(PositionCatalogs.nameIn(catalogs.puestos, posicion.puesto)),
            ),
            DataCell(
              tableText(PositionCatalogs.nameInRefs(catalogs.areas, posicion.area)),
            ),
            DataCell(
              tableText(
                PositionCatalogs.nameInRefs(
                  catalogs.organizationNodes,
                  posicion.organizationNode,
                ),
              ),
            ),
            DataCell(
              _StatusBadge(
                name: PositionCatalogs.nameIn(catalogs.estatus, posicion.estatus),
              ),
            ),
            DataCell(
              posicion.reportsTo == null
                  ? tableText(null)
                  : _ReportsToCell(id: posicion.reportsTo!, catalogs: catalogs),
            ),
            DataCell(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Editar posición',
                    onPressed: () => _addOrEdit(posicion),
                    icon: const Icon(Icons.edit_outlined),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    tooltip: 'Eliminar posición',
                    onPressed: () => _delete(
                      posicion,
                      PositionCatalogs.nameIn(catalogs.puestos, posicion.puesto) ??
                          'esta posición',
                      page.results.length,
                    ),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          ],
        ),
    ],
    totalCount: page.count,
    pageIndex: _page,
    pageSize: 25,
    onPageChanged: (value) => setState(() => _page = value),
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.name});
  final String? name;
  @override
  Widget build(BuildContext context) =>
      name == null ? tableText(null) : AppBadge(label: name!);
}

class _ReportsToCell extends ConsumerWidget {
  const _ReportsToCell({required this.id, required this.catalogs});
  final String id;
  final PositionCatalogs catalogs;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(posicionDetailProvider(id))
      .when(
        data: (jefePosicion) => tableText(
          PositionCatalogs.nameIn(catalogs.puestos, jefePosicion.puesto),
          fallback: 'Puesto no capturado',
        ),
        loading: () => const LoadingSkeleton(width: 120),
        error: (_, _) => TextButton(
          onPressed: () => ref.invalidate(posicionDetailProvider(id)),
          child: tableText('No disponible. Reintentar'),
        ),
      );
}
