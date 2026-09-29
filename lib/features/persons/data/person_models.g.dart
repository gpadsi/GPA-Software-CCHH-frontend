// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonCatalogEntry _$PersonCatalogEntryFromJson(Map<String, dynamic> json) =>
    _PersonCatalogEntry(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$PersonCatalogEntryToJson(_PersonCatalogEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'is_active': instance.isActive,
    };

_Persona _$PersonaFromJson(Map<String, dynamic> json) => _Persona(
  id: json['id'] as String,
  firstName: json['first_name'] as String? ?? '',
  lastNamePaternal: json['last_name_paternal'] as String? ?? '',
  lastNameMaternal: json['last_name_maternal'] as String? ?? '',
  curp: json['curp'] as String?,
  nss: json['nss'] as String?,
  rfc: json['rfc'] as String?,
  birthDate: json['birth_date'] as String?,
  birthPlaceState: json['birth_place_state'] as String? ?? '',
  gender: (json['gender'] as num?)?.toInt(),
  maritalStatus: (json['marital_status'] as num?)?.toInt(),
  educationLevel: (json['education_level'] as num?)?.toInt(),
  hasChildren: json['has_children'] as bool? ?? false,
  personalEmail: json['personal_email'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  addressLine: json['address_line'] as String? ?? '',
  postalCode: json['postal_code'] as String? ?? '',
  city: json['city'] as String? ?? '',
  municipality: json['municipality'] as String? ?? '',
  state: json['state'] as String? ?? '',
);

Map<String, dynamic> _$PersonaToJson(_Persona instance) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name_paternal': instance.lastNamePaternal,
  'last_name_maternal': instance.lastNameMaternal,
  'curp': instance.curp,
  'nss': instance.nss,
  'rfc': instance.rfc,
  'birth_date': instance.birthDate,
  'birth_place_state': instance.birthPlaceState,
  'gender': instance.gender,
  'marital_status': instance.maritalStatus,
  'education_level': instance.educationLevel,
  'has_children': instance.hasChildren,
  'personal_email': instance.personalEmail,
  'phone': instance.phone,
  'address_line': instance.addressLine,
  'postal_code': instance.postalCode,
  'city': instance.city,
  'municipality': instance.municipality,
  'state': instance.state,
};

_ContactoUrgencia _$ContactoUrgenciaFromJson(Map<String, dynamic> json) =>
    _ContactoUrgencia(
      id: json['id'] as String,
      persona: json['persona'] as String,
      name: json['name'] as String? ?? '',
      relationship: json['relationship'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );

Map<String, dynamic> _$ContactoUrgenciaToJson(_ContactoUrgencia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'persona': instance.persona,
      'name': instance.name,
      'relationship': instance.relationship,
      'phone': instance.phone,
    };

_PerfilMedico _$PerfilMedicoFromJson(Map<String, dynamic> json) =>
    _PerfilMedico(
      id: json['id'] as String,
      persona: json['persona'] as String,
      bloodType: (json['blood_type'] as num?)?.toInt(),
      allergies: json['allergies'] as String? ?? '',
    );

Map<String, dynamic> _$PerfilMedicoToJson(_PerfilMedico instance) =>
    <String, dynamic>{
      'id': instance.id,
      'persona': instance.persona,
      'blood_type': instance.bloodType,
      'allergies': instance.allergies,
    };
