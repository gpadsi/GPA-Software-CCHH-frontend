import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/network/api_page.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/network/table_query.dart';
import '../../../core/widgets/app_fade_switcher.dart';
import '../../../core/widgets/app_table_toolbar.dart';
import '../application/schedules_controller.dart';
import '../data/schedule_models.dart';
import 'asignacion_ubicacion_form.dart';
import 'catorcenas_page.dart';

final _displayDate = DateFormat.yMMMd('es_MX');

class AsignacionesUbicacionPage extends ConsumerStatefulWidget {
  const AsignacionesUbicacionPage({super.key});
  @override
  ConsumerState<AsignacionesUbicacionPage> createState() =>
      _AsignacionesUbicacionPageState();
}

class _AsignacionesUbicacionPageState
    extends ConsumerState<AsignacionesUbicacionPage> {
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
    ref.invalidate(asignacionesUbicacionPageProvider);
  }

  Future<void> _addOrEdit([AsignacionUbicacion? asignacion]) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => AsignacionUbicacionForm(asignacion: asignacion),
    );
    if (saved == true && mounted) {
      _refresh();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Asignación de ubicación guardada.')),
      );
    }
  }

  Future<void> _delete(String id, int pageLength) async {
    final deleted = await showConfirmDialog(
      context,
      title: 'Eliminar asignación de ubicación',
      message: '¿Eliminar esta asignación de ubicación? Esta acción no se puede deshacer.',
      onConfirm: () =>
          ref.read(schedulesRepositoryProvider).deleteAsignacionUbicacion(id),
    );
    if (deleted == true && mounted) {
      if (pageLength == 1 && _page > 0) setState(() => _page--);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final areas = ref.watch(areasCatalogProvider);
    final catorcenas = ref.watch(allCatorcenasProvider);
    final page = ref.watch(
      asignacionesUbicacionPageProvider(_page, query: _query),
    );
    final canManage = ref.watch(canManageHrProvider);
    return FeaturePage(
      title: 'Asignaciones de ubicación',
      description: 'La ubicación asignada a cada integrante del equipo.',
      tabs: const FeatureTabs(
        current: '/horarios/asignaciones-ubicacion',
        destinations: schedulesTabs,
      ),
      actions: [
        if (canManage)
          AppButton(
            label: 'Agregar asignación',
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
            hint: 'Buscar por empleado o área',
            value: _query.search,
            onSearch: _search,
          ),
          const SizedBox(height: AppSpacing.md),
          AppFadeSwitcher(
            child: switch ((areas, catorcenas, page)) {
              (AsyncError(:final error), _, _) ||
              (_, AsyncError(:final error), _) ||
              (
                _,
                _,
                AsyncError(:final error),
              ) => FeatureError(error: error, onRetry: _refresh),
              (
                AsyncData(value: final areasList),
                AsyncData(value: final catorcenasList),
                AsyncData(value: final page),
              ) =>
                _table(areasList, catorcenasList, page, canManage),
              _ => const FeatureLoading(),
            },
          ),
        ],
      ),
    );
  }

  Widget _table(
    List<AreaRef> areas,
    List<Catorcena> catorcenas,
    ApiPage<AsignacionUbicacion> page,
    bool canManage,
  ) => AppDataTable(
    columns: [
      const DataColumn(label: Text('Empleado')),
      const DataColumn(label: Text('Área')),
      const DataColumn(label: Text('Catorcena')),
      const DataColumn(label: Text('Fecha de referencia')),
      if (canManage) const DataColumn(label: Text('Acciones')),
    ],
    rows: [
      for (final asignacion in page.results)
        DataRow(
          onSelectChanged: canManage ? (_) => _addOrEdit(asignacion) : null,
          cells: [
            DataCell(_EmpleadoCell(id: asignacion.empleado)),
            DataCell(tableText(nameInAreaRef(areas, asignacion.area))),
            DataCell(
              tableText(labelForCatorcena(catorcenas, asignacion.catorcena)),
            ),
            DataCell(
              Text(
                _displayDate.format(DateTime.parse(asignacion.fechaReferencia)),
              ),
            ),
            if (canManage)
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Editar asignación',
                      onPressed: () => _addOrEdit(asignacion),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    IconButton(
                      tooltip: 'Eliminar asignación',
                      onPressed: () =>
                          _delete(asignacion.id, page.results.length),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
          ],
        ),
    ],
    sortFields: [
      'empleado__persona__last_name_paternal,empleado__persona__last_name_maternal,empleado__persona__first_name',
      'area__name',
      'catorcena__anio,catorcena__numero',
      'fecha_referencia',
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

class _EmpleadoCell extends ConsumerWidget {
  const _EmpleadoCell({required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(empleadoRefProvider(id))
      .when(
        data: (empleado) => TextButton(
          onPressed: () => context.go('/empleados/$id'),
          child: tableText(empleado.workNumber, fallback: 'Ver empleado'),
        ),
        loading: () => const LoadingSkeleton(width: 100),
        error: (_, _) => TextButton(
          onPressed: () => ref.invalidate(empleadoRefProvider(id)),
          child: tableText('No disponible. Reintentar'),
        ),
      );
}
