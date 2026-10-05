import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/form_panel.dart';
import '../application/persons_controller.dart';
import '../data/person_models.dart';

final _isoDate = DateFormat('yyyy-MM-dd');
final _displayDate = DateFormat.yMMMd('es_MX');

class PersonForm extends ConsumerStatefulWidget {
  const PersonForm({super.key, this.persona});
  final Persona? persona;
  @override
  ConsumerState<PersonForm> createState() => _PersonFormState();
}

class _PersonFormState extends ConsumerState<PersonForm> {
  final _form = GlobalKey<FormState>();
  late final _firstName = TextEditingController(
    text: widget.persona?.firstName,
  );
  late final _lastNamePaternal = TextEditingController(
    text: widget.persona?.lastNamePaternal,
  );
  late final _lastNameMaternal = TextEditingController(
    text: widget.persona?.lastNameMaternal,
  );
  late final _curp = TextEditingController(text: widget.persona?.curp);
  late final _nss = TextEditingController(text: widget.persona?.nss);
  late final _rfc = TextEditingController(text: widget.persona?.rfc);
  late final _birthPlaceState = TextEditingController(
    text: widget.persona?.birthPlaceState,
  );
  late final _personalEmail = TextEditingController(
    text: widget.persona?.personalEmail,
  );
  late final _phone = TextEditingController(text: widget.persona?.phone);
  late final _addressLine = TextEditingController(
    text: widget.persona?.addressLine,
  );
  late final _postalCode = TextEditingController(
    text: widget.persona?.postalCode,
  );
  late final _city = TextEditingController(text: widget.persona?.city);
  late final _municipality = TextEditingController(
    text: widget.persona?.municipality,
  );
  late final _state = TextEditingController(text: widget.persona?.state);
  late DateTime? _birthDate = widget.persona?.birthDate == null
      ? null
      : DateTime.tryParse(widget.persona!.birthDate!);
  late int? _gender = widget.persona?.gender;
  late int? _maritalStatus = widget.persona?.maritalStatus;
  late int? _educationLevel = widget.persona?.educationLevel;
  late bool _hasChildren = widget.persona?.hasChildren ?? false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final controller in [
      _firstName,
      _lastNamePaternal,
      _lastNameMaternal,
      _curp,
      _nss,
      _rfc,
      _birthPlaceState,
      _personalEmail,
      _phone,
      _addressLine,
      _postalCode,
      _city,
      _municipality,
      _state,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _requiredText(String? value) => value == null || value.trim().isEmpty
      ? 'Este dato es obligatorio.'
      : null;

  String? _optional(String controllerText) =>
      controllerText.trim().isEmpty ? null : controllerText.trim();

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final persona = Persona(
      id: widget.persona?.id ?? '',
      firstName: _firstName.text.trim(),
      lastNamePaternal: _lastNamePaternal.text.trim(),
      lastNameMaternal: _lastNameMaternal.text.trim(),
      curp: _optional(_curp.text),
      nss: _optional(_nss.text),
      rfc: _optional(_rfc.text),
      birthDate: _birthDate == null ? null : _isoDate.format(_birthDate!),
      birthPlaceState: _birthPlaceState.text.trim(),
      gender: _gender,
      maritalStatus: _maritalStatus,
      educationLevel: _educationLevel,
      hasChildren: _hasChildren,
      personalEmail: _personalEmail.text.trim(),
      phone: _phone.text.trim(),
      addressLine: _addressLine.text.trim(),
      postalCode: _postalCode.text.trim(),
      city: _city.text.trim(),
      municipality: _municipality.text.trim(),
      state: _state.text.trim(),
    );
    try {
      await ref
          .read(personsRepositoryProvider)
          .save(persona, creating: widget.persona == null);
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = personMutationError(error);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogs = ref.watch(personCatalogsProvider);
    return AppFormPanel(
      title: widget.persona == null ? 'Agregar persona' : 'Editar persona',
      busy: _busy,
      error: _error,
      canSave: catalogs.hasValue,
      onSave: _save,
      child: catalogs.when(
        data: _fields,
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(
          error: error,
          onRetry: () => ref.invalidate(personCatalogsProvider),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );

  Widget _fields(PersonCatalogs catalogs) => Form(
    key: _form,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('Identidad'),
        AppTextField(
          label: 'Nombre(s)',
          controller: _firstName,
          enabled: !_busy,
          validator: _requiredText,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Apellido paterno',
          controller: _lastNamePaternal,
          enabled: !_busy,
          validator: _requiredText,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Apellido materno (opcional)',
          controller: _lastNameMaternal,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: Text(
                _birthDate == null
                    ? 'Fecha de nacimiento: sin capturar'
                    : 'Fecha de nacimiento: ${_displayDate.format(_birthDate!)}',
              ),
            ),
            TextButton(
              onPressed: _busy ? null : _pickBirthDate,
              child: const Text('Elegir'),
            ),
            if (_birthDate != null)
              TextButton(
                onPressed: _busy
                    ? null
                    : () => setState(() => _birthDate = null),
                child: const Text('Quitar'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'CURP (opcional)',
          controller: _curp,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'NSS (opcional)',
          controller: _nss,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'RFC (opcional)',
          controller: _rfc,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.md),
        _select(
          'Género (opcional)',
          _gender,
          catalogs.generos,
          (value) => setState(() => _gender = value),
        ),
        const SizedBox(height: AppSpacing.md),
        _select(
          'Estado civil (opcional)',
          _maritalStatus,
          catalogs.estadosCiviles,
          (value) => setState(() => _maritalStatus = value),
        ),
        const SizedBox(height: AppSpacing.md),
        _select(
          'Escolaridad (opcional)',
          _educationLevel,
          catalogs.escolaridades,
          (value) => setState(() => _educationLevel = value),
        ),
        const SizedBox(height: AppSpacing.sm),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Tiene hijos'),
          value: _hasChildren,
          onChanged: _busy
              ? null
              : (value) => setState(() => _hasChildren = value),
        ),
        const SizedBox(height: AppSpacing.lg),
        _sectionTitle('Contacto'),
        AppTextField(
          label: 'Correo personal (opcional)',
          controller: _personalEmail,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Teléfono (opcional)',
          controller: _phone,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.lg),
        _sectionTitle('Domicilio'),
        AppTextField(
          label: 'Domicilio (opcional)',
          controller: _addressLine,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Código postal (opcional)',
          controller: _postalCode,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Ciudad (opcional)',
          controller: _city,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Municipio (opcional)',
          controller: _municipality,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Estado (opcional)',
          controller: _state,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Estado de nacimiento (opcional)',
          controller: _birthPlaceState,
          enabled: !_busy,
        ),
      ],
    ),
  );

  Widget _select(
    String label,
    int? selected,
    List<PersonCatalogEntry> options,
    ValueChanged<int?> onChanged,
  ) => DropdownButtonFormField<int>(
    key: ValueKey('$label:$selected'),
    initialValue: selected,
    isExpanded: true,
    decoration: InputDecoration(labelText: label),
    items: [
      const DropdownMenuItem(value: null, child: Text('Sin capturar')),
      for (final item in options)
        DropdownMenuItem(value: item.id, child: Text(item.name)),
    ],
    onChanged: _busy ? null : onChanged,
  );
}

String personMutationError(Object error) {
  if (error is DioException && error.response?.statusCode == 400) {
    return 'Revisa los datos: algún campo único (CURP, NSS o RFC) ya está registrado en otra persona.';
  }
  return apiErrorMessage(error);
}
