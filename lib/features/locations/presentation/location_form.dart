import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/colors.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/feature_page.dart';
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

class _LocationFormState extends ConsumerState<LocationForm> {
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
  bool _busy = false;
  String? _error;

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
    return PopScope(
      canPop: !_busy,
      child: Dialog(
        insetPadding: const EdgeInsets.all(AppSpacing.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${widget.record == null ? 'Agregar' : 'Editar'} ${widget.kind.singular}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.lg),
                catalog.when(
                  data: (data) => _fields(data),
                  loading: () => const FeatureLoading(),
                  error: (error, _) => FeatureError(
                    error: error,
                    onRetry: () => ref.invalidate(locationCatalogProvider),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      _error!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.lg),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    AppButton(
                      label: 'Cancelar',
                      variant: AppButtonVariant.secondary,
                      onPressed: _busy
                          ? null
                          : () => Navigator.of(context).pop(),
                    ),
                    AppButton(
                      label: 'Guardar',
                      isLoading: _busy,
                      onPressed: catalog.hasValue ? _save : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fields(LocationCatalog catalog) {
    if (!_initialized) {
      _ubicacion = widget.kind == LocationKind.naves
          ? widget.record?.ubicacion
          : catalog.naveById(_nave)?.ubicacion;
      _initialized = true;
    }
    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.kind != LocationKind.ubicaciones) ...[
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
            const SizedBox(height: AppSpacing.lg),
          ],
          if (widget.kind == LocationKind.areas) ...[
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
            const SizedBox(height: AppSpacing.sm),
            Text(
              'La ubicación filtra las naves. Si la nave no se ha confirmado, puedes dejarla pendiente.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          AppTextField(
            label: 'Código',
            controller: _code,
            enabled: !_busy,
            validator: (value) => _validate(value, 30),
          ),
          const SizedBox(height: AppSpacing.lg),
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
          if (widget.kind == LocationKind.ubicaciones) ...[
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Registro patronal (opcional)',
              controller: _registration,
              enabled: !_busy,
              validator: (value) => _validate(value, 100, required: false),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Activo'),
            value: _active,
            onChanged: _busy
                ? null
                : (value) => setState(() => _active = value),
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

class LocationDeleteDialog extends ConsumerStatefulWidget {
  const LocationDeleteDialog({
    super.key,
    required this.kind,
    required this.record,
  });
  final LocationKind kind;
  final LocationRecord record;
  @override
  ConsumerState<LocationDeleteDialog> createState() =>
      _LocationDeleteDialogState();
}

class _LocationDeleteDialogState extends ConsumerState<LocationDeleteDialog> {
  bool _busy = false;
  String? _error;

  Future<void> _delete() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(locationsRepositoryProvider)
          .delete(widget.kind, widget.record.id);
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = locationMutationError(error, deleting: true);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_busy,
    child: AlertDialog(
      title: Text('Eliminar ${widget.kind.singular}'),
      scrollable: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '¿Eliminar «${widget.record.displayName}»? Esta acción no se puede deshacer.',
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Si tiene registros vinculados, el sistema puede impedir su eliminación.',
          ),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.md),
            Semantics(
              liveRegion: true,
              child: Text(
                _error!,
                style: const TextStyle(color: AppColors.error),
              ),
            ),
          ],
        ],
      ),
      actions: [
        AppButton(
          label: 'Cancelar',
          variant: AppButtonVariant.secondary,
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
        ),
        AppButton(
          label: 'Eliminar',
          variant: AppButtonVariant.danger,
          isLoading: _busy,
          onPressed: _delete,
        ),
      ],
    ),
  );
}
