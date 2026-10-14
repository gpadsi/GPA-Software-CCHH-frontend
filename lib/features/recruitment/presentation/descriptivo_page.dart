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
import '../application/requisicion_exit_guard.dart';
import '../data/recruitment_catalogs.dart';
import '../data/recruitment_models.dart';
import '../data/recruitment_repository.dart';
import 'conformidades_card.dart';
import 'discard_changes_dialog.dart';
import 'recruitment_ui.dart';
import 'recruitment_design.dart';
import 'requisicion_before_unload.dart';

/// Cuántos renglones vacíos trae un borrador sin funciones ni indicadores:
/// los mismos que el formulario oficial (5 y 3), aunque aquí se puede agregar
/// más.
const _defaultFunciones = 5;
const _defaultIndicadores = 3;

/// Las secciones de la página, en el orden en que se recorren.
const _sectionNames = [
  'Identificación',
  'Propósito y funciones',
  'Perfil',
  'Competencias y recursos',
  'Indicadores y conformidades',
];

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
    if (error == null && loaded != null && options != null) {
      return DescriptivoEditor(
        // Cambia solo al aprobar: el editor se rearma ya sin edición.
        key: ValueKey('${loaded.id}:${loaded.congeladoEn}'),
        descriptivo: loaded,
        catalogs: options,
      );
    }
    return RecruitmentPage(
      title: 'Descriptivo de puesto',
      description: 'Detalle del descriptivo de puesto.',
      tabs: const RecruitmentModuleTabs(current: '/reclutamiento/descriptivos'),
      child: error != null
          ? FeatureError(error: error, onRetry: () => _reload(ref))
          : const FeatureLoading(),
    );
  }
}

/// Página del Descriptivo de puesto (FO-C0-CH-04). Es editable mientras sea
/// borrador y la cuenta pueda escribir; en una versión aprobada o histórica, o
/// para cualquier otra cuenta, muestra lo mismo sin dejar cambiarlo.
///
/// Solo se arma la sección abierta: el formulario tiene más de 50 campos y
/// armarlos todos juntos congelaba la página al abrirla (R5: ~370 ms con la CPU
/// a 4x). Todo lo capturado vive en este estado (controladores y selecciones),
/// no en los widgets de cada sección: cambiar de sección, recibir un error o
/// recargar un catálogo no borra nada.
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

  // Lo último que el servidor devolvió al guardar; al abrir, lo que cargó.
  late Descriptivo _saved = widget.descriptivo;

  // Texto libre.
  late final _nombrePuesto = _ctl(_saved.nombrePuesto);
  late final _supervisaA = _ctl(_saved.supervisaA);
  late final _edadOtro = _ctl(_saved.edadOtro);
  late final _diasOtro = _ctl(_saved.diasPorLaborarOtro);
  late final _horarioOtro = _ctl(_saved.horarioOtro);
  late final _proposito = _ctl(_saved.proposito);
  late final _decOperativas = _ctl(_saved.decisionesOperativas);
  late final _decFuncionales = _ctl(_saved.decisionesFuncionales);
  late final _decEstrategicas = _ctl(_saved.decisionesEstrategicas);
  late final _relInternas = _ctl(_saved.relacionesInternas);
  late final _relExternas = _ctl(_saved.relacionesExternas);
  late final _escolaridad = _ctl(_saved.escolaridadMinima);
  late final _experiencia = _ctl(_saved.experienciaRequerida);
  late final _idiomas = _ctl(_saved.idiomas);
  late final _compTecnicas = _ctl(_saved.competenciasTecnicas);
  late final _compOtras = _ctl(_saved.competenciasOtras);
  late final _recursosOtro = _ctl(_saved.recursosOtro);

  // Datos vinculados a la posición: se muestran, no se vuelven a escribir. Solo
  // cambian al incorporar un cambio de la posición (ver _cambiosDeLaPosicion).
  late final Map<String, String> _linked = {
    'empresa': _saved.empresa,
    'area_departamento': _saved.areaDepartamento,
    'reporta_a': _saved.reportaA,
  };

  // Listas numeradas: un campo por renglón.
  late final List<TextEditingController> _funciones = _lines(
    _saved.funciones,
    _defaultFunciones,
  );
  late final List<TextEditingController> _indicadores = _lines(
    _saved.indicadores,
    _defaultIndicadores,
  );

  // Selecciones.
  late DateTime? _fecha = parseIsoDate(_saved.fechaElaboracion);
  late int? _edad = _saved.edad;
  late int? _dias = _saved.diasPorLaborar;
  late int? _horario = _saved.horario;
  late bool? _viajar = _saved.disponibilidadViajar;
  late final Set<int> _competencias = {..._saved.competencias};
  late final Set<int> _recursos = {..._saved.recursos};

  final _all = <TextEditingController>[];
  bool _dirty = false;
  bool _saving = false;
  bool _exporting = false;
  bool _leaving = false;
  String? _error;

  // La sección abierta: es la única que se arma.
  final _scroll = ScrollController();
  int _active = 0;

  // Límites de los campos de una línea, con la sección en la que viven. Una sola
  // fuente: el campo los usa para marcar su error y la validación los revisa
  // aunque su sección no esté abierta (sus campos no existen hasta abrirla).
  late final Map<TextEditingController, ({int section, int limit})> _limits = {
    _nombrePuesto: (section: 0, limit: 150),
    _edadOtro: (section: 0, limit: 100),
    _diasOtro: (section: 0, limit: 100),
    _horarioOtro: (section: 0, limit: 100),
    _compOtras: (section: 3, limit: 255),
    _recursosOtro: (section: 3, limit: 255),
  };

  // Protección de salida (la misma de la requisición).
  late final RequisicionExitGuard _guard;
  late final Future<bool> Function() _exitCallback;
  late final RequisicionBeforeUnload _unload;
  Future<bool>? _confirmation;

  bool get _canManage => ref.read(canManageHrProvider);
  bool get _editable => _canManage && !_saved.estaCongelado;

  TextEditingController _ctl(String text) {
    final controller = TextEditingController(text: text);
    _all.add(controller);
    return controller;
  }

  // Un renglón vacío en el borrador para escribir; en una versión de solo
  // lectura solo los que tienen texto.
  List<TextEditingController> _lines(List<TextoNumerado> items, int minimum) {
    final rows = [for (final item in items) _ctl(item.texto)];
    if (_canManage && !widget.descriptivo.estaCongelado) {
      while (rows.length < minimum) {
        rows.add(_ctl(''));
      }
    }
    return rows;
  }

  @override
  void initState() {
    super.initState();
    _guard = ref.read(requisicionExitGuardProvider);
    _exitCallback = _confirmExit;
    _guard.confirm = _exitCallback;
    _unload = RequisicionBeforeUnload(() => _dirty || _saving);
  }

  @override
  void dispose() {
    if (_guard.confirm == _exitCallback) _guard.confirm = null;
    _unload.dispose();
    _scroll.dispose();
    for (final controller in _all) {
      controller.dispose();
    }
    super.dispose();
  }

  // Cualquier cambio (texto, lista o selección) marca el formulario como
  // modificado: habilita «Guardar borrador» y avisa de lo no guardado.
  void _touch() => setState(() => _dirty = true);

  Future<bool> _confirmExit() async {
    if (_leaving || !_editable) return true;
    if (_saving) return false;
    if (!_dirty) return true;
    final pending = _confirmation;
    if (pending != null) return pending;
    final future = _confirmation = confirmDiscardChanges(
      context,
      message: 'Hay cambios sin guardar en el descriptivo.',
    );
    final discard = await future;
    _confirmation = null;
    if (discard && mounted) setState(() => _leaving = true);
    return discard;
  }

  Future<void> _back() async {
    if (!await _confirmExit() || !mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/reclutamiento/descriptivos');
    }
  }

  Duration get _jumpDuration => MediaQuery.disableAnimationsOf(context)
      ? Duration.zero
      : const Duration(milliseconds: 180);

  /// Abre una sección (y solo entonces se arma), empezando desde arriba.
  Future<void> _show(int section) async {
    if (section == _active || !mounted) return;
    if (_scroll.hasClients) _scroll.jumpTo(0);
    setState(() => _active = section);
    await WidgetsBinding.instance.endOfFrame;
  }

  bool _applies(TextEditingController controller) {
    final c = widget.catalogs;
    if (controller == _edadOtro) return isOtro(entryIn(c.rangosEdad, _edad));
    if (controller == _diasOtro) return isOtro(entryIn(c.dias, _dias));
    if (controller == _horarioOtro) {
      return isOtro(entryIn(c.horarios, _horario));
    }
    return true;
  }

  /// La sección del primer dato que no se puede guardar, o null. Revisa los
  /// datos y no los campos, que solo existen en la sección abierta.
  int? _sectionWithProblem() {
    if (_fecha == null) return 0;
    for (final MapEntry(key: controller, value: rule) in _limits.entries) {
      if (_applies(controller) && controller.text.trim().length > rule.limit) {
        return rule.section;
      }
    }
    return null;
  }

  Descriptivo _snapshot() => _saved.copyWith(
    nombrePuesto: _nombrePuesto.text,
    empresa: _linked['empresa']!,
    areaDepartamento: _linked['area_departamento']!,
    reportaA: _linked['reporta_a']!,
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
    ref.invalidate(descriptivoDetailProvider(_saved.id));
    ref.invalidate(descriptivosPageProvider);
  }

  // Lleva al primer campo con error de la sección abierta.
  void _revealFirstError() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final root = _form.currentContext;
      if (!mounted || root == null) return;
      BuildContext? first;
      void visit(Element element) {
        if (first != null) return;
        if (element is StatefulElement &&
            element.state is FormFieldState &&
            (element.state as FormFieldState).hasError) {
          first = element;
          return;
        }
        element.visitChildren(visit);
      }

      (root as Element).visitChildren(visit);
      final target = first;
      if (target != null) {
        Scrollable.ensureVisible(
          target,
          alignment: .15,
          duration: _jumpDuration,
        );
      }
    });
  }

  Future<bool> _validate() async {
    // Si el problema está en otra sección, se abre para que se vea marcado.
    final problem = _sectionWithProblem();
    if (problem != null) await _show(problem);
    if (!mounted) return false;
    final valid = _form.currentState?.validate() ?? false;
    final ok = valid && problem == null;
    if (!ok) {
      _say('Revisa los campos marcados en rojo.');
      _revealFirstError();
    }
    return ok;
  }

  Future<bool> _save({bool quiet = false}) async {
    if (_saving || !await _validate() || _saving || !mounted) return false;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final saved = await ref
          .read(recruitmentRepositoryProvider)
          .saveDescriptivo(_snapshot());
      ref.invalidate(descriptivoCambiosProvider(_saved.id));
      _reload();
      if (mounted) {
        setState(() {
          _saved = saved;
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

  Future<void> _approve() async {
    if (!await _validate() || !mounted) return;
    // Todo lo que necesita la confirmación se toma antes de abrir el diálogo:
    // si la página se cierra mientras está abierto, no hay estado que consultar
    // y se aprueba exactamente lo que se estaba viendo.
    final repository = ref.read(recruitmentRepositoryProvider);
    final content = _snapshot();
    final done = await showConfirmDialog(
      context,
      title: 'Aprobar versión ${content.version}',
      message: 'Al aprobarla queda como la versión vigente: ya no se podrá modificar ni borrar. Para cambiar algo después se abre un borrador nuevo a partir de ella.',
      confirmLabel: 'Aprobar',
      destructive: false,
      onConfirm: () async {
        // Lo que se está viendo es lo que se aprueba: primero se guarda.
        await repository.saveDescriptivo(content);
        await repository.congelar(content.id);
      },
      errorMessage: recruitmentMutationError,
    );
    if (done && mounted) {
      setState(() => _dirty = false);
      _reload();
      _say('Versión ${content.version} aprobada.');
    }
  }

  Future<void> _copy() async {
    try {
      final nuevo = await ref
          .read(recruitmentRepositoryProvider)
          .copiar(_saved.id);
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
    final repository = ref.read(recruitmentRepositoryProvider);
    final id = _saved.id;
    final done = await showConfirmDialog(
      context,
      title: 'Eliminar borrador',
      message:
          '¿Eliminar el borrador v${_saved.version}? Se pierde lo capturado.',
      onConfirm: () => repository.deleteDescriptivo(id),
      errorMessage: recruitmentMutationError,
    );
    if (done && mounted) {
      // Se confirmó eliminar: ya no hay nada que proteger al salir.
      setState(() => _leaving = true);
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
          .exportarWord(_saved.id);
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
    validator: _limits[controller] == null
        ? null
        : (value) => _limit(value, _limits[controller]!.limit),
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

  Widget _card(String title, List<Widget> children, {String? note}) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
    child: AppCard(
      color: RecruitmentDesign.surface,
      borderColor: RecruitmentDesign.border,
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

  // Una lista numerada: se agregan, se reordenan y se quitan renglones sin
  // recrear el documento. Mover un renglón mueve su controlador, así que el
  // texto (y su foco) viaja con él.
  Widget _numbered(List<TextEditingController> rows, String noun) {
    final capitalized = '${noun[0].toUpperCase()}${noun.substring(1)}';
    void move(int from, int to) {
      setState(() => rows.insert(to, rows.removeAt(from)));
      _touch();
    }

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
                if (_editable) ...[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Subir $noun ${index + 1}',
                        visualDensity: VisualDensity.compact,
                        onPressed: index == 0
                            ? null
                            : () => move(index, index - 1),
                        icon: const Icon(Icons.arrow_upward),
                      ),
                      IconButton(
                        tooltip: 'Bajar $noun ${index + 1}',
                        visualDensity: VisualDensity.compact,
                        onPressed: index == rows.length - 1
                            ? null
                            : () => move(index, index + 1),
                        icon: const Icon(Icons.arrow_downward),
                      ),
                    ],
                  ),
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

  // Empresa, área y «Reporta a» vienen de la posición: se muestran como datos
  // vinculados, no como campos para volver a escribir.
  Widget _vinculados() {
    final type = Theme.of(context).textTheme;
    Widget fila(String label, String key, String missing) => DetailField(
      label,
      _linked[key]!.trim().isEmpty ? missing : _linked[key],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(Icons.link, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.xs),
            Text('Vinculado a la posición', style: type.labelLarge),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          _saved.estaCongelado
              ? 'Estos datos quedaron como estaban al aprobar la versión.'
              : 'Se copiaron de la posición al crear el borrador y no cambian solos. Para corregirlos, cambia la posición.',
          style: type.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        fila('Empresa', 'empresa', 'Sin dato'),
        fila('Área / Departamento', 'area_departamento', 'Sin dato'),
        // Sin jefe registrado en la posición no es lo mismo que «No tiene».
        fila('Reporta a', 'reporta_a', 'Sin relación registrada'),
      ],
    );
  }

  // Si la posición cambió después de crear el borrador, se muestra qué cambió
  // y la persona elige qué incorporar. Lo demás que escribió se conserva.
  //
  // Vive en su propio `Consumer`: la comparación llega después de que el editor
  // ya se armó y, si el `ref.watch` estuviera en el `build` del editor, su
  // llegada lo reconstruiría completo (R5: ~170 ms con la CPU a 4x).
  Widget _cambiosDeLaPosicion() {
    if (!_editable) return const SizedBox.shrink();
    return Consumer(
      builder: (context, ref, _) => _avisoDeCambios(
        context,
        ref.watch(descriptivoCambiosProvider(_saved.id)),
      ),
    );
  }

  Widget _avisoDeCambios(
    BuildContext context,
    AsyncValue<List<CambioPosicion>> cambios,
  ) {
    final type = Theme.of(context).textTheme;
    return cambios.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              'No se pudo revisar si la posición cambió.',
              style: type.bodySmall,
            ),
            TextButton(
              onPressed: () =>
                  ref.invalidate(descriptivoCambiosProvider(_saved.id)),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
      data: (items) {
        final pendientes = [
          for (final cambio in items)
            if (_linked[cambio.campo] != cambio.actual) cambio,
        ];
        if (pendientes.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          child: Semantics(
            container: true,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.warningSurface,
                borderRadius: BorderRadius.circular(AppSpacing.controlRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('La posición tiene cambios', style: type.titleSmall),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Elige cuáles incorporar a este borrador. Lo que ya escribiste se conserva.',
                      style: type.bodySmall,
                    ),
                    for (final cambio in pendientes) ...[
                      const SizedBox(height: AppSpacing.md),
                      Text(cambio.etiqueta, style: type.labelLarge),
                      Text(
                        'En esta versión: ${cambio.guardado.trim().isEmpty ? 'Sin dato' : cambio.guardado}',
                        style: type.bodyMedium,
                      ),
                      Text(
                        'En la posición ahora: ${cambio.actual}',
                        style: type.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppButton(
                          label: 'Incorporar «${cambio.etiqueta}»',
                          variant: AppButtonVariant.secondary,
                          onPressed: () {
                            setState(() {
                              _linked[cambio.campo] = cambio.actual;
                              _dirty = true;
                            });
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String get _versionLabel {
    final aprobada = shownDate(_saved.congeladoEn);
    return switch (_saved.estadoVersion) {
      'borrador' => 'Borrador',
      _ when !_saved.estaCongelado => 'Borrador',
      _ when _saved.esHistorica =>
        aprobada == null ? 'Histórica' : 'Histórica · aprobada el $aprobada',
      _ => aprobada == null ? 'Aprobada' : 'Aprobada el $aprobada',
    };
  }

  AppBadgeTone get _versionTone => !_saved.estaCongelado
      ? AppBadgeTone.warning
      : _saved.esHistorica
      ? AppBadgeTone.neutral
      : AppBadgeTone.success;

  // Lo que siempre se ve arriba: de dónde se vuelve, qué documento es y en qué
  // versión está. Compacto a propósito: el resto se desplaza.
  Widget _header() => RecruitmentEditorHeader(
    title: _saved.nombrePuesto.trim().isNotEmpty
        ? _saved.nombrePuesto
        : _saved.posicionEtiqueta,
    subtitle: 'Descriptivo de puesto · versión ${_saved.version}',
    onBack: _saving ? null : _back,
    status: AppBadge(label: _versionLabel, tone: _versionTone),
  );

  // Descargar, copiar y eliminar: se usan poco, así que viven al inicio del
  // contenido y no ocupan el alto que siempre se ve.
  Widget _acciones() {
    final type = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppButton(
                label: 'Descargar Word oficial',
                icon: Icons.download_outlined,
                variant: AppButtonVariant.secondary,
                isLoading: _exporting,
                onPressed: _export,
              ),
              if (_canManage && _saved.estaCongelado)
                AppButton(
                  label: 'Copiar a un borrador nuevo',
                  icon: Icons.copy_all_outlined,
                  variant: AppButtonVariant.secondary,
                  onPressed: _copy,
                ),
              if (_editable)
                AppButton(
                  label: 'Eliminar borrador',
                  icon: Icons.delete_outline,
                  variant: AppButtonVariant.secondary,
                  onPressed: _delete,
                ),
            ],
          ),
          if (_saved.esHistorica)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                'Hay una versión aprobada más reciente de esta posición.',
                style: type.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  Widget _sectionChips() => RecruitmentSectionTabs(
    labels: _sectionNames,
    selected: _active,
    onSelected: _show,
  );

  // Al terminar una sección, la anterior y la siguiente a un toque.
  Widget _sectionNav() => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
    child: Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        if (_active > 0)
          TextButton.icon(
            onPressed: () => _show(_active - 1),
            icon: const Icon(Icons.arrow_back),
            label: Text('Anterior: ${_sectionNames[_active - 1]}'),
          )
        else
          const SizedBox.shrink(),
        if (_active < _sectionNames.length - 1)
          TextButton.icon(
            onPressed: () => _show(_active + 1),
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.arrow_forward),
            label: Text('Siguiente: ${_sectionNames[_active + 1]}'),
          ),
      ],
    ),
  );

  // Guardar y aprobar siempre a la vista, sin importar la sección. La barra
  // ocupa todo el ancho y sus botones se alinean con la columna del contenido.
  Widget _actionBar() => RecruitmentActionBar(
    status: _saving
        ? 'Guardando…'
        : _dirty
        ? 'Tienes cambios sin guardar.'
        : 'Sin cambios pendientes',
    dirty: _dirty,
    actions: [
      AppButton(
        label: 'Guardar borrador',
        icon: Icons.save_outlined,
        isLoading: _saving,
        onPressed: _dirty ? _save : null,
      ),
      AppButton(
        label: 'Aprobar versión',
        icon: Icons.verified_outlined,
        variant: AppButtonVariant.secondary,
        onPressed: _saving ? null : _approve,
      ),
    ],
  );

  Widget _errorBanner() {
    final type = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Semantics(
        liveRegion: true,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.errorSurface,
            borderRadius: BorderRadius.circular(AppSpacing.controlRadius),
          ),
          child: Text(
            _error!,
            style: type.bodyMedium?.copyWith(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.catalogs;
    final type = Theme.of(context).textTheme;
    final canManage = ref.watch(canManageHrProvider);
    final edad = entryIn(c.rangosEdad, _edad);
    final dias = entryIn(c.dias, _dias);
    final horario = entryIn(c.horarios, _horario);
    // La comparación con la posición se escucha (sin reconstruir el editor) para
    // que no se descarte y se vuelva a pedir cada vez que se cierra
    // «Identificación», que es donde se muestra.
    if (_editable) {
      ref.listen(descriptivoCambiosProvider(_saved.id), (_, _) {});
    }

    return PopScope(
      canPop: !_editable || (!_dirty && !_saving) || _leaving,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _back();
      },
      child: FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: RecruitmentEditorLayout(
          header: _header(),
          tabs: _sectionChips(),
          footer: _editable ? _actionBar() : null,
          child: SingleChildScrollView(
            controller: _scroll,
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _acciones(),
                  if (_error != null) _errorBanner(),
                  if (!canManage)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                      child: Text(
                        'Solo Capital Humano edita los descriptivos. Aquí puedes consultarlo y descargarlo.',
                        style: type.bodySmall,
                      ),
                    ),
                  ...switch (_active) {
                    0 => _identificacion(c, edad, dias, horario),
                    1 => _propositoYFunciones(),
                    2 => _perfil(),
                    3 => _competenciasYRecursos(c),
                    _ => _indicadoresYConformidades(c, canManage),
                  },
                  _sectionNav(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _identificacion(
    DescriptivoCatalogs c,
    RecruitmentCatalogEntry? edad,
    RecruitmentCatalogEntry? dias,
    RecruitmentCatalogEntry? horario,
  ) => [
    SectionTitle(_sectionNames[0], padTop: false),
    _card('Datos del puesto', [
      _vinculados(),
      _cambiosDeLaPosicion(),
      _pair(
        _text('Nombre del puesto', _nombrePuesto),
        AppDateField(
          label: 'Fecha de elaboración / actualización',
          value: _fecha,
          isRequired: true,
          enabled: _editable,
          onChanged: (value) {
            _fecha = value;
            _touch();
          },
        ),
      ),
      _gap,
      _text(
        'Supervisa a',
        _supervisaA,
        multiline: true,
        hint: 'Puestos y número de personas a cargo, si aplica.',
      ),
    ]),
    _card('Condiciones del puesto', [
      _choice('Edad', _edad, c.rangosEdad, (v) => _edad = v),
      if (isOtro(edad)) ...[_gap, _text('Edad (otro)', _edadOtro)],
      _gap,
      DropdownButtonFormField<bool?>(
        key: ValueKey('viajar:$_viajar'),
        initialValue: _viajar,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: 'Disponibilidad para viajar',
        ),
        items: const [
          DropdownMenuItem<bool?>(value: null, child: Text('Sin definir')),
          DropdownMenuItem<bool?>(value: true, child: Text('Sí')),
          DropdownMenuItem<bool?>(value: false, child: Text('No')),
        ],
        onChanged: _editable
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
      if (isOtro(dias)) ...[_gap, _text('Días por laborar (otro)', _diasOtro)],
      _gap,
      _choice(
        'Horario por cubrir',
        _horario,
        c.horarios,
        (v) => setState(() => _horario = v),
      ),
      if (isOtro(horario)) ...[_gap, _text('Horario (otro)', _horarioOtro)],
    ]),
  ];

  List<Widget> _propositoYFunciones() => [
    SectionTitle(_sectionNames[1], padTop: false),
    _card('Propósito del puesto', [
      _text('Propósito', _proposito, multiline: true),
    ]),
    _card('Funciones y responsabilidades', [
      _numbered(_funciones, 'responsabilidad'),
    ], note: 'Los renglones vacíos no se guardan. El orden es el de la lista.'),
    _card('Toma de decisiones', [
      _text('Decisiones operativas', _decOperativas, multiline: true),
      _gap,
      _text('Decisiones funcionales', _decFuncionales, multiline: true),
      _gap,
      _text('Decisiones estratégicas', _decEstrategicas, multiline: true),
    ]),
    _card('Relaciones', [
      _text('Relaciones internas', _relInternas, multiline: true),
      _gap,
      _text('Relaciones externas', _relExternas, multiline: true),
    ]),
  ];

  List<Widget> _perfil() => [
    SectionTitle(_sectionNames[2], padTop: false),
    _card('Perfil del puesto', [
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
  ];

  List<Widget> _competenciasYRecursos(DescriptivoCatalogs c) => [
    SectionTitle(_sectionNames[3], padTop: false),
    _card('Competencias conductuales', [
      _checks(c.competencias, _competencias),
      _gap,
      _text('Otras competencias', _compOtras),
    ]),
    _card('Recursos necesarios', [
      _checks(c.recursos, _recursos),
      _gap,
      _text('Otros recursos', _recursosOtro),
    ]),
  ];

  List<Widget> _indicadoresYConformidades(
    DescriptivoCatalogs c,
    bool canManage,
  ) => [
    SectionTitle(_sectionNames[4], padTop: false),
    _card('Indicadores de desempeño', [_numbered(_indicadores, 'indicador')]),
    if (canManage && _saved.estaCongelado)
      Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
        child: ConformidadesCard(
          // El último que cargó el servidor: así las firmas recién
          // registradas aparecen al recargar.
          descriptivo: widget.descriptivo,
          roles: c.roles,
          onChanged: _reload,
        ),
      ),
  ];
}
