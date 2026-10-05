import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/app_overlays.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/network/table_query.dart';
import '../../../core/widgets/app_fade_switcher.dart';
import '../../../core/widgets/app_table_toolbar.dart';
import '../application/persons_controller.dart';
import '../data/person_models.dart';
import 'person_form.dart';

class PersonsPage extends ConsumerStatefulWidget {
  const PersonsPage({super.key});
  @override
  ConsumerState<PersonsPage> createState() => _PersonsPageState();
}

class _PersonsPageState extends ConsumerState<PersonsPage> {
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
  void _refresh() {
    ref.invalidate(personsPageProvider);
    ref.invalidate(personDetailProvider);
  }

  Future<void> _addOrEdit([Persona? persona]) async {
    final saved = await showAppPanel<bool>(
      context: context,
      builder: (_) => PersonForm(persona: persona),
    );
    if (saved == true && mounted) {
      _refresh();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Persona guardada.')));
    }
  }

  Future<void> _delete(Persona persona, int pageLength) async {
    final deleted = await showConfirmDialog(
      context,
      title: 'Eliminar persona',
      message:
          '¿Eliminar a «${persona.fullName}»? Esta acción no se puede deshacer.',
      details: deleteLinkedRecordsHint,
      onConfirm: () => ref.read(personsRepositoryProvider).delete(persona.id),
    );
    if (deleted == true && mounted) {
      if (pageLength == 1 && _page > 0) setState(() => _page--);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(personsPageProvider(_page, query: _query));
    final canManage = ref.watch(canManageHrProvider);
    return FeaturePage(
      title: 'Personas',
      description:
          'Datos personales, de contacto y médicos de cada persona registrada.',
      actions: [
        if (canManage)
          AppButton(
            label: 'Agregar persona',
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTableToolbar(
            hint: 'Buscar por nombre, CURP, correo o teléfono',
            value: _query.search,
            onSearch: _search,
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
                  DataColumn(label: Text('Nombre completo')),
                  DataColumn(label: Text('CURP')),
                  DataColumn(label: Text('Correo')),
                  DataColumn(label: Text('Teléfono')),
                  DataColumn(label: Text('Acciones')),
                ],
                rows: [
                  for (final persona in data.results)
                    DataRow(
                      // Clic en la fila = abrir el expediente (los íconos siguen
                      // ahí para teclado y lectores de pantalla).
                      onSelectChanged: (_) =>
                          context.go('/personas/${persona.id}'),
                      cells: [
                        DataCell(
                          tableText(
                            persona.fullName,
                            fallback: 'Nombre no capturado',
                          ),
                        ),
                        DataCell(tableText(persona.curp)),
                        DataCell(tableText(persona.personalEmail)),
                        DataCell(tableText(persona.phone)),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Ver a ${persona.fullName}',
                                onPressed: () =>
                                    context.go('/personas/${persona.id}'),
                                icon: const Icon(Icons.visibility_outlined),
                              ),
                              if (canManage) ...[
                                const SizedBox(width: AppSpacing.xs),
                                IconButton(
                                  tooltip: 'Editar a ${persona.fullName}',
                                  onPressed: () => _addOrEdit(persona),
                                  icon: const Icon(Icons.edit_outlined),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                IconButton(
                                  tooltip: 'Eliminar a ${persona.fullName}',
                                  onPressed: () =>
                                      _delete(persona, data.results.length),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
                sortFields: [
                  'last_name_paternal,last_name_maternal,first_name',
                  'curp',
                  'personal_email',
                  'phone',
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
