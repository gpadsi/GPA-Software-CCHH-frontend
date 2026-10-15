import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/form_dialog.dart';
import '../application/locations_controller.dart';
import '../data/location_models.dart';
import '../data/locations_repository.dart';

class LocationForm extends ConsumerStatefulWidget {
  const LocationForm({super.key, required this.kind, this.record});
  final LocationKind kind;
  final LocationRecord? record;
  @override
  ConsumerState<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends ConsumerState<LocationForm>
    with FormChangeTracking {
  final _form = GlobalKey<FormState>();
  late final _code = TextEditingController(text: widget.record?.code);
  late final _name = TextEditingController(text: widget.record?.name);
  late final _registration = TextEditingController(
    text: widget.record?.employerRegistration,
  );
  late bool _active = widget.record?.isActive ?? true;
  String? _ubicacion;
  late String? _nave = widget.record?.nave;
  bool _initialized = false;
  String? _initialUbicacion;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    watchChanges([_code, _name, _registration]);
  }

  @override
  bool get hasChanges {
    final current = widget.record;
    return _code.text != (current?.code ?? '') ||
        _name.text != (current?.name ?? '') ||
        _registration.text != (current?.employerRegistration ?? '') ||
        _active != (current?.isActive ?? true) ||
        _ubicacion != _initialUbicacion ||
        _nave != current?.nave;
  }

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    _registration.dispose();
    super.dispose();
  }

  String? _validate(String? text, int limit, {bool required = true}) {
    if (required && (text == null || text.trim().isEmpty)) {
      return 'Este dato es obligatorio.';
    }
    if ((text?.trim().length ?? 0) > limit) {
      return 'Usa como máximo $limit caracteres.';
    }
    return null;
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(locationsRepositoryProvider)
          .save(
            widget.kind,
            LocationRecord(
              id: widget.record?.id ?? '',
              code: _code.text.trim(),
              name: _name.text.trim(),
              employerRegistration: _registration.text.trim(),
              isActive: _active,
              ubicacion: _ubicacion,
              nave: _nave,
            ),
            creating: widget.record == null,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = locationMutationError(error);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalog = widget.kind == LocationKind.ubicaciones
        ? const AsyncData(LocationCatalog(ubicaciones: [], naves: []))
        : ref.watch(locationCatalogProvider);
    return AppFormDialog(
      title:
          '${widget.record == null ? 'Agregar' : 'Editar'} ${widget.kind.singular}',
      dirty: hasChanges,
      busy: _busy,
      error: _error,
      canSave: catalog.hasValue,
      onSave: _save,
      child: catalog.when(
        data: (data) => _fields(data),
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(
          error: error,
          onRetry: () => ref.invalidate(locationCatalogProvider),
        ),
      ),
    );
  }

  Widget _fields(LocationCatalog catalog) {
    if (!_initialized) {
      _ubicacion = widget.kind == LocationKind.naves
          ? widget.record?.ubicacion
          : catalog.naveById(_nave)?.ubicacion;
      _initialUbicacion = _ubicacion;
      _initialized = true;
    }
    final placed = widget.kind != LocationKind.ubicaciones;
    final identity = [
      AppFieldGrid(
        minTwoColumnWidth: 480,
        children: [
          AppTextField(
            label: 'Código',
            controller: _code,
            enabled: !_busy,
            autofocus: widget.record == null && !placed,
            validator: (value) => _validate(value, 30),
          ),
          AppTextField(
            label: widget.kind == LocationKind.naves
                ? 'Nombre (opcional)'
                : 'Nombre',
            controller: _name,
            enabled: !_busy,
            validator: (value) => _validate(
              value,
              150,
              required: widget.kind != LocationKind.naves,
            ),
          ),
        ],
      ),
      if (widget.kind == LocationKind.ubicaciones)
        AppTextField(
          label: 'Registro patronal (opcional)',
          controller: _registration,
          enabled: !_busy,
          validator: (value) => _validate(value, 100, required: false),
        ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Activo'),
        value: _active,
        onChanged: _busy ? null : (value) => setState(() => _active = value),
      ),
    ];
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (placed)
            AppFormSection(
              first: true,
              title: 'Dónde está',
              description: widget.kind == LocationKind.areas
                  ? 'La ubicación filtra las naves. Si la nave no se ha confirmado, puedes dejarla pendiente.'
                  : null,
              children: [
                _select(
                  'Ubicación',
                  _ubicacion,
                  {
                    for (final item in catalog.ubicaciones)
                      item.id: item.displayName,
                  },
                  (value) => setState(() {
                    _ubicacion = value;
                    _nave = null;
                  }),
                  optional: widget.kind == LocationKind.areas,
                  emptyLabel: 'Sin ubicación confirmada',
                ),
                if (widget.kind == LocationKind.areas)
                  _select(
                    'Nave',
                    _nave,
                    {
                      for (final item in catalog.navesAt(_ubicacion))
                        item.id: item.displayName,
                    },
                    (value) => setState(() => _nave = value),
                    optional: true,
                    emptyLabel: 'Sin nave confirmada',
                  ),
              ],
            ),
          AppFormSection(
            first: !placed,
            title: placed ? 'Datos' : null,
            children: identity,
          ),
        ],
      ),
    );
  }

  Widget _select(
    String label,
    String? selected,
    Map<String, String> options,
    ValueChanged<String?> onChanged, {
    required bool optional,
    required String emptyLabel,
  }) {
    return DropdownButtonFormField<String>(
      key: ValueKey('$label:$selected'),
      initialValue: selected ?? '',
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        DropdownMenuItem(
          value: '',
          child: Text(optional ? emptyLabel : 'Selecciona una ubicación'),
        ),
        if (selected != null && !options.containsKey(selected))
          DropdownMenuItem(
            value: selected,
            child: Text('$label no disponible'),
          ),
        for (final entry in options.entries)
          DropdownMenuItem(
            value: entry.key,
            child: Text(
              entry.value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
      onChanged: _busy
          ? null
          : (value) => onChanged(value == '' ? null : value),
      validator: (value) => !optional && (value == null || value.isEmpty)
          ? 'Selecciona una ubicación.'
          : null,
    );
  }
}
