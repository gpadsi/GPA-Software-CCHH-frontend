// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrganizationTenant _$OrganizationTenantFromJson(Map<String, dynamic> json) =>
    _OrganizationTenant(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$OrganizationTenantToJson(_OrganizationTenant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
    };

_OrganizationLevel _$OrganizationLevelFromJson(Map<String, dynamic> json) =>
    _OrganizationLevel(
      id: (json['id'] as num).toInt(),
      numero: (json['numero'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      allowsRecursiveNesting: json['allows_recursive_nesting'] as bool,
    );

Map<String, dynamic> _$OrganizationLevelToJson(_OrganizationLevel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numero': instance.numero,
      'code': instance.code,
      'name': instance.name,
      'allows_recursive_nesting': instance.allowsRecursiveNesting,
    };

_OrganizationNode _$OrganizationNodeFromJson(Map<String, dynamic> json) =>
    _OrganizationNode(
      id: json['id'] as String,
      tenant: (json['tenant'] as num).toInt(),
      level: (json['level'] as num).toInt(),
      parent: json['parent'] as String?,
      code: json['code'] as String,
      name: json['name'] as String,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$OrganizationNodeToJson(_OrganizationNode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tenant': instance.tenant,
      'level': instance.level,
      'parent': instance.parent,
      'code': instance.code,
      'name': instance.name,
      'is_active': instance.isActive,
    };

_Company _$CompanyFromJson(Map<String, dynamic> json) => _Company(
  id: json['id'] as String,
  organizationNode: json['organization_node'] as String,
  legalName: json['legal_name'] as String?,
  rfc: json['rfc'] as String?,
  employerRegistration: json['employer_registration'] as String?,
);

Map<String, dynamic> _$CompanyToJson(_Company instance) => <String, dynamic>{
  'id': instance.id,
  'organization_node': instance.organizationNode,
  'legal_name': instance.legalName,
  'rfc': instance.rfc,
  'employer_registration': instance.employerRegistration,
};
