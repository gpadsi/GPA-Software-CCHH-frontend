import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/colors.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/files/file_saver.dart';
import '../../../core/network/api_failure.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_date_field.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/feature_page.dart';
import '../application/recruitment_controller.dart';
import '../data/recruitment_catalogs.dart';
import '../data/recruitment_models.dart';
import '../data/recruitment_repository.dart';
import 'conformidades_card.dart';
import 'recruitment_ui.dart';

/// Cuántos renglones vacíos trae un borrador sin funciones ni indicadores:
/// los mismos que el formulario oficial (5 y 3), aunque aquí se puede agregar
/// más.
const _defaultFunciones = 5;
const _defaultIndicadores = 3;

class DescriptivoPage extends ConsumerWidget {
  const DescriptivoPage({super.key, required this.descriptivoId});
  final String descriptivoId;

  void _reload(WidgetRef ref) {
    ref.invalidate(descriptivoDetailProvider(descriptivoId));
    ref.invalidate(descriptivoCatalogsProvider);
    ref.invalidate(descriptivosPageProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(descriptivoDetailProvider(descriptivoId));
    final catalogs = ref.watch(descriptivoCatalogsProvider);
    // Mientras se recarga se sigue mostrando el editor con lo que ya tenía:
    // reemplazarlo por el esqueleto de carga borraría lo que se está
    // escribiendo.
    final loaded = detail.hasValue ? detail.requireValue : null;
    final options = catalogs.hasValue ? catalogs.requireValue : null;
    final error = (detail.hasError && !detail.hasValue)
        ? detail.error
        : (catalogs.hasError && !catalogs.hasValue)
        ? catalogs.error
        : null;
    return FeaturePage(
      title: loaded == null
          ? 'Descriptivo de puesto'
          : loaded.nombrePuesto.trim().isNotEmpty
          ? loaded.nombrePuesto
          : loaded.posicionEtiqueta,
      description: loaded == null
          ? 'Detalle del descriptivo de puesto.'
          : '${loaded.posicionEtiqueta} · versión ${loaded.version}',
      tabs: const FeatureTabs(
        current: '/reclutamiento/descriptivos',
        destinations: recruitmentTabs,
      ),
      child: error != null
          ? FeatureError(error: error, onRetry: () => _reload(ref))
          : loaded != null && options != null
          ? DescriptivoEditor(
              // Cambia solo al congelar: el editor se rearma ya sin edición.
              key: ValueKey('${loaded.id}:${loaded.congeladoEn}'),
              descriptivo: loaded,
              catalogs: options,
            )
          : const FeatureLoading(),
    );
  }
}

/// Formulario del Descriptivo de puesto (FO-C0-CH-04). Es editable mientras sea
/// borrador y la cuenta pueda escribir; en una versión congelada, o para
/// cualquier otra cuenta, muestra lo mismo sin dejar cambiarlo.
class DescriptivoEditor extends ConsumerStatefulWidget {
  const DescriptivoEditor({
    super.key,
    required this.descriptivo,
    required this.catalogs,
  });

  final Descriptivo descriptivo;
  final DescriptivoCatalogs catalogs;

  @override
  ConsumerState<DescriptivoEditor> createState() => _DescriptivoEditorState();
}

class _DescriptivoEditorState extends ConsumerState<DescriptivoEditor> {
  final _form = GlobalKey<FormState>();
  late final Descriptivo _d = widget.descriptivo;

  // Texto libre.
  late final _nombrePuesto = _ctl(_d.nombrePuesto);
  late final _empresa = _ctl(_d.empresa);
  late final _area = _ctl(_d.areaDepartamento);
  late final _reportaA = _ctl(_d.reportaA);
  late final _supervisaA = _ctl(_d.supervisaA);
  late final _edadOtro = _ctl(_d.edadOtro);
  late final _diasOtro = _ctl(_d.diasPorLaborarOtro);
  late final _horarioOtro = _ctl(_d.horarioOtro);
  late final _proposito = _ctl(_d.proposito);
  late final _decOperativas = _ctl(_d.decisionesOperativas);
  late final _decFuncionales = _ctl(_d.decisionesFuncionales);
  late final _decEstrategicas = _ctl(_d.decisionesEstrategicas);
  late final _relInternas = _ctl(_d.relacionesInternas);
  late final _relExternas = _ctl(_d.relacionesExternas);
  late final _escolaridad = _ctl(_d.escolaridadMinima);
  late final _experiencia = _ctl(_d.experienciaRequerida);
  late final _idiomas = _ctl(_d.idiomas);
  late final _compTecnicas = _ctl(_d.competenciasTecnicas);
  late final _compOtras = _ctl(_d.competenciasOtras);
  late final _recursosOtro = _ctl(_d.recursosOtro);

  // Listas numeradas: un campo por renglón.
  late final List<TextEditingController> _funciones = _lines(
    _d.funciones,
    _defaultFunciones,
  );
  late final List<TextEditingController> _indicadores = _lines(
    _d.indicadores,
    _defaultIndicadores,
  );

  // Selecciones.
  late DateTime? _fecha = parseIsoDate(_d.fechaElaboracion);
  late int? _edad = _d.edad;
  late int? _dias = _d.diasPorLaborar;
  late int? _horario = _d.horario;
  late bool? _viajar = _d.disponibilidadViajar;
  late final Set<int> _competencias = {..._d.competencias};
  late final Set<int> _recursos = {..._d.recursos};

  final _all = <TextEditingController>[];
  bool _dirty = false;
  bool _saving = false;
  bool _exporting = false;
  String? _error;

  bool get _editable => ref.read(canManageHrProvider) && !_d.estaCongelado;

  TextEditingController _ctl(String text) {
    final controller = TextEditingController(text: text);
    _all.add(controller);
    return controller;
  }

  // Un renglón vacío en el borrador para escribir; en una versión de solo
  // lectura solo los que tienen texto.
  List<TextEditingController> _lines(List<TextoNumerado> items, int minimum) {
    final rows = [for (final item in items) _ctl(item.texto)];
    if (_editableAtStart) {
      while (rows.length < minimum) {
        rows.add(_ctl(''));
      }
    }
    return rows;
  }

  bool get _editableAtStart =>
      ref.read(canManageHrProvider) && !widget.descriptivo.estaCongelado;

  @override
  void dispose() {
    for (final controller in _all) {
      controller.dispose();
    }
    super.dispose();
  }

  // Cualquier cambio (texto, lista o selección) marca el formulario como
  // modificado: habilita «Guardar borrador» y avisa de lo no guardado.
  void _touch() => setState(() => _dirty = true);

  Descriptivo _snapshot() => _d.copyWith(
    nombrePuesto: _nombrePuesto.text,
    empresa: _empresa.text,
    areaDepartamento: _area.text,
    reportaA: _reportaA.text,
    supervisaA: _supervisaA.text,
    fechaElaboracion: toIsoDate(_fecha!),
    edad: _edad,
    edadOtro: isOtro(entryIn(widget.catalogs.rangosEdad, _edad))
        ? _edadOtro.text
        : '',
    disponibilidadViajar: _viajar,
    diasPorLaborar: _dias,
    diasPorLaborarOtro: isOtro(entryIn(widget.catalogs.dias, _dias))
        ? _diasOtro.text
        : '',
    horario: _horario,
    horarioOtro: isOtro(entryIn(widget.catalogs.horarios, _horario))
        ? _horarioOtro.text
        : '',
    proposito: _proposito.text,
    decisionesOperativas: _decOperativas.text,
    decisionesFuncionales: _decFuncionales.text,
    decisionesEstrategicas: _decEstrategicas.text,
    relacionesInternas: _relInternas.text,
    relacionesExternas: _relExternas.text,
    escolaridadMinima: _escolaridad.text,
    experienciaRequerida: _experiencia.text,
    idiomas: _idiomas.text,
    competenciasTecnicas: _compTecnicas.text,
    competencias: _competencias.toList()..sort(),
    competenciasOtras: _compOtras.text,
    recursos: _recursos.toList()..sort(),
    recursosOtro: _recursosOtro.text,
    funciones: [
      for (final (i, c) in _funciones.indexed)
        TextoNumerado(orden: i + 1, texto: c.text),
    ],
    indicadores: [
      for (final (i, c) in _indicadores.indexed)
        TextoNumerado(orden: i + 1, texto: c.text),
    ],
  );

  void _say(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  void _reload() {
    ref.invalidate(descriptivoDetailProvider(_d.id));
    ref.invalidate(descriptivosPageProvider);
  }

  bool _validate() {
    final ok = _form.currentState?.validate() ?? false;
    if (!ok) _say('Revisa los campos marcados en rojo.');
    return ok;
  }

  Future<bool> _save({bool quiet = false}) async {
    if (_saving || !_validate()) return false;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(recruitmentRepositoryProvider)
          .saveDescriptivo(_snapshot());
      _reload();
      if (mounted) {
        setState(() {
          _dirty = false;
          _saving = false;
        });
        if (!quiet) _say('Borrador guardado.');
      }
      return true;
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _error = recruitmentMutationError(error);
          _saving = false;
        });
      }
      return false;
    }
  }

  Future<void> _freeze() async {
    if (!_validate()) return;
    final done = await showConfirmDialog(
      context,
      title: 'Congelar versión ${_d.version}',
      message: 'Al congelarla queda como la versión aprobada: ya no se podrá modificar ni borrar. Para cambiar algo después se abre un borrador nuevo a partir de ella.',
      confirmLabel: 'Congelar',
      destructive: false,
      onConfirm: () async {
        // Lo que se está viendo es lo que se congela: primero se guarda.
        final repository = ref.read(recruitmentRepositoryProvider);
        await repository.saveDescriptivo(_snapshot());
        await repository.congelar(_d.id);
      },
      errorMessage: recruitmentMutationError,
    );
    if (done && mounted) {
      _reload();
      _say('Versión ${_d.version} congelada.');
    }
  }

  Future<void> _copy() async {
    try {
      final nuevo = await ref.read(recruitmentRepositoryProvider).copiar(_d.id);
      ref.invalidate(descriptivosPageProvider);
      if (mounted) {
        _say('Se abrió un borrador nuevo a partir de esta versión.');
        context.go('/reclutamiento/descriptivos/${nuevo.id}');
      }
    } on Object catch (error) {
      if (mounted) _say(recruitmentMutationError(error));
    }
  }

  Future<void> _delete() async {
    final done = await showConfirmDialog(
      context,
      title: 'Eliminar borrador',
      message: '¿Eliminar el borrador v${_d.version}? Se pierde lo capturado.',
      onConfirm: () =>
          ref.read(recruitmentRepositoryProvider).deleteDescriptivo(_d.id),
      errorMessage: recruitmentMutationError,
    );
    if (done && mounted) {
      ref.invalidate(descriptivosPageProvider);
      context.go('/reclutamiento/descriptivos');
    }
  }

  Future<void> _export() async {
    if (_exporting) return;
    // Lo que se exporta es lo guardado: si hay cambios, primero se guardan.
    if (_editable && _dirty && !await _save(quiet: true)) return;
    setState(() => _exporting = true);
    try {
      final file = await ref
          .read(recruitmentRepositoryProvider)
          .exportarWord(_d.id);
      await ref.read(fileSaverProvider).save(file);
      if (mounted) _say('Se descargó «${file.name}».');
    } on Object catch (error) {
      if (mounted) _say(apiErrorMessage(error));
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  // ---------------------------------------------------------------------

  String? _limit(String? value, int limit) =>
      (value?.trim().length ?? 0) > limit
      ? 'Usa como máximo $limit caracteres.'
      : null;

  Widget _text(
    String label,
    TextEditingController controller, {
    int? limit,
    bool multiline = false,
    String? hint,
  }) => AppTextField(
    label: label,
    hint: hint,
    controller: controller,
    readOnly: !_editable,
    onChanged: (_) {
      if (!_dirty) _touch();
    },
    maxLines: multiline ? null : 1,
    minLines: multiline ? 3 : null,
    validator: limit == null ? null : (value) => _limit(value, limit),
  );

  Widget _pair(Widget a, Widget b) => LayoutBuilder(
    builder: (context, constraints) => constraints.maxWidth < 600
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              a,
              const SizedBox(height: AppSpacing.lg),
              b,
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: a),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: b),
            ],
          ),
  );

  static const _gap = SizedBox(height: AppSpacing.lg);

  Widget _choice(
    String label,
    int? value,
    List<RecruitmentCatalogEntry> options,
    ValueChanged<int?> onChanged,
  ) => DropdownButtonFormField<int?>(
    key: ValueKey('$label:$value'),
    initialValue: value,
    isExpanded: true,
    decoration: InputDecoration(labelText: label),
    items: [
      const DropdownMenuItem<int?>(value: null, child: Text('Sin definir')),
      for (final item in options)
        DropdownMenuItem<int?>(value: item.id, child: Text(item.name)),
    ],
    onChanged: _editable
        ? (next) {
            onChanged(next);
            _touch();
          }
        : null,
  );

  Widget _section(String title, List<Widget> children, {String? note}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              if (note != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(note, style: Theme.of(context).textTheme.bodySmall),
              ],
              const SizedBox(height: AppSpacing.lg),
              ...children,
            ],
          ),
        ),
      );

  Widget _checks(List<RecruitmentCatalogEntry> options, Set<int> selected) =>
      Wrap(
        spacing: AppSpacing.md,
        children: [
          for (final item in options)
            SizedBox(
              width: 270,
              child: CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(item.name),
                value: selected.contains(item.id),
                onChanged: _editable
                    ? (checked) {
                        setState(() {
                          if (checked ?? false) {
                            selected.add(item.id);
                          } else {
                            selected.remove(item.id);
                          }
                        });
                        _touch();
                      }
                    : null,
              ),
            ),
        ],
      );

  Widget _numbered(List<TextEditingController> rows, String noun) {
    final capitalized = '${noun[0].toUpperCase()}${noun.substring(1)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (rows.isEmpty)
          Text(
            'Sin $noun capturados.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        for (final (index, controller) in rows.indexed)
          Padding(
            key: ValueKey(controller),
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label: '$capitalized ${index + 1}',
                    controller: controller,
                    readOnly: !_editable,
                    onChanged: (_) {
                      if (!_dirty) _touch();
                    },
                    maxLines: null,
                    minLines: 2,
                  ),
                ),
                if (_editable)
                  IconButton(
                    tooltip: 'Quitar $noun ${index + 1}',
                    onPressed: () {
                      final removed = rows.removeAt(index);
                      _all.remove(removed);
                      // El campo todavía está en pantalla este cuadro: el
                      // controlador se libera cuando ya no lo usa.
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => removed.dispose(),
                      );
                      _touch();
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
              ],
            ),
          ),
        if (_editable)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                rows.add(_ctl(''));
                _touch();
              },
              icon: const Icon(Icons.add),
              label: Text('Agregar $noun'),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.catalogs;
    final type = Theme.of(context).textTheme;
    final canManage = ref.watch(canManageHrProvider);
    final editable = canManage && !_d.estaCongelado;
    final edad = entryIn(c.rangosEdad, _edad);
    final dias = entryIn(c.dias, _dias);
    final horario = entryIn(c.horarios, _horario);

    return Form(
      key: _form,
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    AppBadge(
                      label: _d.estaCongelado
                          ? 'Congelado${shownDate(_d.congeladoEn) == null ? '' : ' el ${shownDate(_d.congeladoEn)}'}'
                          : 'Borrador',
                      tone: _d.estaCongelado
                          ? AppBadgeTone.success
                          : AppBadgeTone.warning,
                    ),
                    if (editable)
                      AppButton(
                        label: 'Guardar borrador',
                        icon: Icons.save_outlined,
                        isLoading: _saving,
                        onPressed: _dirty ? _save : null,
                      ),
                    if (editable)
                      AppButton(
                        label: 'Congelar versión',
                        icon: Icons.lock_outline,
                        variant: AppButtonVariant.secondary,
                        onPressed: _saving ? null : _freeze,
                      ),
                    AppButton(
                      label: 'Descargar Word oficial',
                      icon: Icons.download_outlined,
                      variant: AppButtonVariant.secondary,
                      isLoading: _exporting,
                      onPressed: _export,
                    ),
                    if (canManage && _d.estaCongelado)
                      AppButton(
                        label: 'Copiar a un borrador nuevo',
                        icon: Icons.copy_all_outlined,
                        variant: AppButtonVariant.secondary,
                        onPressed: _copy,
                      ),
                    if (editable)
                      AppButton(
                        label: 'Eliminar borrador',
                        icon: Icons.delete_outline,
                        variant: AppButtonVariant.secondary,
                        onPressed: _delete,
                      ),
                  ],
                ),
              ),
              if (editable && _dirty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(
                    'Tienes cambios sin guardar.',
                    style: type.bodySmall,
                  ),
                ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Semantics(
                    liveRegion: true,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.errorSurface,
                        borderRadius: BorderRadius.circular(
                          AppSpacing.controlRadius,
                        ),
                      ),
                      child: Text(
                        _error!,
                        style: type.bodyMedium?.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                ),
              if (!canManage)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: Text(
                    'Solo Capital Humano edita los descriptivos. Aquí puedes consultarlo y descargarlo.',
                    style: type.bodySmall,
                  ),
                ),
              _section('Datos generales', [
                _pair(
                  _text('Nombre del puesto', _nombrePuesto, limit: 150),
                  _text('Empresa', _empresa, limit: 150),
                ),
                _gap,
                _pair(
                  _text('Área / Departamento', _area, limit: 150),
                  _text('Reporta a', _reportaA, limit: 150),
                ),
                _gap,
                _text(
                  'Supervisa a',
                  _supervisaA,
                  multiline: true,
                  hint: 'Puestos y número de personas a cargo, si aplica.',
                ),
                _gap,
                AppDateField(
                  label: 'Fecha de elaboración / actualización',
                  value: _fecha,
                  isRequired: true,
                  enabled: editable,
                  onChanged: (value) {
                    _fecha = value;
                    _touch();
                  },
                ),
              ]),
              _section('Condiciones del puesto', [
                _choice('Edad', _edad, c.rangosEdad, (v) => _edad = v),
                if (isOtro(edad)) ...[
                  _gap,
                  _text('Edad (otro)', _edadOtro, limit: 100),
                ],
                _gap,
                DropdownButtonFormField<bool?>(
                  key: ValueKey('viajar:$_viajar'),
                  initialValue: _viajar,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Disponibilidad para viajar',
                  ),
                  items: const [
                    DropdownMenuItem<bool?>(
                      value: null,
                      child: Text('Sin definir'),
                    ),
                    DropdownMenuItem<bool?>(value: true, child: Text('Sí')),
                    DropdownMenuItem<bool?>(value: false, child: Text('No')),
                  ],
                  onChanged: editable
                      ? (value) {
                          setState(() => _viajar = value);
                          _touch();
                        }
                      : null,
                ),
                _gap,
                _choice(
                  'Días por laborar',
                  _dias,
                  c.dias,
                  (v) => setState(() => _dias = v),
                ),
                if (isOtro(dias)) ...[
                  _gap,
                  _text('Días por laborar (otro)', _diasOtro, limit: 100),
                ],
                _gap,
                _choice(
                  'Horario por cubrir',
                  _horario,
                  c.horarios,
                  (v) => setState(() => _horario = v),
                ),
                if (isOtro(horario)) ...[
                  _gap,
                  _text('Horario (otro)', _horarioOtro, limit: 100),
                ],
              ]),
              _section('Propósito del puesto', [
                _text('Propósito', _proposito, multiline: true),
              ]),
              _section('Toma de decisiones', [
                _text('Decisiones operativas', _decOperativas, multiline: true),
                _gap,
                _text(
                  'Decisiones funcionales',
                  _decFuncionales,
                  multiline: true,
                ),
                _gap,
                _text(
                  'Decisiones estratégicas',
                  _decEstrategicas,
                  multiline: true,
                ),
              ]),
              _section('Relaciones', [
                _text('Relaciones internas', _relInternas, multiline: true),
                _gap,
                _text('Relaciones externas', _relExternas, multiline: true),
              ]),
              _section('Perfil del puesto', [
                _text('Escolaridad mínima', _escolaridad, multiline: true),
                _gap,
                _text('Experiencia requerida', _experiencia, multiline: true),
                _gap,
                _text('Idiomas', _idiomas, multiline: true),
                _gap,
                _text(
                  'Competencias y/o habilidades técnicas',
                  _compTecnicas,
                  multiline: true,
                ),
              ]),
              _section('Competencias conductuales', [
                _checks(c.competencias, _competencias),
                _gap,
                _text('Otras competencias', _compOtras, limit: 255),
              ]),
              _section('Recursos necesarios', [
                _checks(c.recursos, _recursos),
                _gap,
                _text('Otros recursos', _recursosOtro, limit: 255),
              ]),
              _section(
                'Funciones y responsabilidades',
                [_numbered(_funciones, 'responsabilidad')],
                note: 'Los renglones vacíos no se guardan. El orden es el de la lista.',
              ),
              _section('Indicadores de desempeño', [
                _numbered(_indicadores, 'indicador'),
              ]),
              if (canManage && _d.estaCongelado)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: ConformidadesCard(
                    descriptivo: _d,
                    roles: c.roles,
                    onChanged: _reload,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
