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
import '../application/schedules_controller.dart';
import '../data/schedule_models.dart';
import 'catorcenas_page.dart';
import 'tipo_horario_form.dart';

class TiposHorarioPage extends ConsumerStatefulWidget {
  const TiposHorarioPage({super.key});

  @override
  ConsumerState<TiposHorarioPage> createState() => _TiposHorarioPageState();
}

class _TiposHorarioPageState extends ConsumerState<TiposHorarioPage> {
  int _page = 0;
  TableQuery _query = const TableQuery();

  static final _comparators =
      <String, int Function(TipoHorarioRef, TipoHorarioRef)>{
        'code': (a, b) => foldAccents(a.code).compareTo(foldAccents(b.code)),
        'name': (a, b) => foldAccents(a.name).compareTo(foldAccents(b.name)),
        'descripcion': (a, b) =>
            foldAccents(a.descripcion).compareTo(foldAccents(b.descripcion)),
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

  Future<void> _edit([TipoHorarioRef? tipo]) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => TipoHorarioForm(tipo: tipo),
    );
    if (saved == true && mounted) {
      ref.invalidate(tiposHorarioCatalogProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tipo de horario guardado.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(tiposHorarioCatalogProvider);
    final canManage = ref.watch(canManageHrProvider);
    return FeaturePage(
      title: 'Tipos de horario',
      description: 'Las modalidades de horario de la organización.',
      tabs: const FeatureTabs(
        current: '/horarios/tipos',
        destinations: schedulesTabs,
      ),
      actions: [
        if (canManage)
          AppButton(
            label: 'Agregar tipo de horario',
            icon: Icons.add,
            onPressed: _edit,
          ),
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: () => ref.invalidate(tiposHorarioCatalogProvider),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTableToolbar(
            hint: 'Buscar por código, nombre u horario',
            value: _query.search,
            onSearch: _search,
          ),
          const SizedBox(height: AppSpacing.md),
          AppFadeSwitcher(
            child: catalog.when(
              skipLoadingOnRefresh: false,
              loading: () => const FeatureLoading(),
              error: (error, _) => FeatureError(
                error: error,
                onRetry: () => ref.invalidate(tiposHorarioCatalogProvider),
              ),
              data: (tipos) {
                final result = clientPage(
                  tipos,
                  query: _query,
                  page: _page,
                  searchTexts: (tipo) => [
                    tipo.code,
                    tipo.name,
                    tipo.descripcion,
                  ],
                  comparators: _comparators,
                );
                return AppDataTable(
                  columns: [
                    const DataColumn(label: Text('Código')),
                    const DataColumn(label: Text('Nombre')),
                    const DataColumn(label: Text('Horario')),
                    const DataColumn(label: Text('Estatus')),
                    if (canManage) const DataColumn(label: Text('Acciones')),
                  ],
                  rows: [
                    for (final tipo in result.rows)
                      DataRow(
                        onSelectChanged: canManage ? (_) => _edit(tipo) : null,
                        cells: [
                          DataCell(Text(tipo.code)),
                          DataCell(Text(tipo.name)),
                          DataCell(
                            tableText(
                              tipo.descripcion,
                              fallback: 'Sin capturar',
                            ),
                          ),
                          DataCell(
                            AppBadge(
                              label: tipo.isActive ? 'Activo' : 'Inactivo',
                              tone: tipo.isActive
                                  ? AppBadgeTone.success
                                  : AppBadgeTone.neutral,
                            ),
                          ),
                          if (canManage)
                            DataCell(
                              AppRowActions(
                                subject: tipo.name,
                                onEdit: () => _edit(tipo),
                              ),
                            ),
                        ],
                      ),
                  ],
                  sortFields: [
                    'code',
                    'name',
                    'descripcion',
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
