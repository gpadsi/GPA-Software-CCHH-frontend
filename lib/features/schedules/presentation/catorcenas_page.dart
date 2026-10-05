import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/network/table_query.dart';
import '../../../core/widgets/app_fade_switcher.dart';
import '../../../core/widgets/app_table_toolbar.dart';
import '../application/schedules_controller.dart';
import '../data/schedule_models.dart';
import 'catorcena_form.dart';

const schedulesTabs = [
  (label: 'Catorcenas', path: '/horarios/catorcenas'),
  (label: 'Tipos de horario', path: '/horarios/tipos'),
  (label: 'Asignaciones de horario', path: '/horarios/asignaciones-horario'),
  (
    label: 'Asignaciones de ubicación',
    path: '/horarios/asignaciones-ubicacion',
  ),
];

final _displayDate = DateFormat.yMMMd('es_MX');

class CatorcenasPage extends ConsumerStatefulWidget {
  const CatorcenasPage({super.key});
  @override
  ConsumerState<CatorcenasPage> createState() => _CatorcenasPageState();
}

class _CatorcenasPageState extends ConsumerState<CatorcenasPage> {
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
    ref.invalidate(catorcenasPageProvider);
    ref.invalidate(allCatorcenasProvider);
  }

  Future<void> _addOrEdit([Catorcena? catorcena]) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => CatorcenaForm(catorcena: catorcena),
    );
    if (saved == true && mounted) {
      _refresh();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Catorcena guardada.')));
    }
  }

  Future<void> _delete(Catorcena catorcena, int pageLength) async {
    final deleted = await showConfirmDialog(
      context,
      title: 'Eliminar catorcena',
      message:
          '¿Eliminar la catorcena ${catorcena.numero}/${catorcena.anio}? Esta acción no se puede deshacer.',
      details: deleteLinkedRecordsHint,
      onConfirm: () =>
          ref.read(schedulesRepositoryProvider).deleteCatorcena(catorcena.id),
    );
    if (deleted == true && mounted) {
      if (pageLength == 1 && _page > 0) setState(() => _page--);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(catorcenasPageProvider(_page, query: _query));
    final canManage = ref.watch(canManageHrProvider);
    return FeaturePage(
      title: 'Catorcenas',
      description: 'Los periodos de catorcena que organizan la nómina y el calendario laboral.',
      tabs: const FeatureTabs(
        current: '/horarios/catorcenas',
        destinations: schedulesTabs,
      ),
      actions: [
        if (canManage)
          AppButton(
            label: 'Agregar catorcena',
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
            hint: 'Buscar por número o año',
            value: _query.search,
            onSearch: _search,
          ),
          const SizedBox(height: AppSpacing.md),
          AppFadeSwitcher(
            child: page.when(
              skipLoadingOnRefresh: false,
              loading: () => const FeatureLoading(),
              error: (error, _) =>
                  FeatureError(error: error, onRetry: _refresh),
              data: (data) => AppDataTable(
                columns: [
                  const DataColumn(label: Text('Catorcena')),
                  const DataColumn(label: Text('Fecha de inicio')),
                  const DataColumn(label: Text('Fecha de fin')),
                  if (canManage) const DataColumn(label: Text('Acciones')),
                ],
                rows: [
                  for (final catorcena in data.results)
                    DataRow(
                      onSelectChanged: canManage
                          ? (_) => _addOrEdit(catorcena)
                          : null,
                      cells: [
                        DataCell(Text('${catorcena.numero}/${catorcena.anio}')),
                        DataCell(
                          Text(
                            _displayDate.format(
                              DateTime.parse(catorcena.fechaInicio),
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            _displayDate.format(
                              DateTime.parse(catorcena.fechaFin),
                            ),
                          ),
                        ),
                        if (canManage)
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Editar catorcena',
                                  onPressed: () => _addOrEdit(catorcena),
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                IconButton(
                                  tooltip: 'Eliminar catorcena',
                                  onPressed: () =>
                                      _delete(catorcena, data.results.length),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
                sortFields: [
                  'anio,numero',
                  'fecha_inicio',
                  'fecha_fin',
                  if (canManage) null,
                ],
                ordering: _query.ordering,
                onOrderingChanged: _order,
                searchTerm: _query.search,
                onClearSearch: () => _search(''),
                totalCount: data.count,
                pageIndex: _page,
                pageSize: 25,
                onPageChanged: (value) => setState(() => _page = value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
