import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_date_field.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/form_panel.dart';
import '../../../core/widgets/search_picker_field.dart';
import '../application/recruitment_controller.dart';
import '../data/recruitment_catalogs.dart';
import '../data/recruitment_models.dart';
import '../data/recruitment_repository.dart';
import 'recruitment_ui.dart';

/// Alta de una requisición (sin [requisicion]: se elige la posición) o su
/// edición. Se cierra con la requisición guardada, o con null si se cancela.
///
/// Quien no es Capital Humano ni Admin solo puede dejarla en Borrador o
/// mandarla a autorización; del resto de los estados se encarga Capital
/// Humano (el servidor lo exige; aquí no se ofrecen las demás opciones).
class RequisicionForm extends ConsumerStatefulWidget {
  const RequisicionForm({super.key, this.requisicion});
  final Requisicion? requisicion;

  @override
  ConsumerState<RequisicionForm> createState() => _RequisicionFormState();
}

class _RequisicionFormState extends ConsumerState<RequisicionForm> {
  final _form = GlobalKey<FormState>();
  late final Requisicion? _current = widget.requisicion;

  PosicionElegible? _posicion;
  String? _posicionError;
  int _posicionAttention = 0;
  late int? _tipo = _current?.tipo;
  late int? _estado = _current?.estado;
  late DateTime? _fechaSolicitud =
      parseIsoDate(_current?.fechaSolicitud) ?? DateTime.now();
  late DateTime? _fechaACubrir = parseIsoDate(_current?.fechaACubrirVacante);
  late DateTime? _fechaEntrega = parseIsoDate(
    _current?.fechaEntregaACapitalHumano,
  );
  late DateTime? _fechaSuspension = parseIsoDate(_current?.fechaSuspension);
  late int? _horario = _current?.horarioACubrir;
  late int? _contrato = _current?.tipoContratoOfrecido;
  late bool? _viajar = _current?.disposicionViajar;

  late final _area = TextEditingController(text: _current?.areaSolicitante);
  late final _justificacion = TextEditingController(
    text: _current?.justificacion,
  );
  late final _idiomas = TextEditingController(
    text: _current?.idiomasRequeridos,
  );
  late final _nivel = TextEditingController(text: _current?.nivelTabulador);
  late final _compuesto = TextEditingController(
    text: _current?.sueldoMensualCompuesto,
  );
  late final _bruto = TextEditingController(text: _current?.sueldoMensualBruto);
  late final _neto = TextEditingController(text: _current?.sueldoMensualNeto);
  late final _motivo = TextEditingController(text: _current?.motivoSuspension);
  late final _autorizo = TextEditingController(
    text: _current?.autorizadoPorSuspension,
  );

  bool _estadoDefaulted = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final controller in [
      _area,
      _justificacion,
      _idiomas,
      _nivel,
      _compuesto,
      _bruto,
      _neto,
      _motivo,
      _autorizo,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _limit(String? value, int limit) =>
      (value?.trim().length ?? 0) > limit
      ? 'Usa como máximo $limit caracteres.'
      : null;

  String? _amount(String? value) {
    final cleaned = decimalOrNull(value);
    if (cleaned == null) return null;
    return RegExp(r'^\d{1,8}(\.\d{1,2})?$').hasMatch(cleaned)
        ? null
        : 'Escribe un importe válido, con hasta 2 decimales.';
  }

  Future<void> _save(RequisicionCatalogs catalogs) async {
    if (_busy || (_current == null && _posicion?.tramiteAbierto != null)) {
      return;
    }
    final creating = _current == null;
    final valid = _form.currentState!.validate();
    if (creating && _posicion == null) {
      setState(() {
        _posicionError = 'Elige la posición de la lista.';
        _posicionAttention++;
      });
      return;
    }
    if (!valid) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final saved = await ref
          .read(recruitmentRepositoryProvider)
          .saveRequisicion(
            Requisicion(
              id: _current?.id ?? '',
              posicion: _current?.posicion ?? _posicion!.id,
              tipo: _tipo!,
              estado: _estado!,
              fechaSolicitud: toIsoDate(_fechaSolicitud!),
              fechaACubrirVacante: _fechaACubrir == null
                  ? null
                  : toIsoDate(_fechaACubrir!),
              fechaEntregaACapitalHumano: _fechaEntrega == null
                  ? null
                  : toIsoDate(_fechaEntrega!),
              areaSolicitante: _area.text,
              justificacion: _justificacion.text,
              horarioACubrir: _horario,
              idiomasRequeridos: _idiomas.text,
              disposicionViajar: _viajar,
              nivelTabulador: _nivel.text,
              sueldoMensualCompuesto: _compuesto.text,
              sueldoMensualBruto: _bruto.text,
              sueldoMensualNeto: _neto.text,
              tipoContratoOfrecido: _contrato,
              motivoSuspension: _motivo.text,
              fechaSuspension: _fechaSuspension == null
                  ? null
                  : toIsoDate(_fechaSuspension!),
              autorizadoPorSuspension: _autorizo.text,
            ),
            creating: creating,
          );
      if (mounted) Navigator.of(context).pop(saved);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = recruitmentMutationError(error);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogs = ref.watch(requisicionCatalogsProvider);
    return AppFormPanel(
      title: _current == null ? 'Nueva requisición' : 'Editar requisición',
      subtitle: _current?.posicionEtiqueta,
      width: 680,
      busy: _busy,
      error: _error,
      canSave:
          catalogs.hasValue &&
          (_current != null || _posicion?.tramiteAbierto == null),
      onSave: () => _save(catalogs.requireValue),
      child: catalogs.when(
        data: _fields,
        loading: () => const FeatureLoading(),
        error: (error, _) => FeatureError(
          error: error,
          onRetry: () => ref.invalidate(requisicionCatalogsProvider),
        ),
      ),
    );
  }

  Widget _fields(RequisicionCatalogs catalogs) {
    final canManage = ref.watch(canManageHrProvider);
    final creating = _current == null;

    // El estado que se ofrece: todos para Capital Humano; para el resto, solo
    // los que el servidor les deja elegir (y el actual, para no perderlo).
    final estados = [
      for (final estado in catalogs.estados)
        if (canManage ||
            estadosDelSolicitante.contains(estado.code) ||
            estado.id == _current?.estado)
          estado,
    ];
    if (!_estadoDefaulted) {
      _estadoDefaulted = true;
      _estado ??=
          estados.where((e) => e.code == 'borrador').firstOrNull?.id ??
          estados.firstOrNull?.id;
    }
    final tipo = entryIn(catalogs.tipos, _tipo);

    return Form(
      key: _form,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionTitle('Solicitud', padTop: false),
          if (creating)
            SearchPickerField<PosicionElegible>(
              label: 'Posición',
              hint: 'Escribe puesto, unidad o área',
              enabled: !_busy,
              suggestOnFocus: true,
              errorText: _posicionError,
              attention: _posicionAttention,
              search: (text) => ref
                  .read(recruitmentRepositoryProvider)
                  .posicionesElegibles(para: 'requisicion', search: text),
              labelOf: (posicion) => posicion.etiqueta,
              detailOf: (posicion) => [
                posicion.estatus,
                if (posicion.area != null) posicion.area!,
              ].join(' · '),
              badgeOf: (posicion) => posicion.tramiteAbierto == null
                  ? null
                  : 'Requisición abierta',
              onChanged: (posicion) => setState(() {
                _posicion = posicion;
                _posicionError = null;
              }),
            )
          else
            InputDecorator(
              decoration: const InputDecoration(labelText: 'Posición'),
              child: Text(_current.posicionEtiqueta),
            ),
          if (creating && _posicion?.tramiteAbierto != null) ...[
            const SizedBox(height: AppSpacing.sm),
            const Text('Esta posición ya tiene una requisición abierta'),
            if (_posicion!.tramiteAbierto!.id == null)
              const Text('Pídela a Capital Humano')
            else
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    final id = _posicion!.tramiteAbierto!.id!;
                    Navigator.of(context).pop();
                    context.go('/reclutamiento/requisiciones/$id');
                  },
                  child: const Text('Abrir'),
                ),
              ),
          ],
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<int>(
            initialValue: _tipo,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Tipo de requisición'),
            items: [
              for (final item in catalogs.tipos)
                DropdownMenuItem(value: item.id, child: Text(item.name)),
            ],
            onChanged: _busy ? null : (value) => setState(() => _tipo = value),
            validator: (value) => value == null ? 'Elige el tipo.' : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<int>(
            initialValue: _estado,
            isExpanded: true,
            decoration: InputDecoration(
              labelText: 'Estado',
              helperText: canManage ? null : 'Tú puedes dejarla en borrador o mandarla a autorización; Capital Humano la autoriza.',
              helperMaxLines: 2,
            ),
            items: [
              for (final item in estados)
                DropdownMenuItem(value: item.id, child: Text(item.name)),
            ],
            onChanged: _busy
                ? null
                : (value) => setState(() => _estado = value),
            validator: (value) => value == null ? 'Elige el estado.' : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppDateField(
            label: 'Fecha de solicitud',
            value: _fechaSolicitud,
            isRequired: true,
            enabled: !_busy,
            onChanged: (value) => _fechaSolicitud = value,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppDateField(
            label: 'Fecha a cubrir la vacante',
            value: _fechaACubrir,
            enabled: !_busy,
            onChanged: (value) => _fechaACubrir = value,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppDateField(
            label: 'Fecha de entrega a Capital Humano',
            value: _fechaEntrega,
            enabled: !_busy,
            onChanged: (value) => _fechaEntrega = value,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Área solicitante',
            controller: _area,
            enabled: !_busy,
            validator: (value) => _limit(value, 150),
          ),
          const SectionTitle('Justificación'),
          AppTextField(
            label: tipo?.requiereJustificacion ?? false
                ? 'Justificación de la requisición (obligatoria para este tipo)'
                : 'Justificación de la requisición (opcional)',
            controller: _justificacion,
            enabled: !_busy,
            maxLines: null,
            minLines: 3,
            validator: (value) =>
                (tipo?.requiereJustificacion ?? false) &&
                    (value?.trim().isEmpty ?? true)
                ? 'Este tipo de requisición exige justificación.'
                : null,
          ),
          const SectionTitle('Perfil de la vacante'),
          DropdownButtonFormField<int?>(
            initialValue: _horario,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Horario a cubrir'),
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('Sin definir'),
              ),
              for (final item in catalogs.horarios)
                DropdownMenuItem<int?>(value: item.id, child: Text(item.name)),
            ],
            onChanged: _busy
                ? null
                : (value) => setState(() => _horario = value),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            label: 'Idiomas requeridos',
            controller: _idiomas,
            enabled: !_busy,
            validator: (value) => _limit(value, 150),
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<bool?>(
            initialValue: _viajar,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Disposición para viajar',
            ),
            items: const [
              DropdownMenuItem<bool?>(value: null, child: Text('Sin definir')),
              DropdownMenuItem<bool?>(value: true, child: Text('Sí')),
              DropdownMenuItem<bool?>(value: false, child: Text('No')),
            ],
            onChanged: _busy
                ? null
                : (value) => setState(() => _viajar = value),
          ),
          const SectionTitle('Compensación'),
          AppTextField(
            label: 'Nivel de tabulador',
            controller: _nivel,
            enabled: !_busy,
            validator: (value) => _limit(value, 50),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final (label, controller) in [
            ('Sueldo mensual compuesto', _compuesto),
            ('Sueldo mensual bruto', _bruto),
            ('Sueldo mensual neto', _neto),
          ]) ...[
            AppTextField(
              label: label,
              controller: controller,
              enabled: !_busy,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,$\s]')),
              ],
              validator: _amount,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          DropdownButtonFormField<int?>(
            initialValue: _contrato,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Tipo de contrato ofrecido',
            ),
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('Sin definir'),
              ),
              for (final item in catalogs.tiposContrato)
                DropdownMenuItem<int?>(value: item.id, child: Text(item.name)),
            ],
            onChanged: _busy
                ? null
                : (value) => setState(() => _contrato = value),
          ),
          if (canManage && !creating) ...[
            const SectionTitle('Suspensión (solo si aplica)'),
            AppTextField(
              label: 'Motivo de la suspensión',
              controller: _motivo,
              enabled: !_busy,
              maxLines: null,
              minLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppDateField(
              label: 'Fecha de suspensión',
              value: _fechaSuspension,
              enabled: !_busy,
              onChanged: (value) => _fechaSuspension = value,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: 'Autorizado por',
              controller: _autorizo,
              enabled: !_busy,
              validator: (value) => _limit(value, 150),
            ),
          ],
        ],
      ),
    );
  }
}
