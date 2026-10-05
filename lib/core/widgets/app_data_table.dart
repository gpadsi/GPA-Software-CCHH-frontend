import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../design_system/colors.dart';
import '../design_system/spacing.dart';
import 'app_button.dart';
import 'app_card.dart';
import 'empty_state.dart';
import 'loading_skeleton.dart';

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
  }) : assert(columns.length > 0),
       assert(totalCount >= 0),
       assert(pageIndex >= 0),
       assert(pageSize > 0),
       assert(rows.length <= pageSize);

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

  static String _descending(String spec) => spec
      .split(',')
      .map((field) => field.startsWith('-') ? field.substring(1) : '-$field')
      .join(',');

  String? _labelOf(DataColumn column) =>
      column.label is Text ? (column.label as Text).data : null;

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

    final visibleRows = isLoading
        ? List<DataRow>.generate(
            math.min(pageSize, 3),
            (_) => DataRow(
              cells: effectiveColumns
                  .map((_) => const DataCell(LoadingSkeleton(width: 96)))
                  .toList(),
            ),
          )
        : rows;

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: IgnorePointer(
                  ignoring: isLoading,
                  child: DataTable(
                    columns: effectiveColumns,
                    rows: visibleRows,
                    sortColumnIndex: sortIndex,
                    sortAscending: sortAsc,
                    // Sin columna de casillas: `onSelectChanged` de cada fila se
                    // usa solo como "clic en la fila".
                    showCheckboxColumn: false,
                    dataRowColor: WidgetStateProperty.resolveWith(
                      (states) => states.contains(WidgetState.hovered)
                          ? AppColors.primarySurface.withValues(alpha: 0.55)
                          : null,
                    ),
                    headingRowHeight: 52,
                    dataRowMinHeight: 56,
                    dataRowMaxHeight: 88,
                    horizontalMargin: AppSpacing.md,
                    columnSpacing: AppSpacing.lg,
                    headingRowColor: const WidgetStatePropertyAll(
                      AppColors.background,
                    ),
                    headingTextStyle: Theme.of(context).textTheme.labelMedium,
                    dataTextStyle: Theme.of(context).textTheme.bodyMedium,
                    dividerThickness: 1,
                  ),
                ),
              ),
            ),
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
          const Divider(height: 1, color: AppColors.border),
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
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: AppColors.textSecondary),
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
                          style: Theme.of(context).textTheme.bodySmall,
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
