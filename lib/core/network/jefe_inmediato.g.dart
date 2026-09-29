// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jefe_inmediato.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JefeInmediato _$JefeInmediatoFromJson(Map<String, dynamic> json) =>
    _JefeInmediato(
      posicionId: json['posicion_id'] as String?,
      puesto: json['puesto'] as String?,
      empleadoId: json['empleado_id'] as String?,
      nombre: json['nombre'] as String?,
    );

Map<String, dynamic> _$JefeInmediatoToJson(_JefeInmediato instance) =>
    <String, dynamic>{
      'posicion_id': instance.posicionId,
      'puesto': instance.puesto,
      'empleado_id': instance.empleadoId,
      'nombre': instance.nombre,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(jefeInmediato)
final jefeInmediatoProvider = JefeInmediatoFamily._();

final class JefeInmediatoProvider
    extends
        $FunctionalProvider<
          AsyncValue<JefeInmediato>,
          JefeInmediato,
          FutureOr<JefeInmediato>
        >
    with $FutureModifier<JefeInmediato>, $FutureProvider<JefeInmediato> {
  JefeInmediatoProvider._({
    required JefeInmediatoFamily super.from,
    required String super.argument,
  }) : super(
         retry: manualRetryOnly,
         name: r'jefeInmediatoProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$jefeInmediatoHash();

  @override
  String toString() {
    return r'jefeInmediatoProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<JefeInmediato> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<JefeInmediato> create(Ref ref) {
    final argument = this.argument as String;
    return jefeInmediato(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is JefeInmediatoProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$jefeInmediatoHash() => r'72f8bc0141ef915c4643d5bd006c08e9a936a0da';

final class JefeInmediatoFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<JefeInmediato>, String> {
  JefeInmediatoFamily._()
    : super(
        retry: manualRetryOnly,
        name: r'jefeInmediatoProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  JefeInmediatoProvider call(String empleadoId) =>
      JefeInmediatoProvider._(argument: empleadoId, from: this);

  @override
  String toString() => r'jefeInmediatoProvider';
}
