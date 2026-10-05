import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/form_panel.dart';
import '../application/persons_controller.dart';
import '../data/person_models.dart';

class ContactoUrgenciaForm extends ConsumerStatefulWidget {
  const ContactoUrgenciaForm({
    super.key,
    required this.personaId,
    this.contacto,
  });
  final String personaId;
  final ContactoUrgencia? contacto;
  @override
  ConsumerState<ContactoUrgenciaForm> createState() =>
      _ContactoUrgenciaFormState();
}

class _ContactoUrgenciaFormState extends ConsumerState<ContactoUrgenciaForm> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.contacto?.name);
  late final _relationship = TextEditingController(
    text: widget.contacto?.relationship,
  );
  late final _phone = TextEditingController(text: widget.contacto?.phone);
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _relationship.dispose();
    _phone.dispose();
    super.dispose();
  }

  String? _required(String? value) => value == null || value.trim().isEmpty
      ? 'Este dato es obligatorio.'
      : null;

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(personsRepositoryProvider)
          .saveContacto(
            ContactoUrgencia(
              id: widget.contacto?.id ?? '',
              persona: widget.personaId,
              name: _name.text.trim(),
              relationship: _relationship.text.trim(),
              phone: _phone.text.trim(),
            ),
            creating: widget.contacto == null,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = apiErrorMessage(error);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AppFormPanel(
    title: widget.contacto == null
        ? 'Agregar contacto de urgencia'
        : 'Editar contacto de urgencia',
    busy: _busy,
    error: _error,
    onSave: _save,
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Nombre',
            controller: _name,
            enabled: !_busy,
            validator: _required,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Parentesco',
            controller: _relationship,
            enabled: !_busy,
            validator: _required,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Teléfono',
            controller: _phone,
            enabled: !_busy,
            validator: _required,
          ),
        ],
      ),
    ),
  );
}
