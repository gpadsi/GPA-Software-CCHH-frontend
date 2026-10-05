import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruitment_models.freezed.dart';
part 'recruitment_models.g.dart';

/// Una opción de cualquiera de los catálogos de Reclutamiento (estados,
/// etapas, tipos de contrato, horarios, rangos de edad, competencias...): la
/// misma forma, con las marcas que solo algunos traen en `false` por defecto.
@freezed
abstract class RecruitmentCatalogEntry with _$RecruitmentCatalogEntry {
  const factory RecruitmentCatalogEntry({
    required int id,
    required String code,
    required String name,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    // Estados de requisición: ya no cuenta como "abierta".
    @JsonKey(name: 'es_terminal') @Default(false) bool esTerminal,
    // Tipos de requisición: exige justificación.
    @JsonKey(name: 'requiere_justificacion')
    @Default(false)
    bool requiereJustificacion,
    // Roles de conformidad: se liga a una persona concreta.
    @JsonKey(name: 'requiere_persona') @Default(false) bool requierePersona,
  }) = _RecruitmentCatalogEntry;
  factory RecruitmentCatalogEntry.fromJson(Map<String, dynamic> json) =>
      _$RecruitmentCatalogEntryFromJson(json);
}

/// Referencia mínima a una Posición, con su nombre ya armado por el servidor
/// ("Puesto — Unidad (Área)"). A propósito no se importa el modelo de
/// features/positions: cada feature es dueño de la forma de lo que consume.
@freezed
abstract class PosicionRef with _$PosicionRef {
  const factory PosicionRef({
    required String id,
    @Default('') String etiqueta,
  }) = _PosicionRef;
  factory PosicionRef.fromJson(Map<String, dynamic> json) =>
      _$PosicionRefFromJson(json);
}

@freezed
abstract class Aprobacion with _$Aprobacion {
  const factory Aprobacion({
    required String id,
    required String requisicion,
    required int etapa,
    String? fecha,
    String? usuario,
    @JsonKey(name: 'nombre_manual') @Default('') String nombreManual,
  }) = _Aprobacion;
  factory Aprobacion.fromJson(Map<String, dynamic> json) =>
      _$AprobacionFromJson(json);
}

@freezed
abstract class Requisicion with _$Requisicion {
  const Requisicion._();
  const factory Requisicion({
    required String id,
    required String posicion,
    @JsonKey(name: 'posicion_etiqueta') @Default('') String posicionEtiqueta,
    required int tipo,
    required int estado,
    @JsonKey(name: 'creado_por') String? creadoPor,
    String? solicitante,
    @JsonKey(name: 'fecha_solicitud') required String fechaSolicitud,
    @JsonKey(name: 'fecha_a_cubrir_vacante') String? fechaACubrirVacante,
    @JsonKey(name: 'fecha_entrega_a_capital_humano')
    String? fechaEntregaACapitalHumano,
    @JsonKey(name: 'area_solicitante') @Default('') String areaSolicitante,
    @Default('') String justificacion,
    @JsonKey(name: 'horario_a_cubrir') int? horarioACubrir,
    @JsonKey(name: 'idiomas_requeridos') @Default('') String idiomasRequeridos,
    @JsonKey(name: 'disposicion_viajar') bool? disposicionViajar,
    @JsonKey(name: 'nivel_tabulador') @Default('') String nivelTabulador,
    // Los importes llegan como texto ("12500.00"): así no se pierden decimales.
    @JsonKey(name: 'sueldo_mensual_compuesto') String? sueldoMensualCompuesto,
    @JsonKey(name: 'sueldo_mensual_bruto') String? sueldoMensualBruto,
    @JsonKey(name: 'sueldo_mensual_neto') String? sueldoMensualNeto,
    @JsonKey(name: 'tipo_contrato_ofrecido') int? tipoContratoOfrecido,
    @JsonKey(name: 'motivo_suspension') @Default('') String motivoSuspension,
    @JsonKey(name: 'fecha_suspension') String? fechaSuspension,
    @JsonKey(name: 'autorizado_por_suspension')
    @Default('')
    String autorizadoPorSuspension,
    @Default(<Aprobacion>[]) List<Aprobacion> aprobaciones,
  }) = _Requisicion;
  factory Requisicion.fromJson(Map<String, dynamic> json) =>
      _$RequisicionFromJson(json);

  bool get tieneDatosDeSuspension =>
      motivoSuspension.trim().isNotEmpty ||
      fechaSuspension != null ||
      autorizadoPorSuspension.trim().isNotEmpty;
}

@freezed
abstract class TextoNumerado with _$TextoNumerado {
  const factory TextoNumerado({required int orden, required String texto}) =
      _TextoNumerado;
  factory TextoNumerado.fromJson(Map<String, dynamic> json) =>
      _$TextoNumeradoFromJson(json);
}

@freezed
abstract class Conformidad with _$Conformidad {
  const factory Conformidad({
    required String id,
    required String descriptivo,
    required int rol,
    String? persona,
    @JsonKey(name: 'persona_nombre') String? personaNombre,
    String? fecha,
    String? usuario,
    @JsonKey(name: 'nombre_manual') @Default('') String nombreManual,
  }) = _Conformidad;
  factory Conformidad.fromJson(Map<String, dynamic> json) =>
      _$ConformidadFromJson(json);
}

@freezed
abstract class Descriptivo with _$Descriptivo {
  const factory Descriptivo({
    required String id,
    required String posicion,
    @JsonKey(name: 'posicion_etiqueta') @Default('') String posicionEtiqueta,
    required int version,
    @JsonKey(name: 'congelado_en') String? congeladoEn,
    @JsonKey(name: 'esta_congelado') @Default(false) bool estaCongelado,
    @JsonKey(name: 'nombre_puesto') @Default('') String nombrePuesto,
    @Default('') String empresa,
    @JsonKey(name: 'area_departamento') @Default('') String areaDepartamento,
    @JsonKey(name: 'reporta_a') @Default('') String reportaA,
    @JsonKey(name: 'supervisa_a') @Default('') String supervisaA,
    @JsonKey(name: 'fecha_elaboracion') required String fechaElaboracion,
    int? edad,
    @JsonKey(name: 'edad_otro') @Default('') String edadOtro,
    @JsonKey(name: 'disponibilidad_viajar') bool? disponibilidadViajar,
    @JsonKey(name: 'dias_por_laborar') int? diasPorLaborar,
    @JsonKey(name: 'dias_por_laborar_otro')
    @Default('')
    String diasPorLaborarOtro,
    int? horario,
    @JsonKey(name: 'horario_otro') @Default('') String horarioOtro,
    @Default('') String proposito,
    @JsonKey(name: 'decisiones_operativas')
    @Default('')
    String decisionesOperativas,
    @JsonKey(name: 'decisiones_funcionales')
    @Default('')
    String decisionesFuncionales,
    @JsonKey(name: 'decisiones_estrategicas')
    @Default('')
    String decisionesEstrategicas,
    @JsonKey(name: 'relaciones_internas')
    @Default('')
    String relacionesInternas,
    @JsonKey(name: 'relaciones_externas')
    @Default('')
    String relacionesExternas,
    @JsonKey(name: 'escolaridad_minima') @Default('') String escolaridadMinima,
    @JsonKey(name: 'experiencia_requerida')
    @Default('')
    String experienciaRequerida,
    @Default('') String idiomas,
    @JsonKey(name: 'competencias_tecnicas')
    @Default('')
    String competenciasTecnicas,
    @Default(<int>[]) List<int> competencias,
    @JsonKey(name: 'competencias_otras') @Default('') String competenciasOtras,
    @Default(<int>[]) List<int> recursos,
    @JsonKey(name: 'recursos_otro') @Default('') String recursosOtro,
    @Default(<TextoNumerado>[]) List<TextoNumerado> funciones,
    @Default(<TextoNumerado>[]) List<TextoNumerado> indicadores,
    // Solo la manda el servidor a Capital Humano y Admin.
    @Default(<Conformidad>[]) List<Conformidad> conformidades,
  }) = _Descriptivo;
  factory Descriptivo.fromJson(Map<String, dynamic> json) =>
      _$DescriptivoFromJson(json);
}
