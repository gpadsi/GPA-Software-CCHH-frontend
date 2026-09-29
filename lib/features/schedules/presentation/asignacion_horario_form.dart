import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/design_system/colors.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/schedules_controller.dart';
import '../data/schedule_models.dart';
import 'empleado_picker_field.dart';

final _isoDate = DateFormat('yyyy-MM-dd');
final _displayDate = DateFormat.yMMMd('es_MX');

class AsignacionHorarioForm extends ConsumerStatefulWidget {
  const AsignacionHorarioForm({super.key, this.asignacion});
  final AsignacionHorario? asignacion;
  @override
  ConsumerState<AsignacionHorarioForm> createState() =>
      _AsignacionHorarioFormState();
}

class _AsignacionHorarioFormState extends ConsumerState<AsignacionHorarioForm> {
  final _form = GlobalKey<FormState>();
  late String? _empleado = widget.asignacion?.empleado;
  late String? _catorcena = widget.asignacion?.catorcena;
  late int? _tipoHorario = widget.asignacion?.tipoHorario;
  late DateTime? _fechaReferencia = widget.asignacion?.fechaReferencia == null
      ? null
      : DateTime.tryParse(widget.asignacion!.fechaReferencia);
  bool _busy = false;
  String? _error;

  Future<void> _pickFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaReferencia ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _fechaReferencia = picked);
  }

  Future<void> _save() async {
    if (_busy || !_form.currentState!.validate()) return;
    if (_fechaReferencia == null) {
      setState(() => _error = 'Elige la fecha de referencia.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final asignacion = AsignacionHorario(
      id: widget.asignacion?.id ?? '',
      empleado: _empleado!,
      catorcena: _catorcena,
      fechaReferencia: _isoDate.format(_fechaReferencia!),
      tipoHorario: _tipoHorario!,
    );
    try {
      await ref
          .read(schedulesRepositoryProvider)
          .saveAsignacionHorario(
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
    final tiposHorario = ref.watch(tiposHorarioCatalogProvider);
    final catorcenas = ref.watch(allCatorcenasProvider);
    return PopScope(
      canPop: !_busy,
      child: Dialog(
        insetPadding: const EdgeInsets.all(AppSpacing.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560, maxHeight: 640),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  0,
                ),
                child: Text(
                  widget.asignacion == null
                      ? 'Agregar asignación de horario'
                      : 'Editar asignación de horario',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: switch ((tiposHorario, catorcenas)) {
                    (AsyncError(:final error), _) ||
                    (_, AsyncError(:final error)) => FeatureError(
                      error: error,
                      onRetry: () {
                        ref.invalidate(tiposHorarioCatalogProvider);
                        ref.invalidate(allCatorcenasProvider);
                      },
                    ),
                    (
                      AsyncData(value: final tipos),
                      AsyncData(value: final catorcenasList),
                    ) =>
                      _fields(tipos, catorcenasList),
                    _ => const FeatureLoading(),
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_error != null) ...[
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          _error!,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
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
                          onPressed:
                              tiposHorario.hasValue && catorcenas.hasValue
                              ? _save
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fields(List<TipoHorarioRef> tipos, List<Catorcena> catorcenas) =>
      Form(
        key: _form,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EmpleadoPickerField(
              selected: _empleado,
              enabled: !_busy,
              onChanged: (value) => setState(() => _empleado = value),
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<int>(
              key: ValueKey('tipo:$_tipoHorario'),
              initialValue: _tipoHorario,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Tipo de horario'),
              items: [
                for (final tipo in tipos)
                  DropdownMenuItem(value: tipo.id, child: Text(tipo.name)),
              ],
              validator: (value) =>
                  value == null ? 'Elige un tipo de horario.' : null,
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _tipoHorario = value),
            ),
            const SizedBox(height: AppSpacing.md),
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
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _fechaReferencia == null
                        ? 'Fecha de referencia: sin capturar'
                        : 'Fecha de referencia: ${_displayDate.format(_fechaReferencia!)}',
                  ),
                ),
                TextButton(
                  onPressed: _busy ? null : _pickFecha,
                  child: const Text('Elegir'),
                ),
              ],
            ),
          ],
        ),
      );
}
