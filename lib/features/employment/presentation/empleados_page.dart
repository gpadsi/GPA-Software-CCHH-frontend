import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/app_row_actions.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../../core/network/table_query.dart';
import '../../../core/widgets/app_fade_switcher.dart';
import '../../../core/widgets/app_table_toolbar.dart';
import '../../../core/design_system/spacing.dart';
import '../application/employment_controller.dart';
import '../data/employment_models.dart';
import 'empleado_form.dart';

// Un empleado se da de alta eligiendo una Persona que ya existe (buscador
// con el servidor, hay más de 500) y se edita su número de nómina. No se
// borra desde aquí: la baja de un empleado es el cierre de su contrato, y
// "Eliminar" invitaría a usarlo como si lo fuera.
class EmpleadosPage extends ConsumerStatefulWidget {
  const EmpleadosPage({super.key});
  @override
  ConsumerState<EmpleadosPage> createState() => _EmpleadosPageState();
}

class _EmpleadosPageState extends ConsumerState<EmpleadosPage> {
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

  Future<void> _edit([Empleado? empleado]) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => EmpleadoForm(empleado: empleado),
    );
    if (saved == true && mounted) {
      ref.invalidate(empleadosPageProvider);
      ref.invalidate(empleadoDetailProvider);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Empleado guardado.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(empleadosPageProvider(_page, query: _query));
    final canManage = ref.watch(canManageHrProvider);
    return FeaturePage(
      title: 'Empleados',
      description: 'Relación laboral, contrato y posición de cada empleado.',
      actions: [
        if (canManage)
          AppButton(
            label: 'Agregar empleado',
            icon: Icons.add,
            onPressed: _edit,
          ),
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: () => ref.invalidate(empleadosPageProvider),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTableToolbar(
            hint: 'Buscar por número de nómina o nombre',
            value: _query.search,
            onSearch: _search,
          ),
          const SizedBox(height: AppSpacing.md),
          AppFadeSwitcher(
            child: page.when(
              skipLoadingOnRefresh: false,
              loading: () => const FeatureLoading(),
              error: (error, _) => FeatureError(
                error: error,
                onRetry: () => ref.invalidate(empleadosPageProvider),
              ),
              data: (data) => AppDataTable(
                columns: const [
                  DataColumn(label: Text('Número de nómina')),
                  DataColumn(label: Text('Persona')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: [
                  for (final empleado in data.results)
                    DataRow(
                      onSelectChanged: (_) =>
                          context.go('/empleados/${empleado.id}'),
                      cells: [
                        DataCell(tableText(empleado.workNumber)),
                        DataCell(_PersonaName(personaId: empleado.persona)),
                        DataCell(
                          AppRowActions(
                            subject: 'empleado ${empleado.workNumber ?? ''}'
                                .trim(),
                            onView: () =>
                                context.go('/empleados/${empleado.id}'),
                            onEdit: canManage ? () => _edit(empleado) : null,
                          ),
                        ),
                      ],
                    ),
                ],
                sortFields: [
                  'work_number',
                  'persona__last_name_paternal,persona__last_name_maternal,persona__first_name',
                  null,
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

class _PersonaName extends ConsumerWidget {
  const _PersonaName({required this.personaId});
  final String personaId;
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(personSummaryProvider(personaId))
      .when(
        data: (persona) => tableText(persona.fullName),
        loading: () => const LoadingSkeleton(width: 160),
        error: (_, _) => TextButton(
          onPressed: () => ref.invalidate(personSummaryProvider(personaId)),
          child: tableText('Nombre no disponible. Reintentar'),
        ),
      );
}
