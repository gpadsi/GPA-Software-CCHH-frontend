// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PositionCatalogEntry _$PositionCatalogEntryFromJson(
  Map<String, dynamic> json,
) => _PositionCatalogEntry(
  id: (json['id'] as num).toInt(),
  code: json['code'] as String,
  name: json['name'] as String,
  isActive: json['is_active'] as bool,
  esGerenciaDeUnidad: json['es_gerencia_de_unidad'] as bool? ?? false,
);

Map<String, dynamic> _$PositionCatalogEntryToJson(
  _PositionCatalogEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'is_active': instance.isActive,
  'es_gerencia_de_unidad': instance.esGerenciaDeUnidad,
};

_RefEntry _$RefEntryFromJson(Map<String, dynamic> json) => _RefEntry(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$RefEntryToJson(_RefEntry instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
};

_Posicion _$PosicionFromJson(Map<String, dynamic> json) => _Posicion(
  id: json['id'] as String,
  organizationNode: json['organization_node'] as String,
  area: json['area'] as String?,
  puesto: (json['puesto'] as num?)?.toInt(),
  reportsTo: json['reports_to'] as String?,
  supervisionTexto: json['supervision_texto'] as String? ?? '',
  alcance: (json['alcance'] as num?)?.toInt(),
  tipoPosicion: (json['tipo_posicion'] as num?)?.toInt(),
  tipoRequisicion: (json['tipo_requisicion'] as num?)?.toInt(),
  estatus: (json['estatus'] as num).toInt(),
  generoRequerido: (json['genero_requerido'] as num?)?.toInt(),
  fechaRegistroVacante: json['fecha_registro_vacante'] as String?,
  fechaAutorizacionVacante: json['fecha_autorizacion_vacante'] as String?,
  headhunter: json['headhunter'] as String? ?? '',
  solicitanteVacante: json['solicitante_vacante'] as String? ?? '',
  proyectoEventual: json['proyecto_eventual'] as String? ?? '',
  fechaEsperadaTermino: json['fecha_esperada_termino'] as String?,
);

Map<String, dynamic> _$PosicionToJson(_Posicion instance) => <String, dynamic>{
  'id': instance.id,
  'organization_node': instance.organizationNode,
  'area': instance.area,
  'puesto': instance.puesto,
  'reports_to': instance.reportsTo,
  'supervision_texto': instance.supervisionTexto,
  'alcance': instance.alcance,
  'tipo_posicion': instance.tipoPosicion,
  'tipo_requisicion': instance.tipoRequisicion,
  'estatus': instance.estatus,
  'genero_requerido': instance.generoRequerido,
  'fecha_registro_vacante': instance.fechaRegistroVacante,
  'fecha_autorizacion_vacante': instance.fechaAutorizacionVacante,
  'headhunter': instance.headhunter,
  'solicitante_vacante': instance.solicitanteVacante,
  'proyecto_eventual': instance.proyectoEventual,
  'fecha_esperada_termino': instance.fechaEsperadaTermino,
};
