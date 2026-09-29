import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/schedules_controller.dart';
import '../data/schedule_models.dart';
import 'catorcena_form.dart';

const schedulesTabs = [
  (label: 'Catorcenas', path: '/horarios/catorcenas'),
  (label: 'Tipos de horario', path: '/horarios/tipos'),
  (label: 'Asignaciones de horario', path: '/horarios/asignaciones-horario'),
  (label: 'Asignaciones de ubicación', path: '/horarios/asignaciones-ubicacion'),
];

final _displayDate = DateFormat.yMMMd('es_MX');

class CatorcenasPage extends ConsumerStatefulWidget {
  const CatorcenasPage({super.key});
  @override
  ConsumerState<CatorcenasPage> createState() => _CatorcenasPageState();
}

class _CatorcenaDeleteDialog extends ConsumerStatefulWidget {
  const _CatorcenaDeleteDialog({required this.catorcena});
  final Catorcena catorcena;
  @override
  ConsumerState<_CatorcenaDeleteDialog> createState() =>
      _CatorcenaDeleteDialogState();
}

class _CatorcenaDeleteDialogState extends ConsumerState<_CatorcenaDeleteDialog> {
  bool _busy = false;

  Future<void> _delete() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(schedulesRepositoryProvider)
          .deleteCatorcena(widget.catorcena.id);
      if (mounted) Navigator.of(context).pop(true);
    } on Object {
      if (mounted) Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: AlertDialog(
      title: const Text('Eliminar catorcena'),
      content: Text(
        '¿Eliminar la catorcena ${widget.catorcena.numero}/${widget.catorcena.anio}? '
        'Esta acción no se puede deshacer.',
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

class _CatorcenasPageState extends ConsumerState<CatorcenasPage> {
  int _page = 0;

  void _refresh() {
    ref.invalidate(catorcenasPageProvider);
    ref.invalidate(allCatorcenasProvider);
  }

  Future<void> _addOrEdit([Catorcena? catorcena]) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CatorcenaForm(catorcena: catorcena),
    );
    if (saved == true && mounted) {
      _refresh();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Catorcena guardada.')));
    }
  }

  Future<void> _delete(Catorcena catorcena, int pageLength) async {
    final deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CatorcenaDeleteDialog(catorcena: catorcena),
    );
    if (deleted == true && mounted) {
      if (pageLength == 1 && _page > 0) setState(() => _page--);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(catorcenasPageProvider(_page));
    return FeaturePage(
      title: 'Catorcenas',
      description: 'Los periodos de catorcena que organizan la nómina y el calendario laboral.',
      tabs: const FeatureTabs(
        current: '/horarios/catorcenas',
        destinations: schedulesTabs,
      ),
      actions: [
        AppButton(
          label: 'Agregar catorcena',
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
      child: page.when(
        skipLoadingOnRefresh: false,
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(error: error, onRetry: _refresh),
        data: (data) => AppDataTable(
          columns: const [
            DataColumn(label: Text('Catorcena')),
            DataColumn(label: Text('Fecha de inicio')),
            DataColumn(label: Text('Fecha de fin')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: [
            for (final catorcena in data.results)
              DataRow(
                cells: [
                  DataCell(Text('${catorcena.numero}/${catorcena.anio}')),
                  DataCell(
                    Text(_displayDate.format(DateTime.parse(catorcena.fechaInicio))),
                  ),
                  DataCell(
                    Text(_displayDate.format(DateTime.parse(catorcena.fechaFin))),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Editar catorcena',
                          onPressed: () => _addOrEdit(catorcena),
                          icon: const Icon(Icons.edit_outlined),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        IconButton(
                          tooltip: 'Eliminar catorcena',
                          onPressed: () =>
                              _delete(catorcena, data.results.length),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
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
