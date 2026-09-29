// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Empleado _$EmpleadoFromJson(Map<String, dynamic> json) => _Empleado(
  id: json['id'] as String,
  persona: json['persona'] as String,
  user: json['user'] as String?,
  workNumber: json['work_number'] as String?,
);

Map<String, dynamic> _$EmpleadoToJson(_Empleado instance) => <String, dynamic>{
  'id': instance.id,
  'persona': instance.persona,
  'user': instance.user,
  'work_number': instance.workNumber,
};

_Contrato _$ContratoFromJson(Map<String, dynamic> json) => _Contrato(
  id: json['id'] as String,
  empleado: json['empleado'] as String,
  posicion: json['posicion'] as String,
  fechaIngreso: json['fecha_ingreso'] as String?,
  fechaAlta: json['fecha_alta'] as String?,
  fechaReingreso: json['fecha_reingreso'] as String?,
  fechaBaja: json['fecha_baja'] as String?,
);

Map<String, dynamic> _$ContratoToJson(_Contrato instance) => <String, dynamic>{
  'id': instance.id,
  'empleado': instance.empleado,
  'posicion': instance.posicion,
  'fecha_ingreso': instance.fechaIngreso,
  'fecha_alta': instance.fechaAlta,
  'fecha_reingreso': instance.fechaReingreso,
  'fecha_baja': instance.fechaBaja,
};

_PersonSummary _$PersonSummaryFromJson(Map<String, dynamic> json) =>
    _PersonSummary(
      id: json['id'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastNamePaternal: json['last_name_paternal'] as String? ?? '',
      lastNameMaternal: json['last_name_maternal'] as String? ?? '',
      personalEmail: json['personal_email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
    );

Map<String, dynamic> _$PersonSummaryToJson(_PersonSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name_paternal': instance.lastNamePaternal,
      'last_name_maternal': instance.lastNameMaternal,
      'personal_email': instance.personalEmail,
      'phone': instance.phone,
    };

_NamedRef _$NamedRefFromJson(Map<String, dynamic> json) =>
    _NamedRef(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$NamedRefToJson(_NamedRef instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

_PosicionSummary _$PosicionSummaryFromJson(Map<String, dynamic> json) =>
    _PosicionSummary(
      id: json['id'] as String,
      puesto: (json['puesto'] as num?)?.toInt(),
      estatus: (json['estatus'] as num).toInt(),
    );

Map<String, dynamic> _$PosicionSummaryToJson(_PosicionSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'puesto': instance.puesto,
      'estatus': instance.estatus,
    };
