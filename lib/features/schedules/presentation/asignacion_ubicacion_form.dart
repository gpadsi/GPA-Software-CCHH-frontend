import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/widgets/app_date_field.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/form_dialog.dart';
import '../application/schedules_controller.dart';
import '../data/schedule_models.dart';
import 'empleado_picker_field.dart';

final _isoDate = DateFormat('yyyy-MM-dd');

class AsignacionUbicacionForm extends ConsumerStatefulWidget {
  const AsignacionUbicacionForm({super.key, this.asignacion});
  final AsignacionUbicacion? asignacion;
  @override
  ConsumerState<AsignacionUbicacionForm> createState() =>
      _AsignacionUbicacionFormState();
}

class _AsignacionUbicacionFormState
    extends ConsumerState<AsignacionUbicacionForm>
    with FormChangeTracking {
  final _form = GlobalKey<FormState>();
  late String? _empleado = widget.asignacion?.empleado;
  late String? _catorcena = widget.asignacion?.catorcena;
  late String? _area = widget.asignacion?.area;
  late DateTime? _fechaReferencia = _parse(widget.asignacion?.fechaReferencia);
  bool _busy = false;
  String? _error;

  static DateTime? _parse(String? value) =>
      value == null ? null : DateTime.tryParse(value);

  @override
  bool get hasChanges {
    final current = widget.asignacion;
    return _empleado != current?.empleado ||
        _catorcena != current?.catorcena ||
        _area != current?.area ||
        dateChanged(_fechaReferencia, _parse(current?.fechaReferencia));
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final asignacion = AsignacionUbicacion(
      id: widget.asignacion?.id ?? '',
      empleado: _empleado!,
      catorcena: _catorcena,
      fechaReferencia: _isoDate.format(_fechaReferencia!),
      area: _area!,
    );
    try {
      await ref
          .read(schedulesRepositoryProvider)
          .saveAsignacionUbicacion(
            asignacion,
            creating: widget.asignacion == null,
          );
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = _mutationError(error);
          _busy = false;
        });
      }
    }
  }

  String _mutationError(Object error) {
    if (error is DioException && error.response?.statusCode == 400) {
      return 'Revisa los datos capturados.';
    }
    return apiErrorMessage(error);
  }

  @override
  Widget build(BuildContext context) {
    final areas = ref.watch(areasCatalogProvider);
    final catorcenas = ref.watch(allCatorcenasProvider);
    return AppFormDialog(
      title: widget.asignacion == null
          ? 'Agregar asignación de ubicación'
          : 'Editar asignación de ubicación',
      dirty: hasChanges,
      busy: _busy,
      error: _error,
      canSave: areas.hasValue && catorcenas.hasValue,
      onSave: _save,
      child: switch ((areas, catorcenas)) {
        (AsyncError(:final error), _) ||
        (_, AsyncError(:final error)) => FeatureError(
          error: error,
          onRetry: () {
            ref.invalidate(areasCatalogProvider);
            ref.invalidate(allCatorcenasProvider);
          },
        ),
        (
          AsyncData(value: final areasList),
          AsyncData(value: final catorcenasList),
        ) =>
          _fields(areasList, catorcenasList),
        _ => const FeatureLoading(),
      },
    );
  }

  Widget _fields(List<AreaRef> areas, List<Catorcena> catorcenas) => Form(
    key: _form,
    child: AppFormSection(
      first: true,
      children: [
        EmpleadoPickerField(
          selected: _empleado,
          enabled: !_busy,
          onChanged: (value) => setState(() => _empleado = value),
        ),
        AppFieldGrid(
          minTwoColumnWidth: 480,
          children: [
            DropdownButtonFormField<String>(
              key: ValueKey('area:$_area'),
              initialValue: _area,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Área'),
              items: [
                for (final area in areas)
                  DropdownMenuItem(value: area.id, child: Text(area.name)),
              ],
              validator: (value) => value == null ? 'Elige un área.' : null,
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _area = value),
            ),
            DropdownButtonFormField<String?>(
              key: ValueKey('catorcena:$_catorcena'),
              initialValue: _catorcena,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Catorcena (opcional)',
              ),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('Sin capturar'),
                ),
                for (final catorcena in catorcenas)
                  DropdownMenuItem(
                    value: catorcena.id,
                    child: Text('${catorcena.numero}/${catorcena.anio}'),
                  ),
              ],
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _catorcena = value),
            ),
          ],
        ),
        AppDateField(
          label: 'Fecha de referencia',
          value: _fechaReferencia,
          isRequired: true,
          enabled: !_busy,
          onChanged: (value) => setState(() => _fechaReferencia = value),
        ),
      ],
    ),
  );
}
