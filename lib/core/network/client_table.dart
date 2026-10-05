import 'table_query.dart';

/// Búsqueda, orden y paginación de una lista que YA está completa en memoria
/// (catálogos como Puestos o Tipos de horario, que la API entrega enteros).
/// Habla el mismo idioma que las tablas con paginación del servidor
/// (`TableQuery`: campos con `-` para descendente) para que la pantalla use los
/// mismos componentes: barra de búsqueda y encabezados ordenables.

const _acentos = {
  'á': 'a',
  'à': 'a',
  'ä': 'a',
  'â': 'a',
  'ã': 'a',
  'é': 'e',
  'è': 'e',
  'ë': 'e',
  'ê': 'e',
  'í': 'i',
  'ì': 'i',
  'ï': 'i',
  'î': 'i',
  'ó': 'o',
  'ò': 'o',
  'ö': 'o',
  'ô': 'o',
  'õ': 'o',
  'ú': 'u',
  'ù': 'u',
  'ü': 'u',
  'û': 'u',
  'ñ': 'n',
  'ç': 'c',
};

/// Minúsculas y sin acentos: "Técnico" y "tecnico" son lo mismo al buscar o
/// al ordenar, igual que la búsqueda del servidor.
String foldAccents(String text) {
  final out = StringBuffer();
  for (final char in text.toLowerCase().split('')) {
    out.write(_acentos[char] ?? char);
  }
  return out.toString();
}

/// Una página ya filtrada y ordenada, más el total que cumple la búsqueda
/// (no el de la lista completa) para que el paginador sea honesto.
typedef ClientPage<T> = ({List<T> rows, int total});

/// Filtra por [TableQuery.search] (todas las palabras deben aparecer, en
/// cualquiera de los textos de [searchTexts], sin acentos ni mayúsculas),
/// ordena por [TableQuery.ordering] con los [comparators] por campo, y corta
/// la página [page] (desde 0) de [pageSize] filas.
///
/// Un campo de `ordering` sin comparador se ignora, igual que el servidor
/// ignora uno que no declaró. El orden es estable: filas iguales conservan su
/// orden original, así paginar no repite ni salta filas.
ClientPage<T> clientPage<T>(
  List<T> items, {
  required TableQuery query,
  required int page,
  required Iterable<String> Function(T item) searchTexts,
  required Map<String, int Function(T a, T b)> comparators,
  int pageSize = 25,
}) {
  var filtered = items;
  final words = foldAccents(query.search)
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();
  if (words.isNotEmpty) {
    filtered = [
      for (final item in items)
        if (() {
          final haystack = searchTexts(item).map(foldAccents).join(' ');
          return words.every(haystack.contains);
        }())
          item,
    ];
  }

  final steps = <(int Function(T, T), bool)>[
    for (final raw in query.ordering.split(','))
      if (raw.isNotEmpty &&
          comparators[raw.startsWith('-') ? raw.substring(1) : raw] != null)
        (
          comparators[raw.startsWith('-') ? raw.substring(1) : raw]!,
          raw.startsWith('-'),
        ),
  ];
  if (steps.isNotEmpty) {
    // Dart's List.sort no es estable: se desempata por la posición original.
    final position = {
      for (final (index, item) in filtered.indexed) item: index,
    };
    filtered = [...filtered]
      ..sort((a, b) {
        for (final (compare, descending) in steps) {
          final result = compare(a, b);
          if (result != 0) return descending ? -result : result;
        }
        return position[a]!.compareTo(position[b]!);
      });
  }

  final start = page * pageSize;
  final rows = start >= filtered.length
      ? <T>[]
      : filtered.sublist(start, (start + pageSize).clamp(0, filtered.length));
  return (rows: rows, total: filtered.length);
}
