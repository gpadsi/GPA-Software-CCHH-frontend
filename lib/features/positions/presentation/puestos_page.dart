import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/positions_controller.dart';
import 'positions_page.dart';

class PuestosPage extends ConsumerWidget {
  const PuestosPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogs = ref.watch(positionCatalogsProvider);
    return FeaturePage(
      title: 'Puestos',
      description: 'El catálogo de puestos de Grupo GPA.',
      tabs: const FeatureTabs(
        current: '/posiciones/puestos',
        destinations: positionsTabs,
      ),
      actions: [
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: () => ref.invalidate(positionCatalogsProvider),
        ),
      ],
      child: catalogs.when(
        skipLoadingOnRefresh: false,
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(
          error: error,
          onRetry: () => ref.invalidate(positionCatalogsProvider),
        ),
        data: (catalogs) => AppDataTable(
          columns: const [
            DataColumn(label: Text('Código')),
            DataColumn(label: Text('Nombre')),
            DataColumn(label: Text('Estatus')),
          ],
          rows: [
            for (final puesto in catalogs.puestos)
              DataRow(
                cells: [
                  DataCell(Text(puesto.code)),
                  DataCell(Text(puesto.name)),
                  DataCell(
                    AppBadge(
                      label: puesto.isActive ? 'Activo' : 'Inactivo',
                      tone: puesto.isActive
                          ? AppBadgeTone.success
                          : AppBadgeTone.neutral,
                    ),
                  ),
                ],
              ),
          ],
          totalCount: catalogs.puestos.length,
          pageIndex: 0,
          pageSize: catalogs.puestos.isEmpty ? 1 : catalogs.puestos.length,
          onPageChanged: null,
        ),
      ),
    );
  }
}
