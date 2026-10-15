import 'package:flutter/material.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_date_field.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/form_dialog.dart';
import '../data/recruitment_repository.dart';
import 'recruitment_ui.dart';

/// Suspende una requisición: motivo, fecha y quién lo autorizó. Se cierra con
/// true cuando el servidor aceptó la suspensión.
class RequisicionSuspensionDialog extends StatefulWidget {
  const RequisicionSuspensionDialog({super.key, required this.onSuspend});

  final Future<void> Function(String motivo, String fecha, String autorizadoPor)
  onSuspend;

  @override
  State<RequisicionSuspensionDialog> createState() =>
      _RequisicionSuspensionDialogState();
}

class _RequisicionSuspensionDialogState
    extends State<RequisicionSuspensionDialog> {
  final _form = GlobalKey<FormState>();
  final _motivo = TextEditingController();
  final _autorizado = TextEditingController();
  late final _hoy = DateUtils.dateOnly(DateTime.now());
  late DateTime? _fecha = _hoy;
  bool _busy = false;
  String? _error;

  bool get _changed =>
      _motivo.text.isNotEmpty || _autorizado.text.isNotEmpty || _fecha != _hoy;

  @override
  void dispose() {
    _motivo.dispose();
    _autorizado.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onSuspend(
        _motivo.text.trim(),
        toIsoDate(_fecha!),
        _autorizado.text.trim(),
      );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = recruitmentMutationError(error);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AppFormDialog(
    title: 'Suspender requisición',
    size: AppDialogSize.small,
    saveLabel: 'Suspender',
    busy: _busy,
    error: _error,
    dirty: _changed,
    discardMessage: '¿Descartar los datos de suspensión que capturaste?',
    onSave: _save,
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Motivo',
            controller: _motivo,
            enabled: !_busy,
            maxLines: null,
            minLines: 2,
            onChanged: (_) => setState(() {}),
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Escribe el motivo.'
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          AppDateField(
            label: 'Fecha de suspensión',
            value: _fecha,
            enabled: !_busy,
            isRequired: true,
            onChanged: (value) => setState(() => _fecha = value),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Autorizado por',
            controller: _autorizado,
            enabled: !_busy,
            onChanged: (_) => setState(() {}),
            validator: (value) => (value?.trim().length ?? 0) > 150
                ? 'Usa como máximo 150 caracteres.'
                : null,
          ),
        ],
      ),
    ),
  );
}
