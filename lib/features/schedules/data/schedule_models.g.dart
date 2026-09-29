// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Catorcena _$CatorcenaFromJson(Map<String, dynamic> json) => _Catorcena(
  id: json['id'] as String,
  numero: (json['numero'] as num).toInt(),
  anio: (json['anio'] as num).toInt(),
  fechaInicio: json['fecha_inicio'] as String,
  fechaFin: json['fecha_fin'] as String,
);

Map<String, dynamic> _$CatorcenaToJson(_Catorcena instance) =>
    <String, dynamic>{
      'id': instance.id,
      'numero': instance.numero,
      'anio': instance.anio,
      'fecha_inicio': instance.fechaInicio,
      'fecha_fin': instance.fechaFin,
    };

_TipoHorarioRef _$TipoHorarioRefFromJson(Map<String, dynamic> json) =>
    _TipoHorarioRef(
      id: (json['id'] as num).toInt(),
      code: json['code'] as String,
      name: json['name'] as String,
      descripcion: json['descripcion'] as String? ?? '',
      isActive: json['is_active'] as bool,
    );

Map<String, dynamic> _$TipoHorarioRefToJson(_TipoHorarioRef instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'descripcion': instance.descripcion,
      'is_active': instance.isActive,
    };

_EmpleadoRef _$EmpleadoRefFromJson(Map<String, dynamic> json) => _EmpleadoRef(
  id: json['id'] as String,
  workNumber: json['work_number'] as String?,
);

Map<String, dynamic> _$EmpleadoRefToJson(_EmpleadoRef instance) =>
    <String, dynamic>{'id': instance.id, 'work_number': instance.workNumber};

_AreaRef _$AreaRefFromJson(Map<String, dynamic> json) => _AreaRef(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$AreaRefToJson(_AreaRef instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
};

_AsignacionHorario _$AsignacionHorarioFromJson(Map<String, dynamic> json) =>
    _AsignacionHorario(
      id: json['id'] as String,
      empleado: json['empleado'] as String,
      catorcena: json['catorcena'] as String?,
      fechaReferencia: json['fecha_referencia'] as String,
      tipoHorario: (json['tipo_horario'] as num).toInt(),
    );

Map<String, dynamic> _$AsignacionHorarioToJson(_AsignacionHorario instance) =>
    <String, dynamic>{
      'id': instance.id,
      'empleado': instance.empleado,
      'catorcena': instance.catorcena,
      'fecha_referencia': instance.fechaReferencia,
      'tipo_horario': instance.tipoHorario,
    };

_AsignacionUbicacion _$AsignacionUbicacionFromJson(Map<String, dynamic> json) =>
    _AsignacionUbicacion(
      id: json['id'] as String,
      empleado: json['empleado'] as String,
      catorcena: json['catorcena'] as String?,
      fechaReferencia: json['fecha_referencia'] as String,
      area: json['area'] as String,
    );

Map<String, dynamic> _$AsignacionUbicacionToJson(
  _AsignacionUbicacion instance,
) => <String, dynamic>{
  'id': instance.id,
  'empleado': instance.empleado,
  'catorcena': instance.catorcena,
  'fecha_referencia': instance.fechaReferencia,
  'area': instance.area,
};
