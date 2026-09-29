import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/network/api_page.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/loading_skeleton.dart';
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

class _AsignacionUbicacionDeleteDialog extends ConsumerStatefulWidget {
  const _AsignacionUbicacionDeleteDialog({required this.id});
  final String id;
  @override
  ConsumerState<_AsignacionUbicacionDeleteDialog> createState() =>
      _AsignacionUbicacionDeleteDialogState();
}

class _AsignacionUbicacionDeleteDialogState
    extends ConsumerState<_AsignacionUbicacionDeleteDialog> {
  bool _busy = false;

  Future<void> _delete() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(schedulesRepositoryProvider)
          .deleteAsignacionUbicacion(widget.id);
      if (mounted) Navigator.of(context).pop(true);
    } on Object {
      if (mounted) Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: AlertDialog(
      title: const Text('Eliminar asignación de ubicación'),
      content: const Text(
        '¿Eliminar esta asignación de ubicación? Esta acción no se puede deshacer.',
      ),
      actions: [
        AppButton(
          label: 'Cancelar',
          variant: AppButtonVariant.secondary,
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
        ),
        AppButton(
          label: 'Eliminar',
          variant: AppButtonVariant.danger,
          isLoading: _busy,
          onPressed: _delete,
        ),
      ],
    ),
  );
}

class _AsignacionesUbicacionPageState
    extends ConsumerState<AsignacionesUbicacionPage> {
  int _page = 0;

  void _refresh() {
    ref.invalidate(asignacionesUbicacionPageProvider);
  }

  Future<void> _addOrEdit([AsignacionUbicacion? asignacion]) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
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
    final deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AsignacionUbicacionDeleteDialog(id: id),
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
    final page = ref.watch(asignacionesUbicacionPageProvider(_page));
    return FeaturePage(
      title: 'Asignaciones de ubicación',
      description: 'La ubicación asignada a cada integrante del equipo.',
      tabs: const FeatureTabs(
        current: '/horarios/asignaciones-ubicacion',
        destinations: schedulesTabs,
      ),
      actions: [
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
      child: switch ((areas, catorcenas, page)) {
        (AsyncError(:final error), _, _) ||
        (_, AsyncError(:final error), _) ||
        (_, _, AsyncError(:final error)) => FeatureError(
          error: error,
          onRetry: _refresh,
        ),
        (
          AsyncData(value: final areasList),
          AsyncData(value: final catorcenasList),
          AsyncData(value: final page),
        ) =>
          _table(areasList, catorcenasList, page),
        _ => const FeatureLoading(),
      },
    );
  }

  Widget _table(
    List<AreaRef> areas,
    List<Catorcena> catorcenas,
    ApiPage<AsignacionUbicacion> page,
  ) => AppDataTable(
    columns: const [
      DataColumn(label: Text('Empleado')),
      DataColumn(label: Text('Área')),
      DataColumn(label: Text('Catorcena')),
      DataColumn(label: Text('Fecha de referencia')),
      DataColumn(label: Text('Acciones')),
    ],
    rows: [
      for (final asignacion in page.results)
        DataRow(
          cells: [
            DataCell(_EmpleadoCell(id: asignacion.empleado)),
            DataCell(tableText(nameInAreaRef(areas, asignacion.area))),
            DataCell(
              tableText(labelForCatorcena(catorcenas, asignacion.catorcena)),
            ),
            DataCell(
              Text(_displayDate.format(DateTime.parse(asignacion.fechaReferencia))),
            ),
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
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(empleadoRefProvider(id)).when(
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
