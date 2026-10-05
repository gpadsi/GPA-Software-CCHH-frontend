import 'package:freezed_annotation/freezed_annotation.dart';

part 'person_models.freezed.dart';
part 'person_models.g.dart';

@freezed
abstract class PersonCatalogEntry with _$PersonCatalogEntry {
  const factory PersonCatalogEntry({
    required int id,
    required String code,
    required String name,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _PersonCatalogEntry;
  factory PersonCatalogEntry.fromJson(Map<String, dynamic> json) =>
      _$PersonCatalogEntryFromJson(json);
}

@freezed
abstract class Persona with _$Persona {
  const Persona._();
  const factory Persona({
    required String id,
    @JsonKey(name: 'first_name') @Default('') String firstName,
    @JsonKey(name: 'last_name_paternal') @Default('') String lastNamePaternal,
    @JsonKey(name: 'last_name_maternal') @Default('') String lastNameMaternal,
    String? curp,
    String? nss,
    String? rfc,
    @JsonKey(name: 'birth_date') String? birthDate,
    @JsonKey(name: 'birth_place_state') @Default('') String birthPlaceState,
    int? gender,
    @JsonKey(name: 'marital_status') int? maritalStatus,
    @JsonKey(name: 'education_level') int? educationLevel,
    @JsonKey(name: 'has_children') @Default(false) bool hasChildren,
    @JsonKey(name: 'personal_email') @Default('') String personalEmail,
    @Default('') String phone,
    @JsonKey(name: 'address_line') @Default('') String addressLine,
    @JsonKey(name: 'postal_code') @Default('') String postalCode,
    @Default('') String city,
    @Default('') String municipality,
    @Default('') String state,
  }) = _Persona;
  factory Persona.fromJson(Map<String, dynamic> json) =>
      _$PersonaFromJson(json);

  // Sin el apellido materno (hay personas que no lo tienen) no queda un
  // espacio doble entre los demás.
  String get fullName => [
    lastNamePaternal,
    lastNameMaternal,
    firstName,
  ].where((part) => part.trim().isNotEmpty).join(' ');
}

@freezed
abstract class ContactoUrgencia with _$ContactoUrgencia {
  const factory ContactoUrgencia({
    required String id,
    required String persona,
    @Default('') String name,
    @Default('') String relationship,
    @Default('') String phone,
  }) = _ContactoUrgencia;
  factory ContactoUrgencia.fromJson(Map<String, dynamic> json) =>
      _$ContactoUrgenciaFromJson(json);
}

@freezed
abstract class PerfilMedico with _$PerfilMedico {
  const factory PerfilMedico({
    required String id,
    required String persona,
    @JsonKey(name: 'blood_type') int? bloodType,
    @Default('') String allergies,
  }) = _PerfilMedico;
  factory PerfilMedico.fromJson(Map<String, dynamic> json) =>
      _$PerfilMedicoFromJson(json);
}

// Catálogos de Persona: los 4 son opcionales y de solo lectura, se cargan
// una sola vez y se reusan tanto en la tabla como en el formulario.
class PersonCatalogs {
  const PersonCatalogs({
    required this.generos,
    required this.estadosCiviles,
    required this.escolaridades,
    required this.tiposSangre,
  });
  final List<PersonCatalogEntry> generos;
  final List<PersonCatalogEntry> estadosCiviles;
  final List<PersonCatalogEntry> escolaridades;
  final List<PersonCatalogEntry> tiposSangre;

  static String? nameIn(List<PersonCatalogEntry> catalog, int? id) {
    if (id == null) return null;
    for (final item in catalog) {
      if (item.id == id) return item.name;
    }
    return null;
  }
}
