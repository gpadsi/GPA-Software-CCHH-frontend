import 'package:freezed_annotation/freezed_annotation.dart';
part 'organization_models.freezed.dart';
part 'organization_models.g.dart';

@freezed
abstract class OrganizationTenant with _$OrganizationTenant {
  const factory OrganizationTenant({
    required int id,
    required String code,
    required String name,
  }) = _OrganizationTenant;
  factory OrganizationTenant.fromJson(Map<String, dynamic> json) =>
      _$OrganizationTenantFromJson(json);
}

@freezed
abstract class OrganizationLevel with _$OrganizationLevel {
  const factory OrganizationLevel({
    required int id,
    required int numero,
    required String code,
    required String name,
    @JsonKey(name: 'allows_recursive_nesting')
    required bool allowsRecursiveNesting,
  }) = _OrganizationLevel;
  factory OrganizationLevel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationLevelFromJson(json);
}

@freezed
abstract class OrganizationNode with _$OrganizationNode {
  const factory OrganizationNode({
    required String id,
    required int tenant,
    required int level,
    String? parent,
    required String code,
    required String name,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _OrganizationNode;
  factory OrganizationNode.fromJson(Map<String, dynamic> json) =>
      _$OrganizationNodeFromJson(json);
}

@freezed
abstract class Company with _$Company {
  const factory Company({
    required String id,
    @JsonKey(name: 'organization_node') required String organizationNode,
    @JsonKey(name: 'legal_name') String? legalName,
    String? rfc,
    @JsonKey(name: 'employer_registration') String? employerRegistration,
  }) = _Company;
  factory Company.fromJson(Map<String, dynamic> json) =>
      _$CompanyFromJson(json);
}

class OrganizationTree {
  const OrganizationTree({
    required this.tenants,
    required this.levels,
    required this.nodes,
  });
  final List<OrganizationTenant> tenants;
  final List<OrganizationLevel> levels;
  final List<OrganizationNode> nodes;
}
