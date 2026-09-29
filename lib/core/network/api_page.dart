import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_page.freezed.dart';
part 'api_page.g.dart';

Duration? manualRetryOnly(int retryCount, Object error) => null;

@Freezed(genericArgumentFactories: true)
abstract class ApiPage<T> with _$ApiPage<T> {
  const factory ApiPage({
    required int count,
    String? next,
    String? previous,
    required List<T> results,
  }) = _ApiPage<T>;
  factory ApiPage.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) => _$ApiPageFromJson(json, fromJsonT);
}

Future<ApiPage<T>> fetchPage<T>(
  Dio api,
  String path,
  T Function(Map<String, dynamic>) decode, {
  int page = 1,
  int pageSize = 25,
  Map<String, dynamic> queryParameters = const {},
}) async {
  final response = await api.get<Map<String, dynamic>>(
    path,
    queryParameters: {
      'page': page,
      'page_size': pageSize,
      ...queryParameters,
    },
  );
  return ApiPage.fromJson(
    response.data!,
    (value) => decode(value as Map<String, dynamic>),
  );
}

// Solo para árboles y selectores sin endpoint de hijos/filtros; las tablas usan fetchPage.
Future<List<T>> fetchCatalog<T>(
  Dio api,
  String path,
  T Function(Map<String, dynamic>) decode, {
  Map<String, dynamic> queryParameters = const {},
}) async {
  final items = <T>[];
  var page = 1;
  while (true) {
    final result = await fetchPage(
      api,
      path,
      decode,
      page: page++,
      pageSize: 200,
      queryParameters: queryParameters,
    );
    items.addAll(result.results);
    if (result.next == null) return items;
  }
}
