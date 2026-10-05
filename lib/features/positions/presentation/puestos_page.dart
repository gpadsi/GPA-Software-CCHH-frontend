import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/network/client_table.dart';
import '../../../core/network/table_query.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_row_actions.dart';
import '../../../core/widgets/app_fade_switcher.dart';
import '../../../core/widgets/app_table_toolbar.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/positions_controller.dart';
import '../data/position_models.dart';
import 'positions_page.dart';
import 'puesto_form.dart';

class PuestosPage extends ConsumerStatefulWidget {
  const PuestosPage({super.key});

  @override
  ConsumerState<PuestosPage> createState() => _PuestosPageState();
}

class _PuestosPageState extends ConsumerState<PuestosPage> {
  int _page = 0;
  TableQuery _query = const TableQuery();

  // El catálogo de puestos llega entero (cientos de filas): se busca, se
  // ordena y se pagina aquí, sin volver al servidor.
  static final _comparators =
      <String, int Function(PositionCatalogEntry, PositionCatalogEntry)>{
        'code': (a, b) => foldAccents(a.code).compareTo(foldAccents(b.code)),
        'name': (a, b) => foldAccents(a.name).compareTo(foldAccents(b.name)),
        'es_gerencia_de_unidad': (a, b) => (a.esGerenciaDeUnidad ? 1 : 0)
            .compareTo(b.esGerenciaDeUnidad ? 1 : 0),
        'is_active': (a, b) =>
            (a.isActive ? 1 : 0).compareTo(b.isActive ? 1 : 0),
      };

  void _search(String value) => setState(() {
    _query = _query.copyWith(search: value);
    _page = 0;
  });

  void _order(String ordering) => setState(() {
    _query = _query.copyWith(ordering: ordering);
    _page = 0;
  });

  Future<void> _edit([PositionCatalogEntry? puesto]) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => PuestoForm(puesto: puesto),
    );
    if (saved == true && mounted) {
      ref.invalidate(positionCatalogsProvider);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Puesto guardado.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogs = ref.watch(positionCatalogsProvider);
    final canManage = ref.watch(canManageHrProvider);
    return FeaturePage(
      title: 'Puestos',
      description: 'El catálogo de puestos de Grupo GPA.',
      tabs: const FeatureTabs(
        current: '/posiciones/puestos',
        destinations: positionsTabs,
      ),
      actions: [
        if (canManage)
          AppButton(label: 'Agregar puesto', icon: Icons.add, onPressed: _edit),
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: () => ref.invalidate(positionCatalogsProvider),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTableToolbar(
            hint: 'Buscar por código o nombre',
            value: _query.search,
            onSearch: _search,
          ),
          const SizedBox(height: AppSpacing.md),
          AppFadeSwitcher(
            child: catalogs.when(
              skipLoadingOnRefresh: false,
              loading: () => const FeatureLoading(),
              error: (error, _) => FeatureError(
                error: error,
                onRetry: () => ref.invalidate(positionCatalogsProvider),
              ),
              data: (catalogs) {
                final result = clientPage(
                  catalogs.puestos,
                  query: _query,
                  page: _page,
                  searchTexts: (puesto) => [puesto.code, puesto.name],
                  comparators: _comparators,
                );
                return AppDataTable(
                  columns: [
                    const DataColumn(label: Text('Código')),
                    const DataColumn(label: Text('Nombre')),
                    const DataColumn(label: Text('Gerencia de unidad')),
                    const DataColumn(label: Text('Estatus')),
                    if (canManage) const DataColumn(label: Text('Acciones')),
                  ],
                  rows: [
                    for (final puesto in result.rows)
                      DataRow(
                        onSelectChanged: canManage
                            ? (_) => _edit(puesto)
                            : null,
                        cells: [
                          DataCell(Text(puesto.code)),
                          DataCell(Text(puesto.name)),
                          DataCell(
                            puesto.esGerenciaDeUnidad
                                ? const AppBadge(
                                    label: 'Sí',
                                    tone: AppBadgeTone.success,
                                  )
                                : tableText(null, fallback: 'No'),
                          ),
                          DataCell(
                            AppBadge(
                              label: puesto.isActive ? 'Activo' : 'Inactivo',
                              tone: puesto.isActive
                                  ? AppBadgeTone.success
                                  : AppBadgeTone.neutral,
                            ),
                          ),
                          if (canManage)
                            DataCell(
                              AppRowActions(
                                subject: puesto.name,
                                onEdit: () => _edit(puesto),
                              ),
                            ),
                        ],
                      ),
                  ],
                  sortFields: [
                    'code',
                    'name',
                    'es_gerencia_de_unidad',
                    'is_active',
                    if (canManage) null,
                  ],
                  ordering: _query.ordering,
                  onOrderingChanged: _order,
                  searchTerm: _query.search,
                  onClearSearch: () => _search(''),
                  totalCount: result.total,
                  pageIndex: _page,
                  pageSize: 25,
                  onPageChanged: (value) => setState(() => _page = value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
