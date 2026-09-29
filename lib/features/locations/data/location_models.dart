import 'package:freezed_annotation/freezed_annotation.dart';
part 'location_models.freezed.dart';
part 'location_models.g.dart';

enum LocationKind {
  ubicaciones('Ubicaciones', 'ubicación'),
  naves('Naves', 'nave'),
  areas('Áreas', 'área');

  const LocationKind(this.label, this.singular);
  final String label;
  final String singular;
  String get path => 'locations/$name/';
}

// Campos comunes y relaciones reales de los tres recursos. El repositorio
// envía únicamente los campos admitidos por el recurso elegido.
@freezed
abstract class LocationRecord with _$LocationRecord {
  const LocationRecord._();
  const factory LocationRecord({
    required String id,
    required String code,
    @Default('') String name,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'employer_registration')
    @Default('')
    String employerRegistration,
    String? ubicacion,
    String? nave,
  }) = _LocationRecord;
  factory LocationRecord.fromJson(Map<String, dynamic> json) =>
      _$LocationRecordFromJson(json);
  String get displayName => name.trim().isEmpty ? code : '$code · $name';
}

class LocationCatalog {
  const LocationCatalog({required this.ubicaciones, required this.naves});
  final List<LocationRecord> ubicaciones;
  final List<LocationRecord> naves;

  List<LocationRecord> navesAt(String? ubicacion) => ubicacion == null
      ? []
      : naves.where((item) => item.ubicacion == ubicacion).toList();

  LocationRecord? naveById(String? id) {
    for (final item in naves) {
      if (item.id == id) return item;
    }
    return null;
  }

  String ubicacionName(String? id) {
    for (final item in ubicaciones) {
      if (item.id == id) return item.displayName;
    }
    return 'Ubicación no disponible';
  }
}
