import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/session_controller.dart';
import '../../../core/design_system/spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_date_field.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/feature_page.dart';
import '../../../core/widgets/search_picker_field.dart';
import '../application/recruitment_controller.dart';
import '../application/requisicion_exit_guard.dart';
import '../data/recruitment_catalogs.dart';
import '../data/recruitment_models.dart';
import '../data/recruitment_repository.dart';
import 'discard_changes_dialog.dart';
import 'posicion_contexto_card.dart';
import 'recruitment_ui.dart';
import 'requisiciones_page.dart';
import 'requisicion_before_unload.dart';

class RequisicionEditPage extends ConsumerWidget {
  const RequisicionEditPage({
    super.key,
    this.requisicionId,
    this.posicionId,
    this.initialRequisicion,
  });
  final String? requisicionId;
  final String? posicionId;
  final Requisicion? initialRequisicion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (requisicionId == null) {
      return _RequisicionEditor(
        key: ValueKey(posicionId),
        posicionId: posicionId,
      );
    }
    final data = initialRequisicion == null
        ? ref.watch(requisicionDetailProvider(requisicionId!))
        : AsyncData(initialRequisicion!);
    return data.when(
      loading: () => const FeatureLoading(),
      error: (error, _) => FeatureError(
        error: error,
        onRetry: () =>
            ref.invalidate(requisicionDetailProvider(requisicionId!)),
      ),
      data: (r) {
        if (!canEditRequisicion(
          r,
          canManage: ref.watch(canManageHrProvider),
          me: ref.watch(sessionControllerProvider).user?.id,
        )) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!context.mounted) return;
            context.go('/reclutamiento/requisiciones/${r.id}');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No puedes editar esta requisición.'),
              ),
            );
          });
          return const SizedBox.shrink();
        }
        return _RequisicionEditor(key: ValueKey(r.id), requisicion: r);
      },
    );
  }
}

class _RequisicionEditor extends ConsumerStatefulWidget {
  const _RequisicionEditor({super.key, this.requisicion, this.posicionId});
  final Requisicion? requisicion;
  final String? posicionId;
  @override
  ConsumerState<_RequisicionEditor> createState() => _RequisicionEditorState();
}

class _RequisicionEditorState extends ConsumerState<_RequisicionEditor> {
  final _form = GlobalKey<FormState>();
  late Requisicion? _current = widget.requisicion;

  PosicionElegible? _posicionElegida;
  late String? _posicionContextoId = _current == null
      ? widget.posicionId
      : _current!.posicion;
  late bool _selectorVisible = widget.posicionId == null;
  PosicionElegible? get _posicion =>
      _posicionElegida ??
      (_posicionContextoId == null
          ? null
          : ref
                .read(
                  posicionContextoProvider((
                    _posicionContextoId!,
                    'requisicion',
                  )),
                )
                .value
                ?.elegible);
  String? _posicionError;
  int _posicionAttention = 0;
  late int? _tipo = _current?.tipo;
  late DateTime? _fechaSolicitud =
      parseIsoDate(_current?.fechaSolicitud) ?? DateTime.now();
  late DateTime? _fechaACubrir = parseIsoDate(_current?.fechaACubrirVacante);
  late DateTime? _fechaEntrega = parseIsoDate(
    _current?.fechaEntregaACapitalHumano,
  );
  late int? _horario = _current?.horarioACubrir;
  late int? _contrato = _current?.tipoContratoOfrecido;
  late bool? _viajar = _current?.disposicionViajar;

  late AreaSolicitante? _area = _current?.areaSolicitante == null
      ? null
      : AreaSolicitante(
          id: _current!.areaSolicitante!,
          name: _current!.areaSolicitanteNombre ?? 'Sin dato',
        );
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

  bool _busy = false;
  bool _sending = false;
  bool _leaving = false;
  String? _error;
  final _fieldErrors = <String, String>{};
  // Valor del campo en el momento en que se le marcó el error: en cuanto el
  // usuario lo cambia, el error deja de aplicar y se quita.
  final _errorSnapshot = <String, Object?>{};
  final _anchors = <String, GlobalKey>{};
  final _focus = <String, FocusNode>{};
  final _sections = List.generate(4, (_) => GlobalKey());
  final _scroll = ScrollController();
  static const _sectionNames = [
    'Solicitud',
    'Condiciones',
    'Compensación',
    'Revisión',
  ];
  int _active = 0;
  bool _areaTouched = false;
  bool _areaSuggested = false;
  int _areaRevision = 0;
  late Map<String, Object?> _initial;
  late RequisicionExitGuard _guard;
  late Future<bool> Function() _exitCallback;
  late RequisicionBeforeUnload _unload;
  Future<bool>? _confirmation;
  List<TextEditingController> get _controllers => [
    _justificacion,
    _idiomas,
    _nivel,
    _compuesto,
    _bruto,
    _neto,
  ];

  Map<String, Object?> get _values => {
    'posicion': _current?.posicion ?? _posicionContextoId,
    'tipo': _tipo,
    'fecha_solicitud': _fechaSolicitud == null
        ? null
        : toIsoDate(_fechaSolicitud!),
    'fecha_a_cubrir_vacante': _fechaACubrir == null
        ? null
        : toIsoDate(_fechaACubrir!),
    'fecha_entrega_a_capital_humano': _fechaEntrega == null
        ? null
        : toIsoDate(_fechaEntrega!),
    'area_solicitante': _area?.id,
    'justificacion': _justificacion.text,
    'horario_a_cubrir': _horario,
    'idiomas_requeridos': _idiomas.text,
    'disposicion_viajar': _viajar,
    'nivel_tabulador': _nivel.text,
    'sueldo_mensual_compuesto': _compuesto.text,
    'sueldo_mensual_bruto': _bruto.text,
    'sueldo_mensual_neto': _neto.text,
    'tipo_contrato_ofrecido': _contrato,
  };
  bool get _dirty => _values.entries.any((e) => _initial[e.key] != e.value);

  @override
  void initState() {
    super.initState();
    _initial = Map.of(_values);
    for (final c in _controllers) {
      c.addListener(_changed);
    }
    _scroll.addListener(_updateSection);
    _guard = ref.read(requisicionExitGuardProvider);
    _exitCallback = _confirmExit;
    _guard.confirm = _exitCallback;
    _unload = RequisicionBeforeUnload(() => _dirty || _busy);
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    if (_guard.confirm == _exitCallback) _guard.confirm = null;
    _unload.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focus.values) {
      f.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  Future<bool> _confirmExit() async {
    if (_leaving) return true;
    if (_busy) return false;
    if (!_dirty) return true;
    if (_confirmation != null) return _confirmation!;
    _confirmation = confirmDiscardChanges(
      context,
      message: 'Hay cambios sin guardar en la requisición.',
    );
    final discard = await _confirmation!;
    _confirmation = null;
    if (discard && mounted) setState(() => _leaving = true);
    return discard;
  }

  Future<void> _back() async {
    if (!await _confirmExit() || !mounted) return;
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/reclutamiento');
    }
  }

  void _updateSection() {
    int active = 0;
    final viewport = _sections[0].currentContext
        ?.findAncestorStateOfType<ScrollableState>()
        ?.context
        .findRenderObject();
    if (viewport is! RenderBox) return;
    final top = viewport.localToGlobal(Offset.zero).dy;
    for (int i = 0; i < _sections.length; i++) {
      final box = _sections[i].currentContext?.findRenderObject();
      if (box is RenderBox && box.localToGlobal(Offset.zero).dy <= top + 100) {
        active = i;
      }
    }
    if (active != _active && mounted) setState(() => _active = active);
  }

  Future<void> _jump(int section) async {
    final target = _sections[section].currentContext;
    if (target == null) return;
    await Scrollable.ensureVisible(
      target,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 180),
    );
    if (mounted) setState(() => _active = section);
  }

  int _sectionFor(String field) =>
      [
        'horario_a_cubrir',
        'idiomas_requeridos',
        'disposicion_viajar',
      ].contains(field)
      ? 1
      : [
          'nivel_tabulador',
          'sueldo_mensual_compuesto',
          'sueldo_mensual_bruto',
          'sueldo_mensual_neto',
          'tipo_contrato_ofrecido',
        ].contains(field)
      ? 2
      : 0;
  Widget _field(String name, Widget child) => Focus(
    key: _anchors.putIfAbsent(name, () => GlobalKey()),
    focusNode: _focus.putIfAbsent(name, () => FocusNode(debugLabel: name)),
    skipTraversal: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        child,
        if (_fieldErrors[name] != null &&
            ![
              'justificacion',
              'tipo',
              'posicion',
              'area_solicitante',
            ].contains(name))
          Text(
            _fieldErrors[name]!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    ),
  );
  void _focusError() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted || _fieldErrors.isEmpty) return;
      final name = _values.keys.firstWhere(
        (key) => _fieldErrors.containsKey(key),
        orElse: () => _fieldErrors.keys.first,
      );
      final target = _anchors[name]?.currentContext;
      if (target == null) return;
      await Scrollable.ensureVisible(
        target,
        duration: Duration.zero,
        alignment: .15,
      );
      if (!mounted || !target.mounted) return;
      // Los campos compartidos conservan su foco; se pide el del control real.
      EditableText? editable;
      void visit(Element element) {
        if (element.widget is EditableText) {
          editable ??= element.widget as EditableText;
        }
        element.visitChildElements(visit);
      }

      target.visitChildElements(visit);
      if (editable != null) {
        editable!.focusNode.requestFocus();
      } else {
        final fieldFocus = _focus[name];
        (fieldFocus?.traversalDescendants.firstOrNull ?? fieldFocus)
            ?.requestFocus();
      }
      setState(() => _active = _sectionFor(name));
    });
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

  Future<void> _save(RequisicionCatalogs catalogs, {required bool send}) async {
    if (_busy || (_current == null && _posicion?.tramiteAbierto != null)) {
      return;
    }
    setState(() {
      _fieldErrors.clear();
      _errorSnapshot.clear();
      _error = null;
    });
    final valid = _form.currentState!.validate();
    if (_current == null && _posicion == null) {
      setState(() {
        _posicionError = 'Elige la posición de la lista.';
        _posicionAttention++;
        _fieldErrors['posicion'] = _posicionError!;
        _errorSnapshot['posicion'] = _values['posicion'];
      });
      _focusError();
      return;
    }
    if (_tipo == null) {
      _fieldErrors['tipo'] = 'Elige el tipo.';
      _errorSnapshot['tipo'] = _values['tipo'];
      _focusError();
    }
    if (!valid) return;
    final estado = send
        ? entryByCode(catalogs.estados, 'pendiente-de-autorizacion')
        : _current == null ||
              entryIn(catalogs.estados, _current?.estado)?.code == 'borrador'
        ? entryByCode(catalogs.estados, 'borrador')
        : entryIn(catalogs.estados, _current?.estado);
    if (estado == null) {
      setState(() => _error = 'El estado solicitado no está disponible.');
      return;
    }
    setState(() {
      _busy = true;
      _sending = send;
    });
    try {
      final saved = await ref
          .read(recruitmentRepositoryProvider)
          .saveRequisicion(
            Requisicion(
              id: _current?.id ?? '',
              posicion: _current?.posicion ?? _posicion!.id,
              posicionEtiqueta:
                  _current?.posicionEtiqueta ?? _posicion!.etiqueta,
              creadoPor:
                  _current?.creadoPor ??
                  ref.read(sessionControllerProvider).user?.id,
              tipo: _tipo!,
              estado: estado.id,
              fechaSolicitud: toIsoDate(_fechaSolicitud!),
              fechaACubrirVacante: _fechaACubrir == null
                  ? null
                  : toIsoDate(_fechaACubrir!),
              fechaEntregaACapitalHumano: _fechaEntrega == null
                  ? null
                  : toIsoDate(_fechaEntrega!),
              areaSolicitante: _area?.id,
              areaSolicitanteNombre: _area?.name,
              justificacion: _justificacion.text,
              horarioACubrir: _horario,
              idiomasRequeridos: _idiomas.text,
              disposicionViajar: _viajar,
              nivelTabulador: _nivel.text,
              sueldoMensualCompuesto: _compuesto.text,
              sueldoMensualBruto: _bruto.text,
              sueldoMensualNeto: _neto.text,
              tipoContratoOfrecido: _contrato,
              motivoSuspension: _current?.motivoSuspension ?? '',
              fechaSuspension: _current?.fechaSuspension,
              autorizadoPorSuspension: _current?.autorizadoPorSuspension ?? '',
            ),
            creating: _current == null,
          );
      if (!mounted) return;
      final creating = _current == null;
      setState(() {
        _current = saved;
        _initial = Map.of(_values);
        _busy = false;
      });
      ref.invalidate(requisicionesPageProvider);
      ref.invalidate(requisicionDetailProvider(saved.id));
      ref.invalidate(posicionContextoProvider((saved.posicion, 'requisicion')));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            send ? 'Requisición enviada.' : 'Requisición guardada.',
          ),
        ),
      );
      if (send || creating) {
        setState(() => _leaving = true);
        context.go(
          send
              ? '/reclutamiento/requisiciones/${saved.id}'
              : '/reclutamiento/requisiciones/${saved.id}/editar',
          extra: send ? null : saved,
        );
      }
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        if (error is DioException &&
            error.response?.statusCode == 400 &&
            error.response?.data is Map) {
          final data = error.response!.data as Map;
          final general = <String>[];
          for (final entry in data.entries) {
            final message = entry.value is List
                ? (entry.value as List).join(' ')
                : entry.value.toString();
            if (_values.containsKey(entry.key)) {
              _fieldErrors[entry.key as String] = message;
              _errorSnapshot[entry.key as String] = _values[entry.key];
            } else {
              general.add(message);
            }
          }
          _error = general.isEmpty ? null : general.join(' ');
        } else {
          _error = recruitmentMutationError(error);
        }
      });
      _form.currentState?.validate();
      _focusError();
    }
  }

  RecruitmentCatalogEntry? entryByCode(
    List<RecruitmentCatalogEntry> entries,
    String code,
  ) => entries.where((e) => e.code == code).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final values = _values;
    _fieldErrors.removeWhere(
      (name, _) =>
          _errorSnapshot.containsKey(name) &&
          _errorSnapshot[name] != values[name],
    );
    _errorSnapshot.removeWhere((name, _) => !_fieldErrors.containsKey(name));
    final catalogs = ref.watch(requisicionCatalogsProvider);
    if (_posicionContextoId != null) {
      final provider = posicionContextoProvider((
        _posicionContextoId!,
        'requisicion',
      ));
      final data = ref.watch(provider).value;
      final suggestion = data?.areaSolicitanteSugerida;
      if (_current == null &&
          !_areaTouched &&
          _area == null &&
          suggestion != null) {
        final position = _posicionContextoId;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted ||
              _current != null ||
              _areaTouched ||
              _area != null ||
              position != _posicionContextoId) {
            return;
          }
          setState(() {
            _area = suggestion;
            _areaSuggested = true;
            _areaRevision++;
            if (position == widget.posicionId &&
                _initial['posicion'] == position) {
              _initial['area_solicitante'] = suggestion.id;
            }
          });
        });
      }
    }
    final draft =
        _current == null ||
        entryIn(catalogs.value?.estados ?? [], _current?.estado)?.code ==
            'borrador';
    final canSave =
        catalogs.hasValue &&
        (_posicionContextoId == null || _posicion != null) &&
        (_current != null || _posicion?.tramiteAbierto == null);
    return PopScope(
      canPop: (!_dirty && !_busy) || _leaving,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _back();
      },
      child: FocusTraversalGroup(
        policy: WidgetOrderTraversalPolicy(),
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 820),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: _busy ? null : _back,
                              child: const Text('Volver'),
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                _current == null
                                    ? 'Nueva requisición'
                                    : 'Editar requisición',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        child: Row(
                          children: [
                            for (var i = 0; i < _sectionNames.length; i++)
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: AppSpacing.sm,
                                ),
                                child: ChoiceChip(
                                  label: Text(_sectionNames[i]),
                                  chipAnimationStyle:
                                      MediaQuery.disableAnimationsOf(context)
                                      ? ChipAnimationStyle(
                                          enableAnimation:
                                              AnimationStyle.noAnimation,
                                          selectAnimation:
                                              AnimationStyle.noAnimation,
                                          avatarDrawerAnimation:
                                              AnimationStyle.noAnimation,
                                          deleteDrawerAnimation:
                                              AnimationStyle.noAnimation,
                                        )
                                      : null,
                                  selected: i == _active,
                                  onSelected: (_) => _jump(i),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scroll,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_posicionContextoId != null)
                                PosicionContextoCard(
                                  posicionId: _posicionContextoId!,
                                  para: 'requisicion',
                                ),
                              if (_error != null)
                                Semantics(
                                  liveRegion: true,
                                  child: Text(
                                    _error!,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .error,
                                    ),
                                  ),
                                ),
                              catalogs.when(
                                data: _fields,
                                loading: () => const FeatureLoading(),
                                error: (error, _) => FeatureError(
                                  error: error,
                                  onRetry: () => ref.invalidate(
                                    requisicionCatalogsProvider,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  alignment: WrapAlignment.end,
                  children: [
                    AppButton(
                      label: draft ? 'Guardar borrador' : 'Guardar cambios',
                      variant: draft
                          ? AppButtonVariant.secondary
                          : AppButtonVariant.primary,
                      isLoading: _busy && !_sending,
                      onPressed: !canSave || _busy
                          ? null
                          : () => _save(catalogs.requireValue, send: false),
                    ),
                    if (draft)
                      AppButton(
                        label: 'Enviar a autorización',
                        isLoading: _busy && _sending,
                        onPressed: !canSave || _busy
                            ? null
                            : () => _save(catalogs.requireValue, send: true),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fields(RequisicionCatalogs catalogs) {
    final canManage = ref.watch(canManageHrProvider);
    final creating = _current == null;
    final tipo = entryIn(catalogs.tipos, _tipo);
    return Form(
      key: _form,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionTitle('Solicitud', key: _sections[0], padTop: false),
          if (creating && _selectorVisible)
            _field(
              'posicion',
              SearchPickerField<PosicionElegible>(
                label: 'Posición',
                hint: 'Escribe puesto, unidad o área',
                enabled: !_busy,
                suggestOnFocus: true,
                errorText: _fieldErrors['posicion'] ?? _posicionError,
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
                  _posicionElegida = posicion;
                  _posicionContextoId = posicion?.id;
                  if (posicion != null && widget.posicionId != null) {
                    _selectorVisible = false;
                  }
                  _posicionError = null;
                }),
              ),
            )
          else if (!creating)
            _field(
              'posicion',
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Posición',
                  errorText: _fieldErrors['posicion'],
                ),
                child: Text(_current!.posicionEtiqueta),
              ),
            ),
          if (creating && _posicionContextoId != null)
            TextButton(
              onPressed: _busy
                  ? null
                  : () => setState(() {
                      _posicionElegida = null;
                      _posicionContextoId = null;
                      _selectorVisible = true;
                      _posicionError = null;
                    }),
              child: const Text('Cambiar posición'),
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
                    context.go('/reclutamiento/requisiciones/$id');
                  },
                  child: const Text('Abrir'),
                ),
              ),
          ],
          const SizedBox(height: AppSpacing.lg),
          _field(
            'tipo',
            DropdownButtonFormField<int>(
              initialValue: _tipo,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Tipo de requisición',
              ),
              items: [
                for (final item in catalogs.tipos)
                  DropdownMenuItem(value: item.id, child: Text(item.name)),
              ],
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _tipo = value),
              validator: (value) =>
                  _fieldErrors['tipo'] ??
                  (value == null ? 'Elige el tipo.' : null),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _field(
            'fecha_solicitud',
            AppDateField(
              label: 'Fecha de solicitud',
              value: _fechaSolicitud,
              isRequired: true,
              enabled: !_busy,
              onChanged: (value) => setState(() => _fechaSolicitud = value),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _field(
            'fecha_a_cubrir_vacante',
            AppDateField(
              label: 'Fecha a cubrir la vacante',
              value: _fechaACubrir,
              enabled: !_busy,
              onChanged: (value) => setState(() => _fechaACubrir = value),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _field(
            'fecha_entrega_a_capital_humano',
            AppDateField(
              label: 'Fecha de entrega a Capital Humano',
              value: _fechaEntrega,
              enabled: !_busy,
              onChanged: (value) => setState(() => _fechaEntrega = value),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _field(
            'area_solicitante',
            SearchPickerField<AreaSolicitante>(
              key: ValueKey(_areaRevision),
              label: 'Área solicitante',
              errorText: _fieldErrors['area_solicitante'],
              minChars: 1,
              hint: 'Escribe el departamento',
              initialValue: _area,
              enabled: !_busy,
              suggestOnFocus: true,
              helpText: _areaSuggested
                  ? 'Sugerida a partir del área de la posición.'
                  : 'Elige un área de la lista o escribe su nombre.',
              emptyText: canManage ? null : 'No está en la lista. Pídele a Capital Humano que la agregue.',
              emptyQueryText: canManage
                  ? 'Todavía no hay áreas. Escribe un nombre para agregar la primera.'
                  : 'Todavía no hay áreas registradas. Pídele a Capital Humano que las agregue.',
              search: (text) => ref
                  .read(recruitmentRepositoryProvider)
                  .areasSolicitantes(search: text),
              labelOf: (area) => area.name,
              onCreate: canManage
                  ? ref.read(recruitmentRepositoryProvider).crearAreaSolicitante
                  : null,
              onChanged: (area) => setState(() {
                _area = area;
                _areaTouched = true;
                _areaSuggested = false;
              }),
            ),
          ),
          if (_area != null)
            TextButton(
              onPressed: _busy
                  ? null
                  : () => setState(() {
                      _area = null;
                      _areaTouched = true;
                      _areaSuggested = false;
                      _areaRevision++;
                    }),
              child: const Text('Quitar área'),
            ),
          const SectionTitle('Justificación'),
          _field(
            'justificacion',
            AppTextField(
              label: tipo?.requiereJustificacion ?? false
                  ? 'Justificación de la requisición (obligatoria para este tipo)'
                  : 'Justificación de la requisición (opcional)',
              controller: _justificacion,
              enabled: !_busy,
              maxLines: null,
              minLines: 3,
              validator: (value) => _fieldErrors['justificacion'],
            ),
          ),
          SectionTitle('Condiciones', key: _sections[1]),
          _field(
            'horario_a_cubrir',
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
                  DropdownMenuItem<int?>(
                    value: item.id,
                    child: Text(item.name),
                  ),
              ],
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _horario = value),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _field(
            'idiomas_requeridos',
            AppTextField(
              label: 'Idiomas requeridos',
              controller: _idiomas,
              enabled: !_busy,
              validator: (value) => _limit(value, 150),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _field(
            'disposicion_viajar',
            DropdownButtonFormField<bool?>(
              initialValue: _viajar,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Disposición para viajar',
              ),
              items: const [
                DropdownMenuItem<bool?>(
                  value: null,
                  child: Text('Sin definir'),
                ),
                DropdownMenuItem<bool?>(value: true, child: Text('Sí')),
                DropdownMenuItem<bool?>(value: false, child: Text('No')),
              ],
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _viajar = value),
            ),
          ),
          SectionTitle('Compensación', key: _sections[2]),
          _field(
            'nivel_tabulador',
            AppTextField(
              label: 'Nivel de tabulador',
              controller: _nivel,
              enabled: !_busy,
              validator: (value) => _limit(value, 50),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final (label, controller, field) in [
            (
              'Sueldo mensual compuesto',
              _compuesto,
              'sueldo_mensual_compuesto',
            ),
            ('Sueldo mensual bruto', _bruto, 'sueldo_mensual_bruto'),
            ('Sueldo mensual neto', _neto, 'sueldo_mensual_neto'),
          ]) ...[
            _field(
              field,
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
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
          _field(
            'tipo_contrato_ofrecido',
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
                  DropdownMenuItem<int?>(
                    value: item.id,
                    child: Text(item.name),
                  ),
              ],
              onChanged: _busy
                  ? null
                  : (value) => setState(() => _contrato = value),
            ),
          ),

          SectionTitle('Revisión', key: _sections[3]),
          for (final (label, value) in [
            ('Posición', _current?.posicionEtiqueta ?? _posicion?.etiqueta),
            ('Tipo de requisición', tipo?.name),
            ('Justificación', _justificacion.text),
            (
              'Fecha de solicitud',
              _fechaSolicitud == null
                  ? null
                  : shownDate(toIsoDate(_fechaSolicitud!)),
            ),
            (
              'Fecha a cubrir la vacante',
              _fechaACubrir == null
                  ? null
                  : shownDate(toIsoDate(_fechaACubrir!)),
            ),
            (
              'Fecha de entrega a Capital Humano',
              _fechaEntrega == null
                  ? null
                  : shownDate(toIsoDate(_fechaEntrega!)),
            ),
            ('Área solicitante', _area?.name),
            ('Horario a cubrir', nameIn(catalogs.horarios, _horario)),
            ('Idiomas requeridos', _idiomas.text),
            (
              'Disposición para viajar',
              _viajar == null
                  ? null
                  : _viajar!
                  ? 'Sí'
                  : 'No',
            ),
            ('Nivel de tabulador', _nivel.text),
            ('Sueldo mensual compuesto', _compuesto.text),
            ('Sueldo mensual bruto', _bruto.text),
            ('Sueldo mensual neto', _neto.text),
            (
              'Tipo de contrato ofrecido',
              nameIn(catalogs.tiposContrato, _contrato),
            ),
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                '$label: ${value == null || value.isEmpty ? 'Sin definir' : value}',
              ),
            ),
          if ((tipo?.requiereJustificacion ?? false) &&
              _justificacion.text.trim().isEmpty) ...[
            const Text('Falta la justificación para enviar a autorización.'),
            TextButton(
              onPressed: () => _jump(0),
              child: const Text('Ir a Solicitud'),
            ),
          ],
        ],
      ),
    );
  }
}
