import 'package:flutter/foundation.dart';

/// Búsqueda, orden y filtros de una lista paginada (`?search=`, `?ordering=`
/// y los filtros por campo de la API, ej. `?estado=3`). Es un valor inmutable
/// con igualdad por contenido a propósito: los proveedores de Riverpod con
/// parámetros se identifican por `==`, y dos consultas iguales deben compartir
/// la misma carga en lugar de repetirla.
@immutable
class TableQuery {
  const TableQuery({
    this.search = '',
    this.ordering = '',
    this.filters = const {},
  });

  final String search;

  /// Campos separados por coma, con `-` delante para descendente
  /// (ej. `-last_name_paternal,first_name`). Vacío = el orden por defecto.
  final String ordering;

  /// Filtros por campo, tal como los espera la API (`{'estado': '3'}`). Un
  /// valor vacío equivale a "sin filtro" y no se manda.
  final Map<String, String> filters;

  bool get isSearching => search.isNotEmpty;

  /// Solo lo que tiene valor: un parámetro vacío no se manda.
  Map<String, dynamic> get params => {
    for (final entry in filters.entries)
      if (entry.value.isNotEmpty) entry.key: entry.value,
    if (search.isNotEmpty) 'search': search,
    if (ordering.isNotEmpty) 'ordering': ordering,
  };

  TableQuery copyWith({
    String? search,
    String? ordering,
    Map<String, String>? filters,
  }) => TableQuery(
    search: search ?? this.search,
    ordering: ordering ?? this.ordering,
    filters: filters ?? this.filters,
  );

  /// Igual que esta consulta pero con [key] en [value] (vacío lo quita).
  TableQuery withFilter(String key, String value) => copyWith(
    filters: {
      for (final entry in filters.entries)
        if (entry.key != key) entry.key: entry.value,
      if (value.isNotEmpty) key: value,
    },
  );

  @override
  bool operator ==(Object other) =>
      other is TableQuery &&
      other.search == search &&
      other.ordering == ordering &&
      mapEquals(other.filters, filters);

  @override
  int get hashCode => Object.hash(
    search,
    ordering,
    Object.hashAllUnordered(
      filters.entries.map((entry) => Object.hash(entry.key, entry.value)),
    ),
  );

  @override
  String toString() =>
      'TableQuery(search: "$search", ordering: "$ordering", filters: $filters)';
}
