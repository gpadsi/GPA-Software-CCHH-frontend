import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/form_dialog.dart';
import '../application/employment_controller.dart';
import '../data/employment_models.dart';
import '../data/employment_repository.dart';
import 'persona_picker_field.dart';

/// Alta de un empleado (sin [empleado]: se elige la persona) o cambio de su
/// número de nómina. A quién corresponde el expediente no se cambia al
/// editar: se muestra, pero no se puede reasignar.
class EmpleadoForm extends ConsumerStatefulWidget {
  const EmpleadoForm({super.key, this.empleado});
  final Empleado? empleado;

  @override
  ConsumerState<EmpleadoForm> createState() => _EmpleadoFormState();
}

class _EmpleadoFormState extends ConsumerState<EmpleadoForm>
    with FormChangeTracking {
  final _form = GlobalKey<FormState>();
  late final _workNumber = TextEditingController(
    text: widget.empleado?.workNumber,
  );
  PersonSummary? _persona;
  String? _personaError;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    watchChanges([_workNumber]);
  }

  @override
  bool get hasChanges =>
      _persona != null ||
      _workNumber.text != (widget.empleado?.workNumber ?? '');

  @override
  void dispose() {
    _workNumber.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy) return;
    final creating = widget.empleado == null;
    final valid = _form.currentState!.validate();
    if (creating && _persona == null) {
      setState(() => _personaError = 'Elige a la persona de la lista.');
      return;
    }
    if (!valid) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final current = widget.empleado;
    try {
      await ref
          .read(employmentRepositoryProvider)
          .save(
            Empleado(
              id: current?.id ?? '',
              persona: current?.persona ?? _persona!.id,
              workNumber: _workNumber.text,
            ),
            creating: creating,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = empleadoMutationError(error);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.empleado;
    return AppFormDialog(
      title: current == null ? 'Agregar empleado' : 'Editar empleado',
      subtitle: current == null
          ? 'Elige a la persona que entra a trabajar; su expediente ya debe existir en Personas.'
          : null,
      dirty: hasChanges,
      // La lista de personas se abre bajo el campo: que quepa en la ventana.
      minBodyHeight: current == null ? 400 : null,
      busy: _busy,
      error: _error,
      onSave: _save,
      child: Form(
        key: _form,
        child: AppFormSection(
          first: true,
          children: [
            if (current == null)
              PersonaPickerField(
                enabled: !_busy,
                errorText: _personaError,
                onChanged: (persona) => setState(() {
                  _persona = persona;
                  _personaError = null;
                }),
              )
            else
              InputDecorator(
                decoration: const InputDecoration(labelText: 'Persona'),
                child: ref
                    .watch(personSummaryProvider(current.persona))
                    .when(
                      data: (persona) => Text(
                        persona.fullName.isEmpty
                            ? 'Persona sin nombre'
                            : persona.fullName,
                      ),
                      loading: () => const Text('Cargando…'),
                      error: (_, _) => const Text('Nombre no disponible'),
                    ),
              ),
            AppTextField(
              label: 'Número de nómina (opcional)',
              controller: _workNumber,
              enabled: !_busy,
              helper: current == null
                  ? 'Si todavía no tiene número de nómina, déjalo vacío y captúralo después.'
                  : 'Cambiar el número de nómina no afecta su contrato ni su posición.',
              validator: (value) => (value?.trim().length ?? 0) > 30
                  ? 'Usa como máximo 30 caracteres.'
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
