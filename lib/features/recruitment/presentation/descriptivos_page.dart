import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/network/table_query.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/app_fade_switcher.dart';
import '../../../core/widgets/app_row_actions.dart';
import '../../../core/widgets/app_table_toolbar.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/recruitment_controller.dart';
import '../data/recruitment_models.dart';
import '../data/recruitment_repository.dart';
import 'recruitment_creation.dart';
import 'recruitment_ui.dart';

/// Lo más reciente primero: por fecha de elaboración y, a igual fecha, la
/// versión más alta.
const _defaultOrdering = '-fecha_elaboracion,-version';

class DescriptivosPage extends ConsumerStatefulWidget {
  const DescriptivosPage({super.key});

  @override
  ConsumerState<DescriptivosPage> createState() => _DescriptivosPageState();
}

class _DescriptivosPageState extends ConsumerState<DescriptivosPage> {
  int _page = 0;
  TableQuery _query = const TableQuery(ordering: _defaultOrdering);

  // Buscar, ordenar o filtrar vuelve a la primera página.
  void _apply(TableQuery query) => setState(() {
    _query = query;
    _page = 0;
  });

  void _refresh() => ref.invalidate(descriptivosPageProvider);

  Future<void> _create() => abrirNuevoDescriptivo(context, ref);

  Future<void> _delete(Descriptivo descriptivo, int pageLength) async {
    final deleted = await showConfirmDialog(
      context,
      title: 'Eliminar borrador',
      message:
          '¿Eliminar el borrador v${descriptivo.version} de «${descriptivo.posicionEtiqueta}»? Se pierde lo capturado.',
      details: 'Una versión congelada no se puede eliminar.',
      onConfirm: () => ref
          .read(recruitmentRepositoryProvider)
          .deleteDescriptivo(descriptivo.id),
      errorMessage: recruitmentMutationError,
    );
    if (deleted && mounted) {
      if (pageLength == 1 && _page > 0) setState(() => _page--);
      _refresh();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Borrador eliminado.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(descriptivosPageProvider(_page, query: _query));
    final canManage = ref.watch(canManageHrProvider);
    final filter = _query.filters['congelado'] ?? '';
    return FeaturePage(
      title: 'Descriptivos de puesto',
      description: 'Lo que hace cada posición: sus funciones, condiciones y perfil. Cada versión aprobada queda congelada como historial.',
      tabs: const FeatureTabs(
        current: '/reclutamiento/descriptivos',
        destinations: recruitmentTabs,
      ),
      actions: [
        if (canManage)
          AppButton(
            label: 'Nuevo descriptivo',
            icon: Icons.add,
            onPressed: _create,
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
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 440,
                child: AppTableToolbar(
                  hint: 'Buscar por puesto, empresa o área',
                  value: _query.search,
                  onSearch: (value) => _apply(_query.copyWith(search: value)),
                ),
              ),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  for (final (value, label) in const [
                    ('', 'Todos'),
                    ('false', 'Borradores'),
                    ('true', 'Congelados'),
                  ])
                    ChoiceChip(
                      label: Text(label),
                      selected: filter == value,
                      onSelected: (_) =>
                          _apply(_query.withFilter('congelado', value)),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppFadeSwitcher(
            child: page.when(
              skipLoadingOnRefresh: false,
              loading: () => const FeatureLoading(),
              error: (error, _) =>
                  FeatureError(error: error, onRetry: _refresh),
              data: (data) => AppDataTable(
                columns: const [
                  DataColumn(label: Text('Puesto')),
                  DataColumn(label: Text('Posición')),
                  DataColumn(label: Text('Versión')),
                  DataColumn(label: Text('Estado')),
                  DataColumn(label: Text('Elaborado')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: [
                  for (final d in data.results)
                    DataRow(
                      onSelectChanged: (_) =>
                          context.go('/reclutamiento/descriptivos/${d.id}'),
                      cells: [
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(
                              d.nombrePuesto.trim().isEmpty
                                  ? 'Sin nombre de puesto'
                                  : d.nombrePuesto,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 240,
                            child: Text(
                              d.posicionEtiqueta,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        DataCell(Text('v${d.version}')),
                        DataCell(
                          AppBadge(
                            label: d.estaCongelado ? 'Congelado' : 'Borrador',
                            tone: d.estaCongelado
                                ? AppBadgeTone.success
                                : AppBadgeTone.warning,
                          ),
                        ),
                        DataCell(Text(shownDate(d.fechaElaboracion) ?? '')),
                        DataCell(
                          AppRowActions(
                            subject:
                                'descriptivo v${d.version} de ${d.posicionEtiqueta}',
                            onView: () => context.go(
                              '/reclutamiento/descriptivos/${d.id}',
                            ),
                            onDelete: canManage && !d.estaCongelado
                                ? () => _delete(d, data.results.length)
                                : null,
                          ),
                        ),
                      ],
                    ),
                ],
                sortFields: const [
                  'nombre_puesto',
                  null,
                  'version',
                  'congelado_en',
                  'fecha_elaboracion',
                  null,
                ],
                ordering: _query.ordering,
                onOrderingChanged: (value) =>
                    _apply(_query.copyWith(ordering: value)),
                searchTerm: _query.search,
                onClearSearch: () => _apply(_query.copyWith(search: '')),
                emptyTitle: filter.isNotEmpty
                    ? 'Sin resultados'
                    : 'Todavía no hay descriptivos',
                emptyMessage: filter.isNotEmpty
                    ? 'Ningún descriptivo coincide con el filtro elegido.'
                    : canManage
                    ? 'Usa «Nuevo descriptivo» para abrir el borrador de una posición.'
                    : 'Cuando Capital Humano apruebe un descriptivo aparecerá aquí.',
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
