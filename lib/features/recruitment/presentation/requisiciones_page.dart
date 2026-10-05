import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/colors.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/network/api_page.dart';
import '../../../core/network/table_query.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/app_fade_switcher.dart';
import '../../../core/widgets/app_filter_field.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_row_actions.dart';
import '../../../core/widgets/app_table_toolbar.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/recruitment_controller.dart';
import '../data/recruitment_catalogs.dart';
import '../data/recruitment_models.dart';
import '../data/recruitment_repository.dart';
import 'recruitment_ui.dart';
import 'requisicion_form.dart';

/// Quién puede editar una requisición: Capital Humano y Admin las de todos, y
/// cualquier otra cuenta la que ella misma levantó (la API aplica la misma
/// regla; esto solo evita ofrecer un botón que rechazaría).
bool canEditRequisicion(Requisicion r, {required bool canManage, String? me}) =>
    canManage || (me != null && r.creadoPor == me);

class RequisicionesPage extends ConsumerStatefulWidget {
  const RequisicionesPage({super.key});

  @override
  ConsumerState<RequisicionesPage> createState() => _RequisicionesPageState();
}

class _RequisicionesPageState extends ConsumerState<RequisicionesPage> {
  int _page = 0;
  TableQuery _query = const TableQuery();

  // Buscar, ordenar o filtrar vuelve a la primera página: la página 3 de otra
  // consulta puede no existir.
  void _apply(TableQuery query) => setState(() {
    _query = query;
    _page = 0;
  });

  void _refresh() => ref.invalidate(requisicionesPageProvider);

  Future<void> _create() async {
    final saved = await showAppPanel<Requisicion>(
      context: context,
      builder: (_) => const RequisicionForm(),
    );
    if (saved != null && mounted) {
      _refresh();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Requisición creada.')));
      context.go('/reclutamiento/requisiciones/${saved.id}');
    }
  }

  Future<void> _edit(Requisicion requisicion) async {
    final saved = await showAppPanel<Requisicion>(
      context: context,
      builder: (_) => RequisicionForm(requisicion: requisicion),
    );
    if (saved != null && mounted) {
      _refresh();
      ref.invalidate(requisicionDetailProvider);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Requisición guardada.')));
    }
  }

  Future<void> _delete(Requisicion requisicion, int pageLength) async {
    final deleted = await showConfirmDialog(
      context,
      title: 'Eliminar requisición',
      message:
          '¿Eliminar la requisición de «${requisicion.posicionEtiqueta}»? Deja de aparecer en el sistema.',
      onConfirm: () => ref
          .read(recruitmentRepositoryProvider)
          .deleteRequisicion(requisicion.id),
      errorMessage: recruitmentMutationError,
    );
    if (deleted && mounted) {
      if (pageLength == 1 && _page > 0) setState(() => _page--);
      _refresh();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Requisición eliminada.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogs = ref.watch(requisicionCatalogsProvider);
    final page = ref.watch(requisicionesPageProvider(_page, query: _query));
    final canManage = ref.watch(canManageHrProvider);
    return FeaturePage(
      title: 'Reclutamiento',
      description: 'Las requisiciones para cubrir una posición, ya sea por reemplazo o por una posición nueva.',
      tabs: const FeatureTabs(
        current: '/reclutamiento',
        destinations: recruitmentTabs,
      ),
      actions: [
        AppButton(
          label: 'Nueva requisición',
          icon: Icons.add,
          onPressed: _create,
        ),
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: () {
            ref.invalidate(requisicionCatalogsProvider);
            _refresh();
          },
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
                  hint: 'Buscar por puesto, unidad, área, tipo o estado',
                  value: _query.search,
                  onSearch: (value) => _apply(_query.copyWith(search: value)),
                ),
              ),
              ...?catalogs.value == null
                  ? null
                  : [
                      AppFilterField<int>(
                        label: 'Estado',
                        value: int.tryParse(_query.filters['estado'] ?? ''),
                        options: [
                          for (final item in catalogs.value!.estados)
                            (value: item.id, label: item.name),
                        ],
                        onChanged: (value) => _apply(
                          _query.withFilter('estado', value?.toString() ?? ''),
                        ),
                      ),
                      AppFilterField<int>(
                        label: 'Tipo',
                        value: int.tryParse(_query.filters['tipo'] ?? ''),
                        options: [
                          for (final item in catalogs.value!.tipos)
                            (value: item.id, label: item.name),
                        ],
                        onChanged: (value) => _apply(
                          _query.withFilter('tipo', value?.toString() ?? ''),
                        ),
                      ),
                    ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppFadeSwitcher(
            child: switch ((catalogs, page)) {
              (AsyncError(:final error), _) ||
              (_, AsyncError(:final error)) => FeatureError(
                error: error,
                onRetry: () {
                  ref.invalidate(requisicionCatalogsProvider);
                  _refresh();
                },
              ),
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
    RequisicionCatalogs catalogs,
    ApiPage<Requisicion> page,
    bool canManage,
  ) {
    final me = ref.watch(sessionControllerProvider).user?.id;
    final filtered = _query.filters.values.any((value) => value.isNotEmpty);
    return AppDataTable(
      columns: [
        const DataColumn(label: Text('Posición')),
        const DataColumn(label: Text('Estado')),
        const DataColumn(label: Text('Fecha de solicitud')),
        if (canManage) const DataColumn(label: Text('Solicitante')),
        const DataColumn(label: Text('Acciones')),
      ],
      rows: [
        for (final r in page.results)
          DataRow(
            onSelectChanged: (_) =>
                context.go('/reclutamiento/requisiciones/${r.id}'),
            cells: [
              DataCell(
                _PosicionCell(
                  etiqueta: r.posicionEtiqueta,
                  // El tipo y el área van debajo de la posición: así la tabla
                  // cabe sin desplazarse y las acciones siempre se ven.
                  detalle: [
                    nameIn(catalogs.tipos, r.tipo),
                    if (r.areaSolicitante.trim().isNotEmpty) r.areaSolicitante,
                  ].whereType<String>().join(' · '),
                ),
              ),
              DataCell(
                AppBadge(
                  label: nameIn(catalogs.estados, r.estado) ?? '',
                  tone: estadoTone(entryIn(catalogs.estados, r.estado)?.code),
                ),
              ),
              DataCell(Text(shownDate(r.fechaSolicitud) ?? '')),
              if (canManage)
                DataCell(
                  tableText(r.solicitante, fallback: 'Importada de GPA'),
                ),
              DataCell(
                AppRowActions(
                  subject: 'requisición de ${r.posicionEtiqueta}',
                  onView: () =>
                      context.go('/reclutamiento/requisiciones/${r.id}'),
                  onEdit: canEditRequisicion(r, canManage: canManage, me: me)
                      ? () => _edit(r)
                      : null,
                  onDelete: canManage
                      ? () => _delete(r, page.results.length)
                      : null,
                ),
              ),
            ],
          ),
      ],
      sortFields: [
        'posicion__puesto__name',
        'estado__name',
        'fecha_solicitud',
        if (canManage) null,
        null,
      ],
      ordering: _query.ordering,
      onOrderingChanged: (value) => _apply(_query.copyWith(ordering: value)),
      searchTerm: _query.search,
      onClearSearch: () => _apply(_query.copyWith(search: '')),
      emptyTitle: filtered ? 'Sin resultados' : 'Todavía no hay requisiciones',
      emptyMessage: filtered
          ? 'Ninguna requisición coincide con los filtros elegidos.'
          : canManage
          ? 'Cuando alguien levante una requisición aparecerá aquí.'
          : 'Todavía no has levantado ninguna. Usa «Nueva requisición» para pedir que se cubra una posición.',
      totalCount: page.count,
      pageIndex: _page,
      pageSize: 25,
      onPageChanged: (value) => setState(() => _page = value),
    );
  }
}

/// La posición con su tipo y área en una segunda línea más tenue.
class _PosicionCell extends StatelessWidget {
  const _PosicionCell({required this.etiqueta, required this.detalle});
  final String etiqueta;
  final String detalle;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 300,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(etiqueta, maxLines: 2, overflow: TextOverflow.ellipsis),
        if (detalle.isNotEmpty)
          Text(
            detalle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
      ],
    ),
  );
}
