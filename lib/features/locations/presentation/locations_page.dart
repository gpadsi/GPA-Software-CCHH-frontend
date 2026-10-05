import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/network/table_query.dart';
import '../../../core/widgets/app_fade_switcher.dart';
import '../../../core/widgets/app_table_toolbar.dart';
import '../application/locations_controller.dart';
import '../data/location_models.dart';
import '../data/locations_repository.dart';
import 'location_form.dart';

class LocationsPage extends ConsumerStatefulWidget {
  const LocationsPage({super.key, required this.kind});
  final LocationKind kind;
  @override
  ConsumerState<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends ConsumerState<LocationsPage> {
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
    ref.invalidate(locationPageProvider);
    ref.invalidate(locationCatalogProvider);
  }

  Future<void> _edit([LocationRecord? record]) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => LocationForm(kind: widget.kind, record: record),
    );
    if (saved == true && mounted) {
      _refresh();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Registro guardado.')));
    }
  }

  Future<void> _delete(LocationRecord record, int pageLength) async {
    final deleted = await showConfirmDialog(
      context,
      title: 'Eliminar ${widget.kind.singular}',
      message:
          '¿Eliminar «${record.displayName}»? Esta acción no se puede deshacer.',
      details: 'Si tiene registros vinculados, el sistema puede impedir su eliminación.',
      onConfirm: () =>
          ref.read(locationsRepositoryProvider).delete(widget.kind, record.id),
      errorMessage: (error) => locationMutationError(error, deleting: true),
    );
    if (deleted == true && mounted) {
      if (pageLength == 1 && _page > 0) setState(() => _page--);
      _refresh();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Registro eliminado.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final kind = widget.kind;
    final page = ref.watch(locationPageProvider(kind, _page, query: _query));
    final canManage = ref.watch(canManageHrProvider);
    final catalog = kind == LocationKind.ubicaciones
        ? const AsyncData(LocationCatalog(ubicaciones: [], naves: []))
        : ref.watch(locationCatalogProvider);
    final path = kind == LocationKind.ubicaciones
        ? '/ubicaciones'
        : '/ubicaciones/${kind.name}';
    return FeaturePage(
      title: kind.label,
      description: switch (kind) {
        LocationKind.ubicaciones =>
          'Administra los centros de trabajo y su registro patronal.',
        LocationKind.naves =>
          'Cada nave pertenece a una ubicación. Su nombre es opcional.',
        LocationKind.areas => 'Cada área puede vincularse a una nave; las que siguen sin confirmar se muestran como pendientes.',
      },
      tabs: FeatureTabs(
        current: path,
        destinations: const [
          (label: 'Ubicaciones', path: '/ubicaciones'),
          (label: 'Naves', path: '/ubicaciones/naves'),
          (label: 'Áreas', path: '/ubicaciones/areas'),
        ],
      ),
      actions: [
        if (canManage)
          AppButton(
            label: 'Agregar ${kind.singular}',
            icon: Icons.add,
            onPressed: _edit,
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
            hint: switch (kind) {
              LocationKind.ubicaciones =>
                'Buscar por código, nombre o registro patronal',
              LocationKind.naves => 'Buscar por código, nombre o ubicación',
              LocationKind.areas =>
                'Buscar por código, nombre, nave o ubicación',
            },
            value: _query.search,
            onSearch: _search,
          ),
          const SizedBox(height: AppSpacing.md),
          AppFadeSwitcher(
            child: catalog.when(
              skipLoadingOnRefresh: false,
              loading: () => const FeatureLoading(),
              error: (error, _) =>
                  FeatureError(error: error, onRetry: _refresh),
              data: (references) => page.when(
                skipLoadingOnRefresh: false,
                loading: () => const FeatureLoading(),
                error: (error, _) =>
                    FeatureError(error: error, onRetry: _refresh),
                data: (data) => AppDataTable(
                  columns: [
                    const DataColumn(label: Text('Código')),
                    const DataColumn(label: Text('Nombre')),
                    if (kind != LocationKind.ubicaciones)
                      const DataColumn(label: Text('Ubicación')),
                    if (kind == LocationKind.areas)
                      const DataColumn(label: Text('Nave')),
                    if (kind == LocationKind.ubicaciones)
                      const DataColumn(label: Text('Registro patronal')),
                    const DataColumn(label: Text('Estado')),
                    if (canManage) const DataColumn(label: Text('Acciones')),
                  ],
                  rows: [
                    for (final record in data.results)
                      DataRow(
                        onSelectChanged: canManage
                            ? (_) => _edit(record)
                            : null,
                        cells: [
                          DataCell(tableText(record.code)),
                          DataCell(
                            tableText(
                              record.name,
                              fallback: 'Sin nombre capturado',
                            ),
                          ),
                          if (kind != LocationKind.ubicaciones)
                            DataCell(
                              tableText(
                                kind == LocationKind.naves
                                    ? references.ubicacionName(record.ubicacion)
                                    : record.nave == null
                                    ? 'Pendiente'
                                    : references.ubicacionName(
                                        references
                                            .naveById(record.nave)
                                            ?.ubicacion,
                                      ),
                              ),
                            ),
                          if (kind == LocationKind.areas)
                            DataCell(
                              tableText(
                                record.nave == null
                                    ? 'Sin nave confirmada'
                                    : references
                                          .naveById(record.nave)
                                          ?.displayName,
                                fallback: 'Nave no disponible',
                              ),
                            ),
                          if (kind == LocationKind.ubicaciones)
                            DataCell(tableText(record.employerRegistration)),
                          DataCell(
                            AppBadge(
                              label: record.isActive ? 'Activo' : 'Inactivo',
                              tone: record.isActive
                                  ? AppBadgeTone.success
                                  : AppBadgeTone.neutral,
                            ),
                          ),
                          if (canManage)
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    tooltip: 'Editar ${record.code}',
                                    onPressed: () => _edit(record),
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  const SizedBox(width: AppSpacing.xs),
                                  IconButton(
                                    tooltip: 'Eliminar ${record.code}',
                                    onPressed: () =>
                                        _delete(record, data.results.length),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                  ],
                  sortFields: [
                    'code',
                    'name',
                    if (kind == LocationKind.naves) 'ubicacion__name',
                    if (kind == LocationKind.areas) ...[
                      'nave__ubicacion__name',
                      'nave__name',
                    ],
                    if (kind == LocationKind.ubicaciones)
                      'employer_registration',
                    'is_active',
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
          ),
        ],
      ),
    );
  }
}
