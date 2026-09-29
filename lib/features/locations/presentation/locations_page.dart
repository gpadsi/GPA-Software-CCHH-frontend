import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/locations_controller.dart';
import '../data/location_models.dart';
import 'location_form.dart';

class LocationsPage extends ConsumerStatefulWidget {
  const LocationsPage({super.key, required this.kind});
  final LocationKind kind;
  @override
  ConsumerState<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends ConsumerState<LocationsPage> {
  int _page = 0;
  void _refresh() {
    ref.invalidate(locationPageProvider);
    ref.invalidate(locationCatalogProvider);
  }

  Future<void> _edit([LocationRecord? record]) async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => LocationForm(kind: widget.kind, record: record),
    );
    if (saved == true && mounted) {
      _refresh();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Registro guardado.')));
    }
  }

  Future<void> _delete(LocationRecord record, int pageLength) async {
    final deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => LocationDeleteDialog(kind: widget.kind, record: record),
    );
    if (deleted == true && mounted) {
      if (pageLength == 1 && _page > 0) setState(() => _page--);
      _refresh();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Registro eliminado.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final kind = widget.kind;
    final page = ref.watch(locationPageProvider(kind, _page));
    final catalog = kind == LocationKind.ubicaciones
        ? const AsyncData(LocationCatalog(ubicaciones: [], naves: []))
        : ref.watch(locationCatalogProvider);
    final path = kind == LocationKind.ubicaciones
        ? '/ubicaciones'
        : '/ubicaciones/${kind.name}';
    return FeaturePage(
      title: kind.label,
      description: switch (kind) {
        LocationKind.ubicaciones =>
          'Administra los centros de trabajo y su registro patronal.',
        LocationKind.naves =>
          'Cada nave pertenece a una ubicación. Su nombre es opcional.',
        LocationKind.areas => 'Cada área puede vincularse a una nave; las que siguen sin confirmar se muestran como pendientes.',
      },
      tabs: FeatureTabs(
        current: path,
        destinations: const [
          (label: 'Ubicaciones', path: '/ubicaciones'),
          (label: 'Naves', path: '/ubicaciones/naves'),
          (label: 'Áreas', path: '/ubicaciones/areas'),
        ],
      ),
      actions: [
        AppButton(
          label: 'Agregar ${kind.singular}',
          icon: Icons.add,
          onPressed: _edit,
        ),
        AppButton(
          label: 'Actualizar',
          icon: Icons.refresh,
          variant: AppButtonVariant.secondary,
          onPressed: _refresh,
        ),
      ],
      child: catalog.when(
        skipLoadingOnRefresh: false,
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(error: error, onRetry: _refresh),
        data: (references) => page.when(
          skipLoadingOnRefresh: false,
          loading: () => const FeatureLoading(),
          error: (error, _) => FeatureError(error: error, onRetry: _refresh),
          data: (data) => AppDataTable(
            columns: [
              const DataColumn(label: Text('Código')),
              const DataColumn(label: Text('Nombre')),
              if (kind != LocationKind.ubicaciones)
                const DataColumn(label: Text('Ubicación')),
              if (kind == LocationKind.areas)
                const DataColumn(label: Text('Nave')),
              if (kind == LocationKind.ubicaciones)
                const DataColumn(label: Text('Registro patronal')),
              const DataColumn(label: Text('Estado')),
              const DataColumn(label: Text('Acciones')),
            ],
            rows: [
              for (final record in data.results)
                DataRow(
                  cells: [
                    DataCell(tableText(record.code)),
                    DataCell(
                      tableText(record.name, fallback: 'Sin nombre capturado'),
                    ),
                    if (kind != LocationKind.ubicaciones)
                      DataCell(
                        tableText(
                          kind == LocationKind.naves
                              ? references.ubicacionName(record.ubicacion)
                              : record.nave == null
                              ? 'Pendiente'
                              : references.ubicacionName(
                                  references.naveById(record.nave)?.ubicacion,
                                ),
                        ),
                      ),
                    if (kind == LocationKind.areas)
                      DataCell(
                        tableText(
                          record.nave == null
                              ? 'Sin nave confirmada'
                              : references.naveById(record.nave)?.displayName,
                          fallback: 'Nave no disponible',
                        ),
                      ),
                    if (kind == LocationKind.ubicaciones)
                      DataCell(tableText(record.employerRegistration)),
                    DataCell(
                      AppBadge(
                        label: record.isActive ? 'Activo' : 'Inactivo',
                        tone: record.isActive
                            ? AppBadgeTone.success
                            : AppBadgeTone.neutral,
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Editar ${record.code}',
                            onPressed: () => _edit(record),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          IconButton(
                            tooltip: 'Eliminar ${record.code}',
                            onPressed: () =>
                                _delete(record, data.results.length),
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
      ),
    );
  }
}
