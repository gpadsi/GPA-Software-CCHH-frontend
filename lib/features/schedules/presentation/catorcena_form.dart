import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/design_system/spacing.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/form_panel.dart';
import '../application/schedules_controller.dart';
import '../data/schedule_models.dart';

final _isoDate = DateFormat('yyyy-MM-dd');
final _displayDate = DateFormat.yMMMd('es_MX');

class CatorcenaForm extends ConsumerStatefulWidget {
  const CatorcenaForm({super.key, this.catorcena});
  final Catorcena? catorcena;
  @override
  ConsumerState<CatorcenaForm> createState() => _CatorcenaFormState();
}

class _CatorcenaFormState extends ConsumerState<CatorcenaForm> {
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

  Future<void> _pickDate(
    DateTime? current,
    ValueChanged<DateTime?> onPicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => onPicked(picked));
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    if (_fechaInicio == null || _fechaFin == null) {
      setState(() => _error = 'Elige la fecha de inicio y la fecha de fin.');
      return;
    }
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
  Widget build(BuildContext context) => AppFormPanel(
    title: widget.catorcena == null ? 'Agregar catorcena' : 'Editar catorcena',
    busy: _busy,
    error: _error,
    onSave: _save,
    child: Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            label: 'Número de catorcena',
            controller: _numero,
            enabled: !_busy,
            validator: _requiredInt,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'Año',
            controller: _anio,
            enabled: !_busy,
            validator: _requiredInt,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Text(
                  _fechaInicio == null
                      ? 'Fecha de inicio: sin capturar'
                      : 'Fecha de inicio: ${_displayDate.format(_fechaInicio!)}',
                ),
              ),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => _pickDate(
                        _fechaInicio,
                        (value) => _fechaInicio = value,
                      ),
                child: const Text('Elegir'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  _fechaFin == null
                      ? 'Fecha de fin: sin capturar'
                      : 'Fecha de fin: ${_displayDate.format(_fechaFin!)}',
                ),
              ),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => _pickDate(_fechaFin, (value) => _fechaFin = value),
                child: const Text('Elegir'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
