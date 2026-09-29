import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_models.freezed.dart';
part 'schedule_models.g.dart';

@freezed
abstract class Catorcena with _$Catorcena {
  const factory Catorcena({
    required String id,
    required int numero,
    required int anio,
    @JsonKey(name: 'fecha_inicio') required String fechaInicio,
    @JsonKey(name: 'fecha_fin') required String fechaFin,
  }) = _Catorcena;
  factory Catorcena.fromJson(Map<String, dynamic> json) =>
      _$CatorcenaFromJson(json);
}

@freezed
abstract class TipoHorarioRef with _$TipoHorarioRef {
  const factory TipoHorarioRef({
    required int id,
    required String code,
    required String name,
    @Default('') String descripcion,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _TipoHorarioRef;
  factory TipoHorarioRef.fromJson(Map<String, dynamic> json) =>
      _$TipoHorarioRefFromJson(json);
}

// Referencias mínimas a recursos de OTROS módulos (Empleado, Área) — a
// propósito no se importa el modelo real de employment/locations, misma
// regla que PersonSummary en Fase 3 y RefEntry en Fase 4.
@freezed
abstract class EmpleadoRef with _$EmpleadoRef {
  const factory EmpleadoRef({
    required String id,
    @JsonKey(name: 'work_number') String? workNumber,
  }) = _EmpleadoRef;
  factory EmpleadoRef.fromJson(Map<String, dynamic> json) =>
      _$EmpleadoRefFromJson(json);
}

@freezed
abstract class AreaRef with _$AreaRef {
  const factory AreaRef({
    required String id,
    required String code,
    required String name,
  }) = _AreaRef;
  factory AreaRef.fromJson(Map<String, dynamic> json) =>
      _$AreaRefFromJson(json);
}

@freezed
abstract class AsignacionHorario with _$AsignacionHorario {
  const factory AsignacionHorario({
    required String id,
    required String empleado,
    String? catorcena,
    @JsonKey(name: 'fecha_referencia') required String fechaReferencia,
    @JsonKey(name: 'tipo_horario') required int tipoHorario,
  }) = _AsignacionHorario;
  factory AsignacionHorario.fromJson(Map<String, dynamic> json) =>
      _$AsignacionHorarioFromJson(json);
}

@freezed
abstract class AsignacionUbicacion with _$AsignacionUbicacion {
  const factory AsignacionUbicacion({
    required String id,
    required String empleado,
    String? catorcena,
    @JsonKey(name: 'fecha_referencia') required String fechaReferencia,
    required String area,
  }) = _AsignacionUbicacion;
  factory AsignacionUbicacion.fromJson(Map<String, dynamic> json) =>
      _$AsignacionUbicacionFromJson(json);
}

String? nameInTipoHorario(List<TipoHorarioRef> catalog, int id) {
  for (final item in catalog) {
    if (item.id == id) return item.name;
  }
  return null;
}

String? nameInAreaRef(List<AreaRef> catalog, String id) {
  for (final item in catalog) {
    if (item.id == id) return item.name;
  }
  return null;
}

String? labelForCatorcena(List<Catorcena> catalog, String? id) {
  if (id == null) return null;
  for (final item in catalog) {
    if (item.id == id) return '${item.numero}/${item.anio}';
  }
  return null;
}
