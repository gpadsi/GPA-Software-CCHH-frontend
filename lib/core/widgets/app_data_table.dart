import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/spacing.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'app_row_actions.dart';
import 'empty_state.dart';
import 'loading_skeleton.dart';

/// Tabla paginada de las pantallas de listado.
///
/// Las filas se arman bajo demanda: solo las que se ven (y un margen para el
/// desplazamiento) existen como widgets; las demás son espacios del mismo alto
/// hasta que se acercan a la pantalla. Por eso cada fila tiene un alto fijo
/// ([rowHeight]) y cada columna un ancho que no depende de medir todas las
/// filas: `DataColumn.columnWidth` (`FixedColumnWidth` o `FlexColumnWidth`) o,
/// si no se indica, una parte proporcional del ancho disponible. La columna de
/// [AppRowActions] toma sola el ancho de sus botones.
///
/// Medido en R5 (CPU a 4x): la `DataTable` de Material armaba y medía las 25
/// filas en un solo fotograma de ~340 ms al llegar los datos.
class AppDataTable extends StatelessWidget {
  const AppDataTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.totalCount,
    required this.pageIndex,
    required this.pageSize,
    required this.onPageChanged,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.sortFields = const [],
    this.ordering = '',
    this.onOrderingChanged,
    this.searchTerm = '',
    this.onClearSearch,
    this.emptyTitle = 'Sin resultados',
    this.emptyMessage = 'No hay registros para mostrar en este momento.',
    this.isLoading = false,
    this.rowHeight = defaultRowHeight,
  }) : assert(columns.length > 0),
       assert(totalCount >= 0),
       assert(pageIndex >= 0),
       assert(pageSize > 0),
       assert(rows.length <= pageSize);

  /// Alto de una fila con hasta dos líneas de texto (como `tableText`).
  static const defaultRowHeight = 64.0;

  final List<DataColumn> columns;

  // El módulo entrega únicamente la página que devuelve el servidor.
  final List<DataRow> rows;
  final int totalCount;
  final int pageIndex;
  final int pageSize;
  final ValueChanged<int>? onPageChanged;
  final int? sortColumnIndex;
  final bool sortAscending;

  /// Orden declarativo del lado del servidor: un campo de la API por columna
  /// (mismo largo y orden que [columns]; `null` = no ordenable, como
  /// "Acciones"). Un campo puede ser varios separados por coma
  /// (`apellido,nombre`) para ordenar por más de uno. Al tocar un encabezado
  /// se avisa con [onOrderingChanged] en el formato de la API (`-campo` para
  /// descendente) y la flecha se calcula sola a partir de [ordering]. Si se
  /// pasa [sortColumnIndex] a mano, este mecanismo no interviene.
  final List<String?> sortFields;
  final String ordering;
  final ValueChanged<String>? onOrderingChanged;

  /// Búsqueda aplicada: si no hay filas, el mensaje habla de la búsqueda (y
  /// ofrece limpiarla) en vez de decir que no hay registros.
  final String searchTerm;
  final VoidCallback? onClearSearch;

  /// Lo que dice la tabla cuando no hay filas y NO hay una búsqueda aplicada
  /// (ej. "Todavía no has levantado ninguna requisición"): cada pantalla sabe
  /// mejor que un texto genérico por qué está vacía.
  final String emptyTitle;
  final String emptyMessage;
  final bool isLoading;

  /// Alto fijo de cada fila (crece con el tamaño de texto del sistema). Las
  /// celdas con más líneas necesitan uno mayor.
  final double rowHeight;

  static const _headingHeight = 52.0;
  static const _edge = AppSpacing.md;
  static const _gap = AppSpacing.lg / 2;
  static const _minFlexWidth = 120.0;

  static String _descending(String spec) => spec
      .split(',')
      .map((field) => field.startsWith('-') ? field.substring(1) : '-$field')
      .join(',');

  String? _labelOf(DataColumn column) =>
      column.label is Text ? (column.label as Text).data : null;

  EdgeInsets _cellPadding(int index, int count) => EdgeInsets.only(
    left: index == 0 ? _edge : _gap,
    right: index == count - 1 ? _edge : _gap,
  );

  /// Ancho de la columna de acciones, sin medir: tantos botones de 48 px como
  /// tenga la fila que más tiene.
  double? _actionsWidth(int column) {
    var most = 0;
    for (final row in rows) {
      final child = row.cells[column].child;
      if (child is! AppRowActions) return null;
      most = math.max(most, child.actions.length);
    }
    return most == 0 ? null : AppRowActions.width(most);
  }

  /// Anchos finales (con el relleno de cada celda) y ancho total de la tabla.
  (List<double>, double) _widths(double available) {
    final count = columns.length;
    final fixed = List<double?>.filled(count, null);
    final flex = List<double>.filled(count, 0);
    for (var i = 0; i < count; i++) {
      final padding = _cellPadding(i, count).horizontal;
      final spec = columns[i].columnWidth;
      if (spec is FixedColumnWidth) {
        fixed[i] = spec.value + padding;
      } else if (spec is FlexColumnWidth) {
        flex[i] = spec.value;
      } else {
        final actions = rows.isEmpty ? null : _actionsWidth(i);
        if (actions != null) {
          fixed[i] = actions + padding;
        } else {
          flex[i] = 1;
        }
      }
    }
    final fixedTotal = fixed.fold<double>(0, (a, w) => a + (w ?? 0));
    final flexTotal = flex.fold<double>(0, (a, f) => a + f);
    final minimum = fixedTotal + flexTotal * _minFlexWidth;
    final width = math.max(available, minimum);
    final unit = flexTotal == 0 ? 0.0 : (width - fixedTotal) / flexTotal;
    return (
      [for (var i = 0; i < count; i++) fixed[i] ?? flex[i] * unit],
      width,
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageCount = math.max(1, (totalCount / pageSize).ceil());
    final first = rows.isEmpty ? 0 : pageIndex * pageSize + 1;
    final last = rows.isEmpty
        ? 0
        : math.min(totalCount, pageIndex * pageSize + rows.length);
    final sortable = onOrderingChanged != null && sortFields.isNotEmpty;
    var sortIndex = sortColumnIndex;
    var sortAsc = sortAscending;
    final effectiveColumns = !sortable
        ? columns
        : [
            for (final (index, column) in columns.indexed)
              if (index < sortFields.length && sortFields[index] != null)
                DataColumn(
                  label: column.label,
                  numeric: column.numeric,
                  columnWidth: column.columnWidth,
                  tooltip: _labelOf(column) == null
                      ? column.tooltip
                      : 'Ordenar por ${_labelOf(column)!.toLowerCase()}',
                  onSort: (_, ascending) => onOrderingChanged!(
                    ascending
                        ? sortFields[index]!
                        : _descending(sortFields[index]!),
                  ),
                )
              else
                column,
          ];
    if (sortable && sortColumnIndex == null) {
      for (final (index, field) in sortFields.indexed) {
        if (field == null) continue;
        if (ordering == field) {
          sortIndex = index;
          sortAsc = true;
        } else if (ordering == _descending(field)) {
          sortIndex = index;
          sortAsc = false;
        }
      }
    }
    final canGoBack = !isLoading && pageIndex > 0 && onPageChanged != null;
    final canGoForward =
        !isLoading && pageIndex + 1 < pageCount && onPageChanged != null;
    final type = Theme.of(context).textTheme;
    final extent = MediaQuery.textScalerOf(context).scale(rowHeight);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final (widths, width) = _widths(constraints.maxWidth);
              final table = SizedBox(
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeadingRow(
                      columns: effectiveColumns,
                      widths: widths,
                      padding: _cellPadding,
                      height: _headingHeight,
                      sortIndex: sortIndex,
                      sortAscending: sortAsc,
                      style: type.labelMedium,
                    ),
                    IgnorePointer(
                      ignoring: isLoading,
                      child: isLoading
                          ? Column(
                              children: [
                                for (var i = 0; i < math.min(pageSize, 3); i++)
                                  _RowView(
                                    cells: [
                                      for (final _ in effectiveColumns)
                                        const DataCell(
                                          LoadingSkeleton(width: 96),
                                        ),
                                    ],
                                    widths: widths,
                                    padding: _cellPadding,
                                    height: extent,
                                    columns: effectiveColumns,
                                    divider: i < 2,
                                  ),
                              ],
                            )
                          : _LazyRows(
                              count: rows.length,
                              extent: extent,
                              rowBuilder: (index) => _RowView(
                                cells: rows[index].cells,
                                onTap: rows[index].onSelectChanged == null
                                    ? null
                                    : () => rows[index].onSelectChanged!(true),
                                widths: widths,
                                padding: _cellPadding,
                                height: extent,
                                columns: effectiveColumns,
                                divider: index < rows.length - 1,
                              ),
                            ),
                    ),
                  ],
                ),
              );
              return width > constraints.maxWidth
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: table,
                    )
                  : table;
            },
          ),
          if (!isLoading && rows.isEmpty)
            searchTerm.isEmpty
                ? EmptyState(
                    icon: Icons.inbox_outlined,
                    title: emptyTitle,
                    message: emptyMessage,
                  )
                : EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'Sin resultados',
                    message:
                        'No encontramos nada para «$searchTerm». Revisa la ortografía o prueba con menos palabras.',
                    action: onClearSearch == null
                        ? null
                        : AppButton(
                            label: 'Limpiar búsqueda',
                            variant: AppButtonVariant.secondary,
                            onPressed: onClearSearch,
                          ),
                  ),
          Divider(height: 1, color: context.colors.border),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: [
                Semantics(
                  liveRegion: true,
                  child: Text(
                    isLoading
                        ? 'Cargando resultados…'
                        : '$first–$last de $totalCount resultados',
                    style: type.bodySmall?.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Página anterior',
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                      onPressed: canGoBack
                          ? () => onPageChanged!(pageIndex - 1)
                          : null,
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                        ),
                        child: Text(
                          'Página ${pageIndex + 1} de $pageCount',
                          textAlign: TextAlign.center,
                          style: type.bodySmall,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Página siguiente',
                      constraints: const BoxConstraints(
                        minWidth: 44,
                        minHeight: 44,
                      ),
                      onPressed: canGoForward
                          ? () => onPageChanged!(pageIndex + 1)
                          : null,
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Encabezados: tocar uno ordenable ordena ascendente; volver a tocar el que
/// ya ordena invierte el orden (lo mismo que hacía la `DataTable`).
class _HeadingRow extends StatelessWidget {
  const _HeadingRow({
    required this.columns,
    required this.widths,
    required this.padding,
    required this.height,
    required this.sortIndex,
    required this.sortAscending,
    required this.style,
  });

  final List<DataColumn> columns;
  final List<double> widths;
  final EdgeInsets Function(int index, int count) padding;
  final double height;
  final int? sortIndex;
  final bool sortAscending;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    color: context.colors.tableHeader,
    child: Row(
      children: [
        for (final (index, column) in columns.indexed)
          SizedBox(
            width: widths[index],
            child: _heading(context, index, column),
          ),
      ],
    ),
  );

  Widget _heading(BuildContext context, int index, DataColumn column) {
    final sorted = index == sortIndex;
    final content = Padding(
      padding: padding(index, columns.length),
      child: Row(
        mainAxisAlignment: column.numeric
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          Flexible(
            child: DefaultTextStyle.merge(
              style: style,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              child: column.label,
            ),
          ),
          if (sorted) ...[
            const SizedBox(width: AppSpacing.xs),
            Icon(
              sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 16,
              color: context.colors.textSecondary,
            ),
          ],
        ],
      ),
    );
    final onSort = column.onSort;
    final heading = Semantics(
      header: true,
      child: onSort == null
          ? content
          : InkWell(
              onTap: () => onSort(index, sorted ? !sortAscending : true),
              child: SizedBox.expand(
                child: Align(alignment: Alignment.centerLeft, child: content),
              ),
            ),
    );
    return column.tooltip == null || onSort == null
        ? heading
        : Tooltip(message: column.tooltip, child: heading);
  }
}

/// Una fila: un solo `InkWell` para toda la fila (clic y hover), celdas del
/// ancho de su columna y alto fijo.
class _RowView extends StatelessWidget {
  const _RowView({
    required this.cells,
    required this.widths,
    required this.padding,
    required this.height,
    required this.columns,
    required this.divider,
    this.onTap,
  });

  final List<DataCell> cells;
  final List<double> widths;
  final EdgeInsets Function(int index, int count) padding;
  final double height;
  final List<DataColumn> columns;
  final bool divider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      border: divider
          ? Border(bottom: BorderSide(color: context.colors.border))
          : null,
    ),
    child: InkWell(
      onTap: onTap,
      hoverColor: context.colors.primarySurface.withValues(alpha: 0.55),
      child: SizedBox(
        height: height,
        child: DefaultTextStyle.merge(
          style: Theme.of(context).textTheme.bodyMedium,
          child: Row(
            children: [
              for (final (index, cell) in cells.indexed)
                SizedBox(
                  width: widths[index],
                  child: Padding(
                    padding: padding(index, cells.length),
                    child: Align(
                      alignment: columns[index].numeric
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: cell.child,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Arma bajo demanda las filas que se ven en la pantalla (más un margen para
/// el desplazamiento); el resto ocupa su alto con un espacio vacío. Una fila
/// armada se queda armada: volver a subir no la reconstruye.
class _LazyRows extends StatefulWidget {
  const _LazyRows({
    required this.count,
    required this.extent,
    required this.rowBuilder,
  });

  final int count;
  final double extent;
  final Widget Function(int index) rowBuilder;

  @override
  State<_LazyRows> createState() => _LazyRowsState();
}

class _LazyRowsState extends State<_LazyRows> {
  /// Lo que se arma por adelantado fuera de la pantalla, arriba y abajo.
  static const _margin = 240.0;

  final _built = <int>{};
  ScrollableState? _scrollable;
  bool _scheduled = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scrollable = Scrollable.maybeOf(context, axis: Axis.vertical);
    if (scrollable?.position != _scrollable?.position) {
      _scrollable?.position.removeListener(_schedule);
      scrollable?.position.addListener(_schedule);
    }
    _scrollable = scrollable;
    if (!_initialized) {
      _initialized = true;
      // Antes de saber dónde queda la tabla: las filas que caben en buena
      // parte de la pantalla, para que no se vea vacía el primer fotograma.
      final guess = (MediaQuery.sizeOf(context).height * 0.7 / widget.extent)
          .ceil();
      _built.addAll(List.generate(math.min(guess, widget.count), (i) => i));
    }
  }

  @override
  void didUpdateWidget(_LazyRows oldWidget) {
    super.didUpdateWidget(oldWidget);
    _built.removeWhere((index) => index >= widget.count);
  }

  @override
  void dispose() {
    _scrollable?.position.removeListener(_schedule);
    super.dispose();
  }

  void _schedule() {
    if (_scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  void _update() {
    _scheduled = false;
    final scrollable = _scrollable;
    if (!mounted || scrollable == null) return;
    final box = context.findRenderObject();
    final viewport = scrollable.context.findRenderObject();
    if (box is! RenderBox ||
        viewport is! RenderBox ||
        !box.hasSize ||
        !viewport.hasSize ||
        !box.attached) {
      return;
    }
    final top = box.localToGlobal(Offset.zero, ancestor: viewport).dy;
    final height = viewport.size.height;
    final first = math.max(0, ((-top - _margin) / widget.extent).floor());
    final last = math.min(
      widget.count - 1,
      ((height - top + _margin) / widget.extent).ceil(),
    );
    final missing = [
      for (var i = first; i <= last; i++)
        if (!_built.contains(i)) i,
    ];
    if (missing.isNotEmpty) setState(() => _built.addAll(missing));
  }

  @override
  Widget build(BuildContext context) {
    // Sin desplazamiento vertical alrededor no hay "fuera de pantalla".
    final all = _scrollable == null;
    if (!all) _schedule();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < widget.count; i++)
          all || _built.contains(i)
              ? widget.rowBuilder(i)
              : SizedBox(height: widget.extent),
      ],
    );
  }
}
