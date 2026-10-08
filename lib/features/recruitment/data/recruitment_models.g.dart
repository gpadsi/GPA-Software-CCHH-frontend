// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recruitment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecruitmentCatalogEntry _$RecruitmentCatalogEntryFromJson(
  Map<String, dynamic> json,
) => _RecruitmentCatalogEntry(
  id: (json['id'] as num).toInt(),
  code: json['code'] as String,
  name: json['name'] as String,
  isActive: json['is_active'] as bool? ?? true,
  esTerminal: json['es_terminal'] as bool? ?? false,
  requiereJustificacion: json['requiere_justificacion'] as bool? ?? false,
  requierePersona: json['requiere_persona'] as bool? ?? false,
);

Map<String, dynamic> _$RecruitmentCatalogEntryToJson(
  _RecruitmentCatalogEntry instance,
) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'is_active': instance.isActive,
  'es_terminal': instance.esTerminal,
  'requiere_justificacion': instance.requiereJustificacion,
  'requiere_persona': instance.requierePersona,
};

_PosicionRef _$PosicionRefFromJson(Map<String, dynamic> json) => _PosicionRef(
  id: json['id'] as String,
  etiqueta: json['etiqueta'] as String? ?? '',
);

Map<String, dynamic> _$PosicionRefToJson(_PosicionRef instance) =>
    <String, dynamic>{'id': instance.id, 'etiqueta': instance.etiqueta};

_TramiteAbierto _$TramiteAbiertoFromJson(Map<String, dynamic> json) =>
    _TramiteAbierto(
      tipo: json['tipo'] as String,
      id: json['id'] as String?,
      estado: json['estado'] as String?,
    );

Map<String, dynamic> _$TramiteAbiertoToJson(_TramiteAbierto instance) =>
    <String, dynamic>{
      'tipo': instance.tipo,
      'id': instance.id,
      'estado': instance.estado,
    };

_PosicionElegible _$PosicionElegibleFromJson(Map<String, dynamic> json) =>
    _PosicionElegible(
      id: json['id'] as String,
      etiqueta: json['etiqueta'] as String,
      puesto: json['puesto'] as String?,
      unidad: json['unidad'] as String,
      area: json['area'] as String?,
      estatus: json['estatus'] as String,
      estatusCode: json['estatus_code'] as String,
      ocupada: json['ocupada'] as bool,
      tramiteAbierto: json['tramite_abierto'] == null
          ? null
          : TramiteAbierto.fromJson(
              json['tramite_abierto'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$PosicionElegibleToJson(_PosicionElegible instance) =>
    <String, dynamic>{
      'id': instance.id,
      'etiqueta': instance.etiqueta,
      'puesto': instance.puesto,
      'unidad': instance.unidad,
      'area': instance.area,
      'estatus': instance.estatus,
      'estatus_code': instance.estatusCode,
      'ocupada': instance.ocupada,
      'tramite_abierto': instance.tramiteAbierto,
    };

_Aprobacion _$AprobacionFromJson(Map<String, dynamic> json) => _Aprobacion(
  id: json['id'] as String,
  requisicion: json['requisicion'] as String,
  etapa: (json['etapa'] as num).toInt(),
  fecha: json['fecha'] as String?,
  usuario: json['usuario'] as String?,
  nombreManual: json['nombre_manual'] as String? ?? '',
);

Map<String, dynamic> _$AprobacionToJson(_Aprobacion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requisicion': instance.requisicion,
      'etapa': instance.etapa,
      'fecha': instance.fecha,
      'usuario': instance.usuario,
      'nombre_manual': instance.nombreManual,
    };

_Requisicion _$RequisicionFromJson(Map<String, dynamic> json) => _Requisicion(
  id: json['id'] as String,
  posicion: json['posicion'] as String,
  posicionEtiqueta: json['posicion_etiqueta'] as String? ?? '',
  tipo: (json['tipo'] as num).toInt(),
  estado: (json['estado'] as num).toInt(),
  creadoPor: json['creado_por'] as String?,
  solicitante: json['solicitante'] as String?,
  fechaSolicitud: json['fecha_solicitud'] as String,
  fechaACubrirVacante: json['fecha_a_cubrir_vacante'] as String?,
  fechaEntregaACapitalHumano: json['fecha_entrega_a_capital_humano'] as String?,
  areaSolicitante: json['area_solicitante'] as String? ?? '',
  justificacion: json['justificacion'] as String? ?? '',
  horarioACubrir: (json['horario_a_cubrir'] as num?)?.toInt(),
  idiomasRequeridos: json['idiomas_requeridos'] as String? ?? '',
  disposicionViajar: json['disposicion_viajar'] as bool?,
  nivelTabulador: json['nivel_tabulador'] as String? ?? '',
  sueldoMensualCompuesto: json['sueldo_mensual_compuesto'] as String?,
  sueldoMensualBruto: json['sueldo_mensual_bruto'] as String?,
  sueldoMensualNeto: json['sueldo_mensual_neto'] as String?,
  tipoContratoOfrecido: (json['tipo_contrato_ofrecido'] as num?)?.toInt(),
  motivoSuspension: json['motivo_suspension'] as String? ?? '',
  fechaSuspension: json['fecha_suspension'] as String?,
  autorizadoPorSuspension: json['autorizado_por_suspension'] as String? ?? '',
  aprobaciones:
      (json['aprobaciones'] as List<dynamic>?)
          ?.map((e) => Aprobacion.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Aprobacion>[],
);

Map<String, dynamic> _$RequisicionToJson(_Requisicion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'posicion': instance.posicion,
      'posicion_etiqueta': instance.posicionEtiqueta,
      'tipo': instance.tipo,
      'estado': instance.estado,
      'creado_por': instance.creadoPor,
      'solicitante': instance.solicitante,
      'fecha_solicitud': instance.fechaSolicitud,
      'fecha_a_cubrir_vacante': instance.fechaACubrirVacante,
      'fecha_entrega_a_capital_humano': instance.fechaEntregaACapitalHumano,
      'area_solicitante': instance.areaSolicitante,
      'justificacion': instance.justificacion,
      'horario_a_cubrir': instance.horarioACubrir,
      'idiomas_requeridos': instance.idiomasRequeridos,
      'disposicion_viajar': instance.disposicionViajar,
      'nivel_tabulador': instance.nivelTabulador,
      'sueldo_mensual_compuesto': instance.sueldoMensualCompuesto,
      'sueldo_mensual_bruto': instance.sueldoMensualBruto,
      'sueldo_mensual_neto': instance.sueldoMensualNeto,
      'tipo_contrato_ofrecido': instance.tipoContratoOfrecido,
      'motivo_suspension': instance.motivoSuspension,
      'fecha_suspension': instance.fechaSuspension,
      'autorizado_por_suspension': instance.autorizadoPorSuspension,
      'aprobaciones': instance.aprobaciones,
    };

_TextoNumerado _$TextoNumeradoFromJson(Map<String, dynamic> json) =>
    _TextoNumerado(
      orden: (json['orden'] as num).toInt(),
      texto: json['texto'] as String,
    );

Map<String, dynamic> _$TextoNumeradoToJson(_TextoNumerado instance) =>
    <String, dynamic>{'orden': instance.orden, 'texto': instance.texto};

_Conformidad _$ConformidadFromJson(Map<String, dynamic> json) => _Conformidad(
  id: json['id'] as String,
  descriptivo: json['descriptivo'] as String,
  rol: (json['rol'] as num).toInt(),
  persona: json['persona'] as String?,
  personaNombre: json['persona_nombre'] as String?,
  fecha: json['fecha'] as String?,
  usuario: json['usuario'] as String?,
  nombreManual: json['nombre_manual'] as String? ?? '',
);

Map<String, dynamic> _$ConformidadToJson(_Conformidad instance) =>
    <String, dynamic>{
      'id': instance.id,
      'descriptivo': instance.descriptivo,
      'rol': instance.rol,
      'persona': instance.persona,
      'persona_nombre': instance.personaNombre,
      'fecha': instance.fecha,
      'usuario': instance.usuario,
      'nombre_manual': instance.nombreManual,
    };

_Descriptivo _$DescriptivoFromJson(Map<String, dynamic> json) => _Descriptivo(
  id: json['id'] as String,
  posicion: json['posicion'] as String,
  posicionEtiqueta: json['posicion_etiqueta'] as String? ?? '',
  version: (json['version'] as num).toInt(),
  congeladoEn: json['congelado_en'] as String?,
  estaCongelado: json['esta_congelado'] as bool? ?? false,
  nombrePuesto: json['nombre_puesto'] as String? ?? '',
  empresa: json['empresa'] as String? ?? '',
  areaDepartamento: json['area_departamento'] as String? ?? '',
  reportaA: json['reporta_a'] as String? ?? '',
  supervisaA: json['supervisa_a'] as String? ?? '',
  fechaElaboracion: json['fecha_elaboracion'] as String,
  edad: (json['edad'] as num?)?.toInt(),
  edadOtro: json['edad_otro'] as String? ?? '',
  disponibilidadViajar: json['disponibilidad_viajar'] as bool?,
  diasPorLaborar: (json['dias_por_laborar'] as num?)?.toInt(),
  diasPorLaborarOtro: json['dias_por_laborar_otro'] as String? ?? '',
  horario: (json['horario'] as num?)?.toInt(),
  horarioOtro: json['horario_otro'] as String? ?? '',
  proposito: json['proposito'] as String? ?? '',
  decisionesOperativas: json['decisiones_operativas'] as String? ?? '',
  decisionesFuncionales: json['decisiones_funcionales'] as String? ?? '',
  decisionesEstrategicas: json['decisiones_estrategicas'] as String? ?? '',
  relacionesInternas: json['relaciones_internas'] as String? ?? '',
  relacionesExternas: json['relaciones_externas'] as String? ?? '',
  escolaridadMinima: json['escolaridad_minima'] as String? ?? '',
  experienciaRequerida: json['experiencia_requerida'] as String? ?? '',
  idiomas: json['idiomas'] as String? ?? '',
  competenciasTecnicas: json['competencias_tecnicas'] as String? ?? '',
  competencias:
      (json['competencias'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  competenciasOtras: json['competencias_otras'] as String? ?? '',
  recursos:
      (json['recursos'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  recursosOtro: json['recursos_otro'] as String? ?? '',
  funciones:
      (json['funciones'] as List<dynamic>?)
          ?.map((e) => TextoNumerado.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TextoNumerado>[],
  indicadores:
      (json['indicadores'] as List<dynamic>?)
          ?.map((e) => TextoNumerado.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TextoNumerado>[],
  conformidades:
      (json['conformidades'] as List<dynamic>?)
          ?.map((e) => Conformidad.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Conformidad>[],
);

Map<String, dynamic> _$DescriptivoToJson(_Descriptivo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'posicion': instance.posicion,
      'posicion_etiqueta': instance.posicionEtiqueta,
      'version': instance.version,
      'congelado_en': instance.congeladoEn,
      'esta_congelado': instance.estaCongelado,
      'nombre_puesto': instance.nombrePuesto,
      'empresa': instance.empresa,
      'area_departamento': instance.areaDepartamento,
      'reporta_a': instance.reportaA,
      'supervisa_a': instance.supervisaA,
      'fecha_elaboracion': instance.fechaElaboracion,
      'edad': instance.edad,
      'edad_otro': instance.edadOtro,
      'disponibilidad_viajar': instance.disponibilidadViajar,
      'dias_por_laborar': instance.diasPorLaborar,
      'dias_por_laborar_otro': instance.diasPorLaborarOtro,
      'horario': instance.horario,
      'horario_otro': instance.horarioOtro,
      'proposito': instance.proposito,
      'decisiones_operativas': instance.decisionesOperativas,
      'decisiones_funcionales': instance.decisionesFuncionales,
      'decisiones_estrategicas': instance.decisionesEstrategicas,
      'relaciones_internas': instance.relacionesInternas,
      'relaciones_externas': instance.relacionesExternas,
      'escolaridad_minima': instance.escolaridadMinima,
      'experiencia_requerida': instance.experienciaRequerida,
      'idiomas': instance.idiomas,
      'competencias_tecnicas': instance.competenciasTecnicas,
      'competencias': instance.competencias,
      'competencias_otras': instance.competenciasOtras,
      'recursos': instance.recursos,
      'recursos_otro': instance.recursosOtro,
      'funciones': instance.funciones,
      'indicadores': instance.indicadores,
      'conformidades': instance.conformidades,
    };
