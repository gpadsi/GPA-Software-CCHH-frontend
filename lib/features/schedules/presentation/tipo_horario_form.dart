import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/form_panel.dart';
import '../application/schedules_controller.dart';
import '../data/schedule_models.dart';
import '../data/schedules_repository.dart';

class TipoHorarioForm extends ConsumerStatefulWidget {
  const TipoHorarioForm({super.key, this.tipo});
  final TipoHorarioRef? tipo;
  @override
  ConsumerState<TipoHorarioForm> createState() => _TipoHorarioFormState();
}

class _TipoHorarioFormState extends ConsumerState<TipoHorarioForm> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.tipo?.name);
  late final _descripcion = TextEditingController(
    text: widget.tipo?.descripcion,
  );
  late bool _active = widget.tipo?.isActive ?? true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final current = widget.tipo;
    try {
      await ref
          .read(schedulesRepositoryProvider)
          .saveTipoHorario(
            TipoHorarioRef(
              id: current?.id ?? 0,
              code: current?.code ?? '',
              name: _name.text.trim(),
              descripcion: _descripcion.text.trim(),
              isActive: _active,
            ),
            creating: current == null,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = tipoHorarioMutationError(error);
          _busy = false;
        });
      }
    }
  }

  String? _validate(String? value, int limit, {bool required = true}) {
    final text = value?.trim() ?? '';
    if (required && text.isEmpty) return 'Este dato es obligatorio.';
    if (text.length > limit) return 'Usa como máximo $limit caracteres.';
    return null;
  }

  @override
  Widget build(BuildContext context) => AppFormPanel(
    title: widget.tipo == null
        ? 'Agregar tipo de horario'
        : 'Editar tipo de horario',
    busy: _busy,
    error: _error,
    onSave: _save,
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Nombre (ej. H01)',
            controller: _name,
            enabled: !_busy,
            validator: (value) => _validate(value, 150),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Horario (opcional)',
            hint: 'Ej. 07:00 - 16:00',
            controller: _descripcion,
            enabled: !_busy,
            validator: (value) => _validate(value, 255, required: false),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Escríbelo como lo maneja GPA. Si el código rota entre varios rangos, sepáralos con «/».',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.md),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Activo'),
            subtitle: Text(
              'Desactívalo cuando el horario ya no se use. No se borra porque hay asignaciones que lo tienen.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            value: _active,
            onChanged: _busy
                ? null
                : (value) => setState(() => _active = value),
          ),
        ],
      ),
    ),
  );
}
