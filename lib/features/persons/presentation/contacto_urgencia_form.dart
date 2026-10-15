import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/form_dialog.dart';
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

class _ContactoUrgenciaFormState extends ConsumerState<ContactoUrgenciaForm>
    with FormChangeTracking {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.contacto?.name);
  late final _relationship = TextEditingController(
    text: widget.contacto?.relationship,
  );
  late final _phone = TextEditingController(text: widget.contacto?.phone);
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    watchChanges([_name, _relationship, _phone]);
  }

  @override
  bool get hasChanges {
    final current = widget.contacto;
    return _name.text != (current?.name ?? '') ||
        _relationship.text != (current?.relationship ?? '') ||
        _phone.text != (current?.phone ?? '');
  }

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
  Widget build(BuildContext context) => AppFormDialog(
    title: widget.contacto == null
        ? 'Agregar contacto de urgencia'
        : 'Editar contacto de urgencia',
    subtitle: 'A quién llamar si le pasa algo a esta persona.',
    size: AppDialogSize.small,
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
            controller: _name,
            enabled: !_busy,
            autofocus: widget.contacto == null,
            validator: _required,
          ),
          AppFieldGrid(
            minTwoColumnWidth: 400,
            children: [
              AppTextField(
                label: 'Parentesco',
                hint: 'Ej. Madre',
                controller: _relationship,
                enabled: !_busy,
                validator: _required,
              ),
              AppTextField(
                label: 'Teléfono',
                controller: _phone,
                enabled: !_busy,
                keyboardType: TextInputType.phone,
                validator: _required,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
