import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/network/api_failure.dart';
import '../../../core/widgets/app_date_field.dart';
import '../../../core/widgets/app_page.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/form_dialog.dart';
import '../application/schedules_controller.dart';
import '../data/schedule_models.dart';

final _isoDate = DateFormat('yyyy-MM-dd');

class CatorcenaForm extends ConsumerStatefulWidget {
  const CatorcenaForm({super.key, this.catorcena});
  final Catorcena? catorcena;
  @override
  ConsumerState<CatorcenaForm> createState() => _CatorcenaFormState();
}

class _CatorcenaFormState extends ConsumerState<CatorcenaForm>
    with FormChangeTracking {
  final _form = GlobalKey<FormState>();
  late final _numero = TextEditingController(
    text: widget.catorcena?.numero.toString(),
  );
  late final _anio = TextEditingController(
    text: widget.catorcena?.anio.toString(),
  );
  late DateTime? _fechaInicio = _parse(widget.catorcena?.fechaInicio);
  late DateTime? _fechaFin = _parse(widget.catorcena?.fechaFin);
  bool _busy = false;
  String? _error;

  static DateTime? _parse(String? value) =>
      value == null ? null : DateTime.tryParse(value);

  @override
  void initState() {
    super.initState();
    watchChanges([_numero, _anio]);
  }

  @override
  bool get hasChanges {
    final current = widget.catorcena;
    return _numero.text != (current?.numero.toString() ?? '') ||
        _anio.text != (current?.anio.toString() ?? '') ||
        dateChanged(_fechaInicio, _parse(current?.fechaInicio)) ||
        dateChanged(_fechaFin, _parse(current?.fechaFin));
  }

  @override
  void dispose() {
    _numero.dispose();
    _anio.dispose();
    super.dispose();
  }

  String? _requiredInt(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este dato es obligatorio.';
    }
    return int.tryParse(value.trim()) == null ? 'Debe ser un número.' : null;
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final catorcena = Catorcena(
      id: widget.catorcena?.id ?? '',
      numero: int.parse(_numero.text.trim()),
      anio: int.parse(_anio.text.trim()),
      fechaInicio: _isoDate.format(_fechaInicio!),
      fechaFin: _isoDate.format(_fechaFin!),
    );
    try {
      await ref
          .read(schedulesRepositoryProvider)
          .saveCatorcena(catorcena, creating: widget.catorcena == null);
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
      return 'Revisa los datos: ya existe una catorcena con ese número y año.';
    }
    return apiErrorMessage(error);
  }

  @override
  Widget build(BuildContext context) => AppFormDialog(
    title: widget.catorcena == null ? 'Agregar catorcena' : 'Editar catorcena',
    subtitle: 'Un periodo de catorce días del calendario de nómina.',
    dirty: hasChanges,
    busy: _busy,
    error: _error,
    onSave: _save,
    child: Form(
      key: _form,
      child: AppFormSection(
        first: true,
        children: [
          AppFieldGrid(
            minTwoColumnWidth: 480,
            children: [
              AppTextField(
                label: 'Número de catorcena',
                hint: 'Ej. 21',
                controller: _numero,
                enabled: !_busy,
                autofocus: widget.catorcena == null,
                keyboardType: TextInputType.number,
                validator: _requiredInt,
              ),
              AppTextField(
                label: 'Año',
                hint: 'Ej. 2026',
                controller: _anio,
                enabled: !_busy,
                keyboardType: TextInputType.number,
                validator: _requiredInt,
              ),
              AppDateField(
                label: 'Fecha de inicio',
                value: _fechaInicio,
                isRequired: true,
                enabled: !_busy,
                onChanged: (value) => setState(() => _fechaInicio = value),
              ),
              AppDateField(
                label: 'Fecha de fin',
                value: _fechaFin,
                isRequired: true,
                enabled: !_busy,
                onChanged: (value) => setState(() => _fechaFin = value),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
