import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/form_panel.dart';
import '../../../core/widgets/search_picker_field.dart';
import '../application/recruitment_controller.dart';
import '../data/recruitment_models.dart';
import '../data/recruitment_repository.dart';

/// Abre un borrador de Descriptivo de puesto para una Posición: el sistema lo
/// precarga con lo que ya sabe (puesto, empresa, unidad, a quién reporta) y
/// se termina de llenar en el editor. Se cierra con el borrador creado.
class NuevoDescriptivoForm extends ConsumerStatefulWidget {
  const NuevoDescriptivoForm({super.key});

  @override
  ConsumerState<NuevoDescriptivoForm> createState() =>
      _NuevoDescriptivoFormState();
}

class _NuevoDescriptivoFormState extends ConsumerState<NuevoDescriptivoForm> {
  PosicionRef? _posicion;
  String? _posicionError;
  bool _busy = false;
  String? _error;

  Future<void> _save() async {
    if (_busy) return;
    final posicion = _posicion;
    if (posicion == null) {
      setState(() => _posicionError = 'Elige la posición de la lista.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final creado = await ref
          .read(recruitmentRepositoryProvider)
          .crearBorrador(posicion.id);
      if (mounted) Navigator.of(context).pop(creado);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = recruitmentMutationError(error);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AppFormPanel(
    title: 'Nuevo descriptivo de puesto',
    saveLabel: 'Crear borrador',
    busy: _busy,
    error: _error,
    onSave: _save,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Elige la posición a la que corresponde. El borrador se abre con lo que el sistema ya sabe y lo terminas de llenar enseguida.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        SearchPickerField<PosicionRef>(
          label: 'Posición',
          hint: 'Escribe puesto, unidad o área',
          enabled: !_busy,
          errorText: _posicionError,
          search: (text) =>
              ref.read(recruitmentRepositoryProvider).searchPosiciones(text),
          labelOf: (posicion) => posicion.etiqueta,
          onChanged: (posicion) => setState(() {
            _posicion = posicion;
            _posicionError = null;
          }),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Una posición solo puede tener un borrador abierto a la vez; si ya hay uno, ábrelo desde la lista.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}
