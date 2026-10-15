import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import 'app_badge.dart';
import 'app_overlays.dart';
import 'search_picker_create_dialog.dart';

/// Selector que busca en el servidor, espera [debounce] al escribir y descarta
/// respuestas superadas. [suggestOnFocus] permite consultar sin texto.
class SearchPickerField<T extends Object> extends StatefulWidget {
  const SearchPickerField({
    super.key,
    required this.label,
    required this.search,
    required this.labelOf,
    required this.onChanged,
    this.hint,
    this.detailOf,
    this.badgeOf,
    this.errorText,
    this.enabled = true,
    this.initialText,
    this.initialValue,
    this.onCreate,
    this.emptyText,
    this.emptyQueryText,
    this.helpText = 'Elige una sugerencia o escribe puesto, unidad o área',
    this.suggestOnFocus = false,
    this.attention = 0,
    this.debounce = const Duration(milliseconds: 300),
    this.minChars = 2,
  });

  final String label;
  final String? hint;
  final Future<List<T>> Function(String text) search;
  final String Function(T item) labelOf;
  final String? Function(T item)? detailOf;
  final String? Function(T item)? badgeOf;
  final ValueChanged<T?> onChanged;
  final String? errorText;
  final bool enabled;
  final String? initialText;
  final T? initialValue;
  final Future<T> Function(String text)? onCreate;
  final String? emptyText;
  final String? emptyQueryText;
  final String helpText;
  final bool suggestOnFocus;

  /// El formulario sube este contador cada vez que falla la validación del
  /// campo. Solo entonces (y con [errorText] puesto) el selector toma el foco
  /// y reabre las coincidencias; sin él, cualquier reconstrucción del
  /// formulario con el error visible le quitaría el foco a otro campo.
  final int attention;
  final Duration debounce;
  final int minChars;

  @override
  State<SearchPickerField<T>> createState() => _SearchPickerFieldState<T>();
}

sealed class _PickerOption<T extends Object> {
  const _PickerOption();
}

class _PickerItem<T extends Object> extends _PickerOption<T> {
  const _PickerItem(this.item);
  final T item;
}

class _PickerLoading<T extends Object> extends _PickerOption<T> {
  const _PickerLoading();
}

class _PickerCreate<T extends Object> extends _PickerOption<T> {
  const _PickerCreate(this.text);
  final String text;
}

String _nombreComparable(String text) {
  const acentos = {
    'a': 'áàâäãåāăą',
    'e': 'éèêëēĕėęě',
    'i': 'íìîïĩīĭį',
    'o': 'óòôöõōŏő',
    'u': 'úùûüũūŭůűų',
    'n': 'ñńň',
    'c': 'çćč',
    's': 'śš',
    'z': 'źżž',
    'y': 'ýÿ',
  };
  var nombre = text.toLowerCase().replaceAll(RegExp(r'[\u0300-\u036f]'), '');
  for (final entry in acentos.entries) {
    nombre = nombre.replaceAll(RegExp('[${entry.value}]'), entry.key);
  }
  return nombre.trim().replaceAll(RegExp(r'\s+'), ' ');
}

class _PickerEmpty<T extends Object> extends _PickerOption<T> {
  const _PickerEmpty(this.text);
  final String text;
}

class _PickerError<T extends Object> extends _PickerOption<T> {
  const _PickerError();
}

class _PickerIdle<T extends Object> extends _PickerOption<T> {
  const _PickerIdle();
}

class _PickerTextController extends TextEditingController {
  _PickerTextController({super.text});
  void refreshOptions() => notifyListeners();
}

class _SearchPickerFieldState<T extends Object>
    extends State<SearchPickerField<T>> {
  late final _controller = _PickerTextController(
    text:
        widget.initialText ??
        (widget.initialValue == null
            ? null
            : widget.labelOf(widget.initialValue!)),
  );
  final _focusNode = FocusNode();
  final _fieldKey = GlobalKey();
  Timer? _timer;
  int _search = 0;
  int _revision = 0;
  late String _lastText = _controller.text;
  late T? _selected = widget.initialValue;
  bool _creating = false;
  List<_PickerOption<T>> _options = [_PickerIdle<T>()];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(SearchPickerField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && oldWidget.enabled) {
      _timer?.cancel();
      _search++;
      _focusNode.unfocus();
    }
    if (widget.errorText != null && widget.attention != oldWidget.attention) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !widget.enabled || _selected != null) return;
        _focusNode.requestFocus();
        _startSearch(immediate: true, force: true);
      });
    }
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && _selected == null && !_creating) {
      _startSearch(immediate: true);
    }
  }

  void _onTextChanged() {
    if (_lastText == _controller.text) return;
    _lastText = _controller.text;
    final selected = _selected;
    if (selected != null && _controller.text != widget.labelOf(selected)) {
      _selected = null;
      widget.onChanged(null);
    }
    _startSearch();
  }

  void _publish(List<_PickerOption<T>> options) {
    setState(() {
      _options = options;
      _revision++;
    });
    // RawAutocomplete solo actualiza opciones cuando cambia el texto. Una
    // respuesta o un reintento renueva su estado; la clave del campo conserva
    // su conexión de teclado además del texto y el foco.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _controller.refreshOptions();
    });
  }

  void _startSearch({bool immediate = false, bool force = false}) {
    _timer?.cancel();
    final id = ++_search;
    final text = _controller.text.trim();
    final selected = _selected;
    if (!widget.enabled ||
        (selected != null && text == widget.labelOf(selected)) ||
        (!force &&
            text.length < widget.minChars &&
            !(widget.onCreate != null && text.isNotEmpty) &&
            !(text.isEmpty && widget.suggestOnFocus))) {
      _publish([_PickerIdle<T>()]);
      return;
    }
    _publish([_PickerLoading<T>()]);
    _timer = Timer(immediate ? Duration.zero : widget.debounce, () async {
      try {
        final result = await widget.search(text);
        if (!mounted || id != _search) return;
        final puedeAgregar =
            widget.onCreate != null &&
            text.isNotEmpty &&
            !result.any(
              (item) =>
                  _nombreComparable(widget.labelOf(item)) ==
                  _nombreComparable(text),
            );
        _publish([
          if (result.isEmpty) _PickerEmpty<T>(text),
          for (final item in result) _PickerItem<T>(item),
          if (puedeAgregar) _PickerCreate<T>(text),
        ]);
      } on Object {
        if (mounted && id == _search) _publish([_PickerError<T>()]);
      }
    });
  }

  void _select(T item) {
    _timer?.cancel();
    _search++;
    _selected = item;
    if (_controller.text != widget.labelOf(item)) {
      _controller.text = widget.labelOf(item);
    }
    _publish([_PickerIdle<T>()]);
    widget.onChanged(item);
  }

  Future<void> _create(String text) async {
    if (_creating || !widget.enabled || widget.onCreate == null) return;
    _creating = true;
    _timer?.cancel();
    _search++;
    _focusNode.unfocus();
    _publish([_PickerIdle<T>()]);
    final created = await showAppDialog<T>(
      context: context,
      builder: (_) => SearchPickerCreateDialog<T>(
        label: widget.label,
        name: text,
        onCreate: widget.onCreate!,
      ),
    );
    if (!mounted) return;
    if (created != null) _select(created);
    _creating = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.enabled) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RawAutocomplete<_PickerOption<T>>(
          key: ValueKey(_revision),
          textEditingController: _controller,
          focusNode: _focusNode,
          displayStringForOption: (option) => option is _PickerItem<T>
              ? widget.labelOf(option.item)
              : _controller.text,
          // Sin nada que mostrar no hay lista: así Escape le llega a la
          // ventana (la cierra) en lugar de «cerrar» una lista invisible.
          optionsBuilder: (_) =>
              _options.first is _PickerIdle<T> ? const [] : _options,
          onSelected: (option) {
            if (option is _PickerItem<T>) _select(option.item);
            if (option is _PickerCreate<T>) unawaited(_create(option.text));
          },
          fieldViewBuilder: (context, controller, focusNode, onSubmit) =>
              Actions(
                actions: {
                  DismissIntent: CallbackAction<DismissIntent>(
                    onInvoke: (intent) {
                      // Sin lista ni búsqueda en curso, Escape sigue hacia
                      // la ventana que contiene el selector (la cierra).
                      if (_options.first is _PickerIdle<T>) {
                        return Actions.maybeInvoke(this.context, intent);
                      }
                      _timer?.cancel();
                      _search++;
                      _publish([_PickerIdle<T>()]);
                      return null;
                    },
                  ),
                },
                child: TextFormField(
                  key: _fieldKey,
                  controller: controller,
                  focusNode: focusNode,
                  enabled: widget.enabled,
                  // La selección debe ocurrir antes de que el campo pierda foco.
                  onEditingComplete: () {},
                  decoration: InputDecoration(
                    labelText: widget.label,
                    hintText: widget.hint,
                    errorText: widget.errorText,
                    suffixIcon: const Icon(Icons.search),
                  ),
                  onFieldSubmitted: (_) {
                    // Los estados informativos no se eligen; la acción de
                    // alta abre su diálogo sin convertirse en un valor.
                    if (_options.first is _PickerItem<T> ||
                        _options.any((option) => option is _PickerCreate<T>)) {
                      onSubmit();
                    }
                  },
                ),
              ),
          optionsViewBuilder: (context, onSelected, options) {
            if (options.first is _PickerIdle<T>) return const SizedBox.shrink();
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                color: context.colors.surface,
                borderRadius: BorderRadius.circular(context.shape.control),
                clipBehavior: Clip.antiAlias,
                child: SizedBox(
                  width: math.min(480, constraints.maxWidth),
                  height: 280,
                  child: _PickerOptions<T>(
                    options: options.toList(),
                    labelOf: widget.labelOf,
                    detailOf: widget.detailOf,
                    badgeOf: widget.badgeOf,
                    emptyText: widget.emptyText,
                    emptyQueryText: widget.emptyQueryText,
                    onSelected: onSelected,
                    onRetry: () => _startSearch(immediate: true, force: true),
                  ),
                ),
              ),
            );
          },
        ),
        if (widget.suggestOnFocus) ...[
          const SizedBox(height: 8),
          Text(widget.helpText, style: Theme.of(context).textTheme.bodySmall),
        ],
      ],
    ),
  );
}

class _PickerOptions<T extends Object> extends StatefulWidget {
  const _PickerOptions({
    required this.options,
    required this.labelOf,
    required this.detailOf,
    required this.badgeOf,
    required this.emptyText,
    required this.emptyQueryText,
    required this.onSelected,
    required this.onRetry,
  });
  final List<_PickerOption<T>> options;
  final String Function(T) labelOf;
  final String? Function(T)? detailOf;
  final String? Function(T)? badgeOf;
  final String? emptyText;
  final String? emptyQueryText;
  final ValueChanged<_PickerOption<T>> onSelected;
  final VoidCallback onRetry;

  @override
  State<_PickerOptions<T>> createState() => _PickerOptionsState<T>();
}

class _PickerOptionsState<T extends Object> extends State<_PickerOptions<T>> {
  final _scroll = ScrollController();

  /// Alto de cada fila según lo que lleva: antes todas medían 112 px aunque no
  /// tuvieran etiqueta de trámite, y en la lista cabían dos y media. Crece con
  /// el tamaño de texto del sistema.
  double _extentOf(int index) {
    final option = widget.options[index];
    final double base;
    if (option is _PickerItem<T>) {
      final detail = widget.detailOf?.call(option.item);
      final badge = widget.badgeOf?.call(option.item);
      base =
          52 +
          (detail != null && detail.isNotEmpty ? 18 : 0) +
          (badge != null && badge.isNotEmpty ? 30 : 0);
    } else if (option is _PickerCreate<T>) {
      base = 64;
    } else {
      base = 72;
    }
    return MediaQuery.textScalerOf(context).scale(base);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final index = AutocompleteHighlightedOption.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      final position = _scroll.position;
      if (index >= widget.options.length) return;
      var top = 0.0;
      for (var i = 0; i < index; i++) {
        top += _extentOf(i);
      }
      final bottom = top + _extentOf(index);
      final offset = top < position.pixels
          ? top
          : bottom > position.pixels + position.viewportDimension
          ? bottom - position.viewportDimension
          : position.pixels;
      _scroll.animateTo(
        offset.clamp(0, position.maxScrollExtent),
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final highlighted = AutocompleteHighlightedOption.of(context);
    return ListView.builder(
      controller: _scroll,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemExtentBuilder: (index, _) =>
          index < widget.options.length ? _extentOf(index) : null,
      itemCount: widget.options.length,
      itemBuilder: (context, index) {
        final option = widget.options[index];
        if (option is _PickerCreate<T>) {
          return Semantics(
            button: true,
            selected: index == highlighted,
            child: InkWell(
              onTap: () => widget.onSelected(option),
              child: Container(
                color: index == highlighted
                    ? context.colors.primarySurface
                    : null,
                padding: const EdgeInsets.all(12),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Agregar «${option.text}»',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }
        if (option is _PickerItem<T>) {
          final detail = widget.detailOf?.call(option.item);
          final badge = widget.badgeOf?.call(option.item);
          return Semantics(
            selected: index == highlighted,
            child: InkWell(
              onTap: () => widget.onSelected(option),
              child: Container(
                color: index == highlighted
                    ? context.colors.primarySurface
                    : null,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.labelOf(option.item),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (detail != null && detail.isNotEmpty)
                      Text(
                        detail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    if (badge != null && badge.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      AppBadge(label: badge),
                    ],
                  ],
                ),
              ),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Center(
            child: switch (option) {
              _PickerLoading<T>() => const Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Expanded(child: Text('Buscando…')),
                ],
              ),
              _PickerEmpty<T>(:final text) => Text(
                (text.isEmpty ? widget.emptyQueryText : null) ??
                    widget.emptyText ??
                    'Sin coincidencias para «$text»',
              ),
              _PickerError<T>() => Row(
                children: [
                  const Expanded(child: Text('No se pudo buscar.')),
                  TextButton(
                    onPressed: widget.onRetry,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
              _ => const SizedBox.shrink(),
            },
          ),
        );
      },
    );
  }
}
