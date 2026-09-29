// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_page.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiPage<T> _$ApiPageFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _ApiPage<T>(
  count: (json['count'] as num).toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>).map(fromJsonT).toList(),
);

Map<String, dynamic> _$ApiPageToJson<T>(
  _ApiPage<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results.map(toJsonT).toList(),
};
