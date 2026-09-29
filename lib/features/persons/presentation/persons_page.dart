import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_data_table.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/persons_controller.dart';
import '../data/person_models.dart';
import 'person_form.dart';

class PersonsPage extends ConsumerStatefulWidget {
  const PersonsPage({super.key});
  @override
  ConsumerState<PersonsPage> createState() => _PersonsPageState();
}

class _PersonDeleteDialog extends ConsumerStatefulWidget {
  const _PersonDeleteDialog({required this.persona});
  final Persona persona;
  @override
  ConsumerState<_PersonDeleteDialog> createState() => _PersonDeleteDialogState();
}

class _PersonDeleteDialogState extends ConsumerState<_PersonDeleteDialog> {
  bool _busy = false;

  Future<void> _delete() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await ref.read(personsRepositoryProvider).delete(widget.persona.id);
      if (mounted) Navigator.of(context).pop(true);
    } on Object {
      if (mounted) Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: AlertDialog(
      title: const Text('Eliminar persona'),
      content: Text(
        '¿Eliminar a «${widget.persona.fullName}»? Esta acción no se puede deshacer.',
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

class _PersonsPageState extends ConsumerState<PersonsPage> {
  int _page = 0;
  void _refresh() {
    ref.invalidate(personsPageProvider);
    ref.invalidate(personDetailProvider);
  }

  Future<void> _add() async {
    final saved = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PersonForm(),
    );
    if (saved == true && mounted) {
      _refresh();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Persona guardada.')));
    }
  }

  Future<void> _delete(Persona persona, int pageLength) async {
    final deleted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _PersonDeleteDialog(persona: persona),
    );
    if (deleted == true && mounted) {
      if (pageLength == 1 && _page > 0) setState(() => _page--);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = ref.watch(personsPageProvider(_page));
    return FeaturePage(
      title: 'Personas',
      description: 'Datos personales, de contacto y médicos de cada persona registrada.',
      actions: [
        AppButton(
          label: 'Agregar persona',
          icon: Icons.add,
          onPressed: _add,
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
            DataColumn(label: Text('Nombre completo')),
            DataColumn(label: Text('CURP')),
            DataColumn(label: Text('Correo')),
            DataColumn(label: Text('Teléfono')),
            DataColumn(label: Text('Acciones')),
          ],
          rows: [
            for (final persona in data.results)
              DataRow(
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
                          onPressed: () => context.go('/personas/${persona.id}'),
                          icon: const Icon(Icons.visibility_outlined),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        IconButton(
                          tooltip: 'Eliminar a ${persona.fullName}',
                          onPressed: () =>
                              _delete(persona, data.results.length),
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
