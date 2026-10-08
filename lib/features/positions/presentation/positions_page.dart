import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/network/api_page.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/network/table_query.dart';
import '../../../core/widgets/app_fade_switcher.dart';
import '../../../core/widgets/app_table_toolbar.dart';
import '../../recruitment/presentation/recruitment_creation.dart';
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

class _PositionsPageState extends ConsumerState<PositionsPage> {
  int _page = 0;
  TableQuery _query = const TableQuery();

  // Buscar u ordenar vuelve a la primera pagina: la pagina 3 de otra
  // consulta puede no existir.
  void _search(String value) => setState(() {
    _query = _query.copyWith(search: value);
    _page = 0;
  });

  void _order(String ordering) => setState(() {
    _query = _query.copyWith(ordering: ordering);
    _page = 0;
  });

  void _refresh() {
    ref.invalidate(posicionesPageProvider);
    ref.invalidate(allPosicionesForPickerProvider);
  }

  Future<void> _addOrEdit([Posicion? posicion]) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => PositionForm(posicion: posicion),
    );
    if (saved == true && mounted) {
      _refresh();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Posición guardada.')));
    }
  }

  Future<void> _delete(Posicion posicion, String label, int pageLength) async {
    final deleted = await showConfirmDialog(
      context,
      title: 'Eliminar posición',
      message: '¿Eliminar «$label»? Esta acción no se puede deshacer.',
      details: deleteLinkedRecordsHint,
      onConfirm: () =>
          ref.read(positionsRepositoryProvider).delete(posicion.id),
    );
    if (deleted == true && mounted) {
      if (pageLength == 1 && _page > 0) setState(() => _page--);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogs = ref.watch(positionCatalogsProvider);
    final page = ref.watch(posicionesPageProvider(_page, query: _query));
    final canManage = ref.watch(canManageHrProvider);
    return FeaturePage(
      title: 'Posiciones',
      description: 'Puestos ocupados y vacantes, con su línea de reporte.',
      tabs: const FeatureTabs(
        current: '/posiciones',
        destinations: positionsTabs,
      ),
      actions: [
        if (canManage)
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTableToolbar(
            hint: 'Buscar por puesto, área, unidad o estatus',
            value: _query.search,
            onSearch: _search,
          ),
          const SizedBox(height: AppSpacing.md),
          AppFadeSwitcher(
            child: switch ((catalogs, page)) {
              (AsyncError(:final error), _) || (_, AsyncError(:final error)) =>
                FeatureError(error: error, onRetry: _refresh),
              (
                AsyncData(value: final catalogs),
                AsyncData(value: final page),
              ) =>
                _table(catalogs, page, canManage),
              _ => const FeatureLoading(),
            },
          ),
        ],
      ),
    );
  }

  Widget _table(
    PositionCatalogs catalogs,
    ApiPage<Posicion> page,
    bool canManage,
  ) => AppDataTable(
    columns: [
      const DataColumn(label: Text('Puesto')),
      const DataColumn(label: Text('Área')),
      const DataColumn(label: Text('Unidad organizacional')),
      const DataColumn(label: Text('Estatus')),
      const DataColumn(label: Text('Reporta a')),
      if (canManage) const DataColumn(label: Text('Acciones')),
    ],
    rows: [
      for (final posicion in page.results)
        DataRow(
          onSelectChanged: canManage ? (_) => _addOrEdit(posicion) : null,
          cells: [
            DataCell(
              tableText(
                PositionCatalogs.nameIn(catalogs.puestos, posicion.puesto),
              ),
            ),
            DataCell(
              tableText(
                PositionCatalogs.nameInRefs(catalogs.areas, posicion.area),
              ),
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
                name: PositionCatalogs.nameIn(
                  catalogs.estatus,
                  posicion.estatus,
                ),
              ),
            ),
            DataCell(
              posicion.reportsTo == null
                  ? tableText(null)
                  : _ReportsToCell(id: posicion.reportsTo!, catalogs: catalogs),
            ),
            if (canManage)
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Crear requisición',
                      onPressed: () => abrirNuevaRequisicion(
                        context,
                        ref,
                        posicionId: posicion.id,
                      ),
                      icon: const Icon(Icons.post_add_outlined),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    IconButton(
                      tooltip: 'Crear descriptivo',
                      onPressed: () => abrirNuevoDescriptivo(
                        context,
                        ref,
                        posicionId: posicion.id,
                      ),
                      icon: const Icon(Icons.description_outlined),
                    ),
                    const SizedBox(width: AppSpacing.xs),
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
                        PositionCatalogs.nameIn(
                              catalogs.puestos,
                              posicion.puesto,
                            ) ??
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
    sortFields: [
      'puesto__name',
      'area__name',
      'organization_node__name',
      'estatus__name',
      'reports_to__puesto__name',
      if (canManage) null,
    ],
    ordering: _query.ordering,
    onOrderingChanged: _order,
    searchTerm: _query.search,
    onClearSearch: () => _search(''),
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
