import 'dart:async';

import 'package:flutter/material.dart';

import '../design_system/spacing.dart';

/// Barra de búsqueda de una tabla. Va ENCIMA del contenido que cambia entre
/// cargando / error / datos, no dentro: si viviera dentro de la tabla, cada
/// búsqueda destruiría el campo (la tabla se reemplaza por el esqueleto de
/// carga) y perdería el foco a media escritura.
///
/// - Espera [debounce] sin teclear antes de avisar, para no consultar al
///   servidor en cada letra; Enter avisa de inmediato.
/// - [value] es la búsqueda que la pantalla tiene APLICADA y manda: si cambia
///   desde fuera (ej. "Limpiar búsqueda" del estado vacío) el campo la sigue.
class AppTableToolbar extends StatefulWidget {
  const AppTableToolbar({
    super.key,
    required this.hint,
    required this.value,
    required this.onSearch,
    this.debounce = const Duration(milliseconds: 350),
  });

  final String hint;
  final String value;
  final ValueChanged<String> onSearch;
  final Duration debounce;

  @override
  State<AppTableToolbar> createState() => _AppTableToolbarState();
}

class _AppTableToolbarState extends State<AppTableToolbar> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );
  Timer? _timer;

  // Lo último que se le avisó a la pantalla. Se recuerda aquí y no solo se
  // compara con `widget.value`: así "limpiar" siempre avisa aunque la
  // pantalla no haya reflejado todavía el aviso anterior.
  late String _lastEmitted = widget.value;

  @override
  void didUpdateWidget(AppTableToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) _lastEmitted = widget.value;
    // Solo si cambió desde fuera: mientras se teclea, `value` todavía no
    // cambió y pisar el texto movería el cursor.
    if (widget.value != oldWidget.value &&
        widget.value != _controller.text.trim()) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _emit(String text) {
    _timer?.cancel();
    final value = text.trim();
    if (value == _lastEmitted) return;
    _lastEmitted = value;
    widget.onSearch(value);
  }

  void _onChanged(String text) {
    _timer?.cancel();
    _timer = Timer(widget.debounce, () => _emit(text));
    setState(() {}); // el botón de limpiar aparece/desaparece
  }

  void _clear() {
    _controller.clear();
    _emit('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 440),
      child: TextField(
        controller: _controller,
        onChanged: _onChanged,
        onSubmitted: _emit,
        textInputAction: TextInputAction.search,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          suffixIcon: _controller.text.isEmpty
              ? null
              : IconButton(
                  tooltip: 'Limpiar búsqueda',
                  onPressed: _clear,
                  icon: const Icon(Icons.close_rounded, size: 18),
                ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 4,
          ),
        ),
      ),
    ),
  );
}
