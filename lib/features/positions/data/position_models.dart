import 'package:freezed_annotation/freezed_annotation.dart';

part 'position_models.freezed.dart';
part 'position_models.g.dart';

// Catálogos con id entero: alcance, tipo de posición, tipo de requisición,
// estatus, puesto y género — misma forma para los 6, un solo tipo.
@freezed
abstract class PositionCatalogEntry with _$PositionCatalogEntry {
  const factory PositionCatalogEntry({
    required int id,
    required String code,
    required String name,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _PositionCatalogEntry;
  factory PositionCatalogEntry.fromJson(Map<String, dynamic> json) =>
      _$PositionCatalogEntryFromJson(json);
}

// Referencia mínima a un recurso de OTRO módulo (Unidad organizacional,
// Área) identificado por UUID — a propósito no se importa el modelo real de
// organizations/locations, misma regla que PersonSummary en employment.
@freezed
abstract class RefEntry with _$RefEntry {
  const factory RefEntry({
    required String id,
    required String code,
    required String name,
  }) = _RefEntry;
  factory RefEntry.fromJson(Map<String, dynamic> json) =>
      _$RefEntryFromJson(json);
}

@freezed
abstract class Posicion with _$Posicion {
  const factory Posicion({
    required String id,
    @JsonKey(name: 'organization_node') required String organizationNode,
    String? area,
    int? puesto,
    @JsonKey(name: 'reports_to') String? reportsTo,
    @JsonKey(name: 'supervision_texto') @Default('') String supervisionTexto,
    int? alcance,
    @JsonKey(name: 'tipo_posicion') int? tipoPosicion,
    @JsonKey(name: 'tipo_requisicion') int? tipoRequisicion,
    required int estatus,
    @JsonKey(name: 'genero_requerido') int? generoRequerido,
    @JsonKey(name: 'fecha_registro_vacante') String? fechaRegistroVacante,
    @JsonKey(name: 'fecha_autorizacion_vacante')
    String? fechaAutorizacionVacante,
    @Default('') String headhunter,
    @JsonKey(name: 'solicitante_vacante') @Default('') String solicitanteVacante,
    @JsonKey(name: 'proyecto_eventual') @Default('') String proyectoEventual,
    @JsonKey(name: 'fecha_esperada_termino') String? fechaEsperadaTermino,
  }) = _Posicion;
  factory Posicion.fromJson(Map<String, dynamic> json) =>
      _$PosicionFromJson(json);
}

// Los 6 catálogos de Posición: se cargan una sola vez y se reusan en la
// tabla (resolver nombres) y en el formulario (opciones de los selectores).
class PositionCatalogs {
  const PositionCatalogs({
    required this.alcances,
    required this.tiposPosicion,
    required this.tiposRequisicion,
    required this.estatus,
    required this.puestos,
    required this.generos,
    required this.organizationNodes,
    required this.areas,
  });
  final List<PositionCatalogEntry> alcances;
  final List<PositionCatalogEntry> tiposPosicion;
  final List<PositionCatalogEntry> tiposRequisicion;
  final List<PositionCatalogEntry> estatus;
  final List<PositionCatalogEntry> puestos;
  final List<PositionCatalogEntry> generos;
  final List<RefEntry> organizationNodes;
  final List<RefEntry> areas;

  static String? nameIn(List<PositionCatalogEntry> catalog, int? id) {
    if (id == null) return null;
    for (final item in catalog) {
      if (item.id == id) return item.name;
    }
    return null;
  }

  static String? nameInRefs(List<RefEntry> catalog, String? id) {
    if (id == null) return null;
    for (final item in catalog) {
      if (item.id == id) return item.name;
    }
    return null;
  }
}
