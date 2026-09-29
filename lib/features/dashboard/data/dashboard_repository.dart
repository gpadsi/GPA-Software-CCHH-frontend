import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_repository.freezed.dart';
part 'dashboard_repository.g.dart';

enum DashboardMetric {
  persons('persons/personas/'),
  employees('employment/empleados/'),
  positions('positions/posiciones/'),
  companies('organizations/companies/');

  const DashboardMetric(this.path);
  final String path;
}

@freezed
abstract class ResourceCount with _$ResourceCount {
  const factory ResourceCount({required int count}) = _ResourceCount;
  factory ResourceCount.fromJson(Map<String, dynamic> json) =>
      _$ResourceCountFromJson(json);
}

class DashboardRepository {
  DashboardRepository(this.api);
  final Dio api;
  Future<int> count(DashboardMetric metric) async {
    final response = await api.get<Map<String, dynamic>>(
      metric.path,
      queryParameters: {'page_size': 1},
    );
    return ResourceCount.fromJson(response.data!).count;
  }
}
