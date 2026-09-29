import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/schedules_controller.dart';
import 'catorcenas_page.dart';

class TiposHorarioPage extends ConsumerWidget {
  const TiposHorarioPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(tiposHorarioCatalogProvider);
    return FeaturePage(
      title: 'Tipos de horario',
      description: 'Consulta las modalidades de horario de la organización.',
      tabs: const FeatureTabs(
        current: '/horarios/tipos',
        destinations: schedulesTabs,
      ),
      actions: [
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: () => ref.invalidate(tiposHorarioCatalogProvider),
        ),
      ],
      child: catalog.when(
        skipLoadingOnRefresh: false,
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(
          error: error,
          onRetry: () => ref.invalidate(tiposHorarioCatalogProvider),
        ),
        data: (tipos) => AppDataTable(
          columns: const [
            DataColumn(label: Text('Código')),
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Horario')),
            DataColumn(label: Text('Estatus')),
          ],
          rows: [
            for (final tipo in tipos)
              DataRow(
                cells: [
                  DataCell(Text(tipo.code)),
                  DataCell(Text(tipo.name)),
                  DataCell(
                    tableText(tipo.descripcion, fallback: 'Sin capturar'),
                  ),
                  DataCell(
                    AppBadge(
                      label: tipo.isActive ? 'Activo' : 'Inactivo',
                      tone: tipo.isActive
                          ? AppBadgeTone.success
                          : AppBadgeTone.neutral,
                    ),
                  ),
                ],
              ),
          ],
          totalCount: tipos.length,
          pageIndex: 0,
          pageSize: tipos.isEmpty ? 1 : tipos.length,
          onPageChanged: null,
        ),
      ),
    );
  }
}
