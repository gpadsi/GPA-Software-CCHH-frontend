// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocationRecord _$LocationRecordFromJson(Map<String, dynamic> json) =>
    _LocationRecord(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      employerRegistration: json['employer_registration'] as String? ?? '',
      ubicacion: json['ubicacion'] as String?,
      nave: json['nave'] as String?,
    );

Map<String, dynamic> _$LocationRecordToJson(_LocationRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'is_active': instance.isActive,
      'employer_registration': instance.employerRegistration,
      'ubicacion': instance.ubicacion,
      'nave': instance.nave,
    };
