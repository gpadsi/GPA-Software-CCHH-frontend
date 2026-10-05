import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/form_panel.dart';
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

class _EmpleadoFormState extends ConsumerState<EmpleadoForm> {
  final _form = GlobalKey<FormState>();
  late final _workNumber = TextEditingController(
    text: widget.empleado?.workNumber,
  );
  PersonSummary? _persona;
  String? _personaError;
  bool _busy = false;
  String? _error;

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
    return AppFormPanel(
      title: current == null ? 'Agregar empleado' : 'Editar empleado',
      busy: _busy,
      error: _error,
      onSave: _save,
      child: Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Número de nómina (opcional)',
              controller: _workNumber,
              enabled: !_busy,
              validator: (value) => (value?.trim().length ?? 0) > 30
                  ? 'Usa como máximo 30 caracteres.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              current == null
                  ? 'Si todavía no tiene número de nómina, déjalo vacío y captúralo después.'
                  : 'Cambiar el número de nómina no afecta su contrato ni su posición.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
