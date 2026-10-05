import 'package:freezed_annotation/freezed_annotation.dart';

part 'employment_models.freezed.dart';
part 'employment_models.g.dart';

@freezed
abstract class Empleado with _$Empleado {
  const factory Empleado({
    required String id,
    required String persona,
    String? user,
    @JsonKey(name: 'work_number') String? workNumber,
  }) = _Empleado;
  factory Empleado.fromJson(Map<String, dynamic> json) =>
      _$EmpleadoFromJson(json);
}

@freezed
abstract class Contrato with _$Contrato {
  const factory Contrato({
    required String id,
    required String empleado,
    required String posicion,
    @JsonKey(name: 'fecha_ingreso') String? fechaIngreso,
    @JsonKey(name: 'fecha_alta') String? fechaAlta,
    @JsonKey(name: 'fecha_reingreso') String? fechaReingreso,
    @JsonKey(name: 'fecha_baja') String? fechaBaja,
  }) = _Contrato;
  factory Contrato.fromJson(Map<String, dynamic> json) =>
      _$ContratoFromJson(json);
}

// Vistas MÍNIMAS de Persona/Posición, solo para lo que el detalle de
// Empleado necesita mostrar. A propósito no se importa el modelo Persona
// de features/persons ni uno de Posicion de features/positions (fase 4) —
// cada feature es dueña de su propia forma de los datos que consume desde
// otro recurso de la API, nunca reutiliza el tipo de otro feature.
@freezed
abstract class PersonSummary with _$PersonSummary {
  const PersonSummary._();
  const factory PersonSummary({
    required String id,
    @JsonKey(name: 'first_name') @Default('') String firstName,
    @JsonKey(name: 'last_name_paternal') @Default('') String lastNamePaternal,
    @JsonKey(name: 'last_name_maternal') @Default('') String lastNameMaternal,
    @JsonKey(name: 'personal_email') @Default('') String personalEmail,
    @Default('') String phone,
  }) = _PersonSummary;
  factory PersonSummary.fromJson(Map<String, dynamic> json) =>
      _$PersonSummaryFromJson(json);

  // Sin el apellido materno (hay personas que no lo tienen) no queda un
  // espacio doble entre los demás.
  String get fullName => [
    lastNamePaternal,
    lastNameMaternal,
    firstName,
  ].where((part) => part.trim().isNotEmpty).join(' ');
}

@freezed
abstract class NamedRef with _$NamedRef {
  const factory NamedRef({required int id, required String name}) = _NamedRef;
  factory NamedRef.fromJson(Map<String, dynamic> json) =>
      _$NamedRefFromJson(json);
}

@freezed
abstract class PosicionSummary with _$PosicionSummary {
  const factory PosicionSummary({
    required String id,
    int? puesto,
    required int estatus,
  }) = _PosicionSummary;
  factory PosicionSummary.fromJson(Map<String, dynamic> json) =>
      _$PosicionSummaryFromJson(json);
}
