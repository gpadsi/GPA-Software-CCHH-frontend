// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TokenPair _$TokenPairFromJson(Map<String, dynamic> json) => _TokenPair(
  access: json['access'] as String,
  refresh: json['refresh'] as String,
);

Map<String, dynamic> _$TokenPairToJson(_TokenPair instance) =>
    <String, dynamic>{'access': instance.access, 'refresh': instance.refresh};

_RefreshResponse _$RefreshResponseFromJson(Map<String, dynamic> json) =>
    _RefreshResponse(
      access: json['access'] as String,
      refresh: json['refresh'] as String?,
    );

Map<String, dynamic> _$RefreshResponseToJson(_RefreshResponse instance) =>
    <String, dynamic>{'access': instance.access, 'refresh': instance.refresh};

_SessionRole _$SessionRoleFromJson(Map<String, dynamic> json) =>
    _SessionRole(code: json['code'] as String, name: json['name'] as String);

Map<String, dynamic> _$SessionRoleToJson(_SessionRole instance) =>
    <String, dynamic>{'code': instance.code, 'name': instance.name};

_SessionUser _$SessionUserFromJson(Map<String, dynamic> json) => _SessionUser(
  id: json['id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  isActive: json['is_active'] as bool,
  role: json['role'] == null
      ? null
      : SessionRole.fromJson(json['role'] as Map<String, dynamic>),
  canManageHr: json['can_manage_hr'] as bool? ?? false,
);

Map<String, dynamic> _$SessionUserToJson(_SessionUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'is_active': instance.isActive,
      'role': instance.role,
      'can_manage_hr': instance.canManageHr,
    };
