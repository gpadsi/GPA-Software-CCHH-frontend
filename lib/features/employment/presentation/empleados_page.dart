import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../application/employment_controller.dart';

// Empleados es de solo lectura en esta fase a propósito: crear uno
// requiere elegir una Persona ya existente entre 580+ (un buscador propio,
// no un selector simple) — no lo pide el plan de esta fase y se hubiera
// convertido en el trabajo más grande de todos. Se agrega cuando haga
// falta de verdad.
class EmpleadosPage extends ConsumerStatefulWidget {
  const EmpleadosPage({super.key});
  @override
  ConsumerState<EmpleadosPage> createState() => _EmpleadosPageState();
}

class _EmpleadosPageState extends ConsumerState<EmpleadosPage> {
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(empleadosPageProvider(_page));
    return FeaturePage(
      title: 'Empleados',
      description: 'Relación laboral, contrato y posición de cada empleado.',
      actions: [
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: () => ref.invalidate(empleadosPageProvider),
        ),
      ],
      child: page.when(
        skipLoadingOnRefresh: false,
        loading: () => const FeatureLoading(),
        error: (error, _) =>
            FeatureError(error: error, onRetry: () => ref.invalidate(empleadosPageProvider)),
        data: (data) => AppDataTable(
          columns: const [
            DataColumn(label: Text('Número de nómina')),
            DataColumn(label: Text('Persona')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: [
            for (final empleado in data.results)
              DataRow(
                cells: [
                  DataCell(tableText(empleado.workNumber)),
                  DataCell(_PersonaName(personaId: empleado.persona)),
                  DataCell(
                    IconButton(
                      tooltip: 'Ver empleado',
                      onPressed: () => context.go('/empleados/${empleado.id}'),
                      icon: const Icon(Icons.visibility_outlined),
                    ),
                  ),
                ],
              ),
          ],
          totalCount: data.count,
          pageIndex: _page,
          pageSize: 25,
          onPageChanged: (value) => setState(() => _page = value),
        ),
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
