import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/form_dialog.dart';
import '../application/positions_controller.dart';
import '../data/position_models.dart';
import '../data/positions_repository.dart';

class PuestoForm extends ConsumerStatefulWidget {
  const PuestoForm({super.key, this.puesto});
  final PositionCatalogEntry? puesto;
  @override
  ConsumerState<PuestoForm> createState() => _PuestoFormState();
}

class _PuestoFormState extends ConsumerState<PuestoForm>
    with FormChangeTracking {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.puesto?.name);
  late bool _active = widget.puesto?.isActive ?? true;
  late bool _gerencia = widget.puesto?.esGerenciaDeUnidad ?? false;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    watchChanges([_name]);
  }

  @override
  bool get hasChanges {
    final current = widget.puesto;
    return _name.text != (current?.name ?? '') ||
        _active != (current?.isActive ?? true) ||
        _gerencia != (current?.esGerenciaDeUnidad ?? false);
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final current = widget.puesto;
    try {
      await ref
          .read(positionsRepositoryProvider)
          .savePuesto(
            PositionCatalogEntry(
              id: current?.id ?? 0,
              code: current?.code ?? '',
              name: _name.text.trim(),
              isActive: _active,
              esGerenciaDeUnidad: _gerencia,
            ),
            creating: current == null,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = puestoMutationError(error);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final small = Theme.of(context).textTheme.bodySmall;
    return AppFormDialog(
      title: widget.puesto == null ? 'Agregar puesto' : 'Editar puesto',
      subtitle: 'Un puesto del catálogo de Grupo GPA; las posiciones lo usan.',
      dirty: hasChanges,
      busy: _busy,
      error: _error,
      onSave: _save,
      child: Form(
        key: _form,
        child: AppFormSection(
          first: true,
          children: [
            AppTextField(
              label: 'Nombre',
              hint: 'Ej. Almacenista Senior',
              controller: _name,
              enabled: !_busy,
              autofocus: widget.puesto == null,
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return 'Este dato es obligatorio.';
                if (text.length > 150) return 'Usa como máximo 150 caracteres.';
                return null;
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Activo'),
              subtitle: Text(
                'Desactívalo cuando el puesto ya no se use. No se borra porque hay posiciones que lo tienen.',
                style: small,
              ),
              value: _active,
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _active = value),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Es gerencia de la unidad'),
              subtitle: Text(
                'Quien ocupe una posición con este puesto pasa a ser el jefe de todas las demás posiciones de su misma unidad y ubicación. Márcalo solo si GPA confirmó que este puesto cumple ese rol.',
                style: small,
              ),
              value: _gerencia,
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _gerencia = value),
            ),
          ],
        ),
      ),
    );
  }
}
