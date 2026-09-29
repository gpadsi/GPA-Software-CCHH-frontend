import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/design_system/colors.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/positions_controller.dart';
import '../data/position_models.dart';

final _isoDate = DateFormat('yyyy-MM-dd');
final _displayDate = DateFormat.yMMMd('es_MX');

class PositionForm extends ConsumerStatefulWidget {
  const PositionForm({super.key, this.posicion});
  final Posicion? posicion;
  @override
  ConsumerState<PositionForm> createState() => _PositionFormState();
}

class _PositionFormState extends ConsumerState<PositionForm> {
  final _form = GlobalKey<FormState>();
  late final _supervisionTexto = TextEditingController(
    text: widget.posicion?.supervisionTexto,
  );
  late final _headhunter = TextEditingController(
    text: widget.posicion?.headhunter,
  );
  late final _solicitanteVacante = TextEditingController(
    text: widget.posicion?.solicitanteVacante,
  );
  late final _proyectoEventual = TextEditingController(
    text: widget.posicion?.proyectoEventual,
  );
  late String? _organizationNode = widget.posicion?.organizationNode;
  late String? _area = widget.posicion?.area;
  late int? _puesto = widget.posicion?.puesto;
  late String? _reportsTo = widget.posicion?.reportsTo;
  late int? _alcance = widget.posicion?.alcance;
  late int? _tipoPosicion = widget.posicion?.tipoPosicion;
  late int? _tipoRequisicion = widget.posicion?.tipoRequisicion;
  late int? _estatus = widget.posicion?.estatus;
  late int? _generoRequerido = widget.posicion?.generoRequerido;
  late DateTime? _fechaRegistroVacante = _parse(
    widget.posicion?.fechaRegistroVacante,
  );
  late DateTime? _fechaAutorizacionVacante = _parse(
    widget.posicion?.fechaAutorizacionVacante,
  );
  late DateTime? _fechaEsperadaTermino = _parse(
    widget.posicion?.fechaEsperadaTermino,
  );
  bool _busy = false;
  String? _error;

  static DateTime? _parse(String? value) =>
      value == null ? null : DateTime.tryParse(value);

  @override
  void dispose() {
    for (final controller in [
      _supervisionTexto,
      _headhunter,
      _solicitanteVacante,
      _proyectoEventual,
    ]) {
      controller.dispose();
    }
    super.dispose();
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
    setState(() {
      _busy = true;
      _error = null;
    });
    final posicion = Posicion(
      id: widget.posicion?.id ?? '',
      organizationNode: _organizationNode!,
      area: _area,
      puesto: _puesto,
      reportsTo: _reportsTo,
      supervisionTexto: _supervisionTexto.text.trim(),
      alcance: _alcance,
      tipoPosicion: _tipoPosicion,
      tipoRequisicion: _tipoRequisicion,
      estatus: _estatus!,
      generoRequerido: _generoRequerido,
      fechaRegistroVacante: _fechaRegistroVacante == null
          ? null
          : _isoDate.format(_fechaRegistroVacante!),
      fechaAutorizacionVacante: _fechaAutorizacionVacante == null
          ? null
          : _isoDate.format(_fechaAutorizacionVacante!),
      headhunter: _headhunter.text.trim(),
      solicitanteVacante: _solicitanteVacante.text.trim(),
      proyectoEventual: _proyectoEventual.text.trim(),
      fechaEsperadaTermino: _fechaEsperadaTermino == null
          ? null
          : _isoDate.format(_fechaEsperadaTermino!),
    );
    try {
      await ref
          .read(positionsRepositoryProvider)
          .save(posicion, creating: widget.posicion == null);
      if (mounted) Navigator.of(context).pop(true);
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = positionMutationError(error);
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final catalogs = ref.watch(positionCatalogsProvider);
    return PopScope(
      canPop: !_busy,
      child: Dialog(
        insetPadding: const EdgeInsets.all(AppSpacing.md),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640, maxHeight: 720),
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
                  widget.posicion == null
                      ? 'Agregar posición'
                      : 'Editar posición',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: catalogs.when(
                    data: _fields,
                    loading: () => const FeatureLoading(),
                    error: (error, _) => FeatureError(
                      error: error,
                      onRetry: () => ref.invalidate(positionCatalogsProvider),
                    ),
                  ),
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
                          onPressed: catalogs.hasValue ? _save : null,
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

  Widget _sectionTitle(String text) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );

  String _dateLabel(String label, DateTime? value, ValueChanged<DateTime?> onPicked) {
    return value == null ? '$label: sin capturar' : '$label: ${_displayDate.format(value)}';
  }

  Widget _dateField(
    String label,
    DateTime? value,
    ValueChanged<DateTime?> onPicked,
  ) => Row(
    children: [
      Expanded(child: Text(_dateLabel(label, value, onPicked))),
      TextButton(
        onPressed: _busy ? null : () => _pickDate(value, onPicked),
        child: const Text('Elegir'),
      ),
      if (value != null)
        TextButton(
          onPressed: _busy ? null : () => setState(() => onPicked(null)),
          child: const Text('Quitar'),
        ),
    ],
  );

  Widget _fields(PositionCatalogs catalogs) => Form(
    key: _form,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('Unidad organizacional'),
        DropdownButtonFormField<String>(
          key: ValueKey('org:$_organizationNode'),
          initialValue: _organizationNode,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Unidad organizacional'),
          items: [
            for (final item in catalogs.organizationNodes)
              DropdownMenuItem(value: item.id, child: Text(item.name)),
          ],
          validator: (value) =>
              value == null ? 'Elige a qué unidad pertenece.' : null,
          onChanged: _busy
              ? null
              : (value) => setState(() => _organizationNode = value),
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<String?>(
          key: ValueKey('area:$_area'),
          initialValue: _area,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Área (opcional)'),
          items: [
            const DropdownMenuItem(value: null, child: Text('Sin capturar')),
            for (final item in catalogs.areas)
              DropdownMenuItem(value: item.id, child: Text(item.name)),
          ],
          onChanged: _busy ? null : (value) => setState(() => _area = value),
        ),
        const SizedBox(height: AppSpacing.lg),
        _sectionTitle('Puesto y clasificación'),
        _selectInt(
          'Puesto (opcional)',
          _puesto,
          catalogs.puestos,
          (value) => setState(() => _puesto = value),
        ),
        const SizedBox(height: AppSpacing.md),
        _selectInt(
          'Alcance de posición (opcional)',
          _alcance,
          catalogs.alcances,
          (value) => setState(() => _alcance = value),
        ),
        const SizedBox(height: AppSpacing.md),
        _selectInt(
          'Tipo de posición (opcional)',
          _tipoPosicion,
          catalogs.tiposPosicion,
          (value) => setState(() => _tipoPosicion = value),
        ),
        const SizedBox(height: AppSpacing.md),
        _selectInt(
          'Tipo de requisición (opcional)',
          _tipoRequisicion,
          catalogs.tiposRequisicion,
          (value) => setState(() => _tipoRequisicion = value),
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<int>(
          key: ValueKey('estatus:$_estatus'),
          initialValue: _estatus,
          isExpanded: true,
          decoration: const InputDecoration(labelText: 'Estatus'),
          items: [
            for (final item in catalogs.estatus)
              DropdownMenuItem(value: item.id, child: Text(item.name)),
          ],
          validator: (value) => value == null ? 'Elige un estatus.' : null,
          onChanged: _busy
              ? null
              : (value) => setState(() => _estatus = value),
        ),
        const SizedBox(height: AppSpacing.md),
        _selectInt(
          'Género requerido (opcional)',
          _generoRequerido,
          catalogs.generos,
          (value) => setState(() => _generoRequerido = value),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Supervisión, texto original (opcional)',
          controller: _supervisionTexto,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.lg),
        _sectionTitle('Línea de reporte'),
        _ReportsToField(
          selected: _reportsTo,
          excludeId: widget.posicion?.id,
          catalogs: catalogs,
          enabled: !_busy,
          onChanged: (value) => setState(() => _reportsTo = value),
        ),
        const SizedBox(height: AppSpacing.lg),
        _sectionTitle('Vacante (opcional)'),
        _dateField(
          'Fecha de registro de vacante',
          _fechaRegistroVacante,
          (value) => _fechaRegistroVacante = value,
        ),
        const SizedBox(height: AppSpacing.md),
        _dateField(
          'Fecha de autorización de vacante',
          _fechaAutorizacionVacante,
          (value) => _fechaAutorizacionVacante = value,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Headhunter (opcional)',
          controller: _headhunter,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Solicitante de vacante (opcional)',
          controller: _solicitanteVacante,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          label: 'Proyecto eventual (opcional)',
          controller: _proyectoEventual,
          enabled: !_busy,
        ),
        const SizedBox(height: AppSpacing.md),
        _dateField(
          'Fecha esperada de término',
          _fechaEsperadaTermino,
          (value) => _fechaEsperadaTermino = value,
        ),
      ],
    ),
  );

  Widget _selectInt(
    String label,
    int? selected,
    List<PositionCatalogEntry> options,
    ValueChanged<int?> onChanged,
  ) => DropdownButtonFormField<int?>(
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

class _ReportsToField extends ConsumerWidget {
  const _ReportsToField({
    required this.selected,
    required this.excludeId,
    required this.catalogs,
    required this.enabled,
    required this.onChanged,
  });
  final String? selected;
  final String? excludeId;
  final PositionCatalogs catalogs;
  final bool enabled;
  final ValueChanged<String?> onChanged;

  String _labelFor(Posicion posicion) {
    final puesto = PositionCatalogs.nameIn(catalogs.puestos, posicion.puesto);
    final area = PositionCatalogs.nameInRefs(catalogs.areas, posicion.area);
    if (puesto == null && area == null) return 'Posición sin puesto ni área';
    return '${puesto ?? 'Puesto no capturado'} — ${area ?? 'área no capturada'}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(allPosicionesForPickerProvider).when(
        data: (posiciones) {
          final options = posiciones.where((item) => item.id != excludeId);
          return DropdownMenu<String?>(
            enabled: enabled,
            enableFilter: true,
            requestFocusOnTap: true,
            expandedInsets: EdgeInsets.zero,
            initialSelection: selected,
            label: const Text('Reporta a (opcional)'),
            hintText: 'Sin capturar',
            dropdownMenuEntries: [
              const DropdownMenuEntry(value: null, label: 'Sin capturar'),
              for (final item in options)
                DropdownMenuEntry(value: item.id, label: _labelFor(item)),
            ],
            onSelected: enabled ? onChanged : null,
          );
        },
        loading: () => const DropdownMenu<String?>(
          enabled: false,
          expandedInsets: EdgeInsets.zero,
          label: Text('Reporta a (opcional)'),
          hintText: 'Cargando posiciones…',
          dropdownMenuEntries: [],
        ),
        error: (error, _) => Row(
          children: [
            Expanded(
              child: Text(
                'No se pudo cargar la lista de posiciones para elegir a quién reporta.',
                style: const TextStyle(color: AppColors.error),
              ),
            ),
            TextButton(
              onPressed: () => ref.invalidate(allPosicionesForPickerProvider),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
}

String positionMutationError(Object error) {
  if (error is DioException && error.response?.statusCode == 400) {
    return 'Revisa los datos: la línea de reporte no puede formar un ciclo ni apuntar a la misma posición.';
  }
  return apiErrorMessage(error);
}
