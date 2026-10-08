import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/form_panel.dart';
import '../../../core/widgets/search_picker_field.dart';
import '../application/recruitment_controller.dart';
import '../data/recruitment_models.dart';
import '../data/recruitment_repository.dart';
import 'posicion_contexto_card.dart';

/// Abre un borrador de Descriptivo de puesto para una Posición: el sistema lo
/// precarga con lo que ya sabe (puesto, empresa, unidad, a quién reporta) y
/// se termina de llenar en el editor. Se cierra con el borrador creado.
class NuevoDescriptivoForm extends ConsumerStatefulWidget {
  const NuevoDescriptivoForm({super.key, this.posicionId});
  final String? posicionId;

  @override
  ConsumerState<NuevoDescriptivoForm> createState() =>
      _NuevoDescriptivoFormState();
}

class _NuevoDescriptivoFormState extends ConsumerState<NuevoDescriptivoForm> {
  PosicionElegible? _posicionElegida;
  late String? _posicionContextoId = widget.posicionId;
  late bool _selectorVisible = widget.posicionId == null;
  PosicionElegible? get _posicion =>
      _posicionElegida ??
      (_posicionContextoId == null
          ? null
          : ref
                .read(
                  posicionContextoProvider((
                    _posicionContextoId!,
                    'descriptivo',
                  )),
                )
                .value
                ?.elegible);
  String? _posicionError;
  int _posicionAttention = 0;
  bool _busy = false;
  String? _error;

  Future<void> _save() async {
    if (_busy) return;
    final posicion = _posicion;
    if (_posicionContextoId != null && posicion == null) return;
    if (posicion == null) {
      setState(() {
        _posicionError = 'Elige la posición de la lista.';
        _posicionAttention++;
      });
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final repository = ref.read(recruitmentRepositoryProvider);
      final borradorId = posicion.tramiteAbierto?.id;
      final creado = borradorId == null
          ? await repository.crearBorrador(posicion.id)
          : await repository.descriptivo(borradorId);
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
  Widget build(BuildContext context) {
    if (_posicionContextoId != null) {
      ref.watch(
        posicionContextoProvider((_posicionContextoId!, 'descriptivo')),
      );
    }
    return AppFormPanel(
      title: 'Nuevo descriptivo de puesto',
      saveLabel: _posicion?.tramiteAbierto == null
          ? 'Crear borrador'
          : 'Continuar borrador',
      busy: _busy,
      canSave: _posicionContextoId == null || _posicion != null,
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
          if (_selectorVisible)
            SearchPickerField<PosicionElegible>(
              label: 'Posición',
              hint: 'Escribe puesto, unidad o área',
              enabled: !_busy,
              suggestOnFocus: true,
              errorText: _posicionError,
              attention: _posicionAttention,
              search: (text) => ref
                  .read(recruitmentRepositoryProvider)
                  .posicionesElegibles(para: 'descriptivo', search: text),
              labelOf: (posicion) => posicion.etiqueta,
              detailOf: (posicion) => [
                posicion.estatus,
                if (posicion.area != null) posicion.area!,
              ].join(' · '),
              badgeOf: (posicion) =>
                  posicion.tramiteAbierto == null ? null : 'Borrador abierto',
              onChanged: (posicion) => setState(() {
                _posicionElegida = posicion;
                _posicionContextoId = posicion?.id;
                if (posicion != null && widget.posicionId != null) {
                  _selectorVisible = false;
                }
                _posicionError = null;
              }),
            ),
          if (_posicionContextoId != null) ...[
            if (_selectorVisible) const SizedBox(height: AppSpacing.md),
            PosicionContextoCard(
              posicionId: _posicionContextoId!,
              para: 'descriptivo',
            ),
            if (widget.posicionId != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() {
                          _posicionElegida = null;
                          _posicionContextoId = null;
                          _posicionError = null;
                          _selectorVisible = true;
                        }),
                  child: const Text('Cambiar posición'),
                ),
              ),
          ],
          const SizedBox(height: AppSpacing.md),
          Text(
            'Una posición solo puede tener un borrador abierto a la vez; si ya hay uno, ábrelo desde la lista.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
