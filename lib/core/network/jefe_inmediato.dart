import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../auth/session_controller.dart';
import 'api_page.dart';

part 'jefe_inmediato.freezed.dart';
part 'jefe_inmediato.g.dart';

// Salida de GET /employment/empleados/{id}/jefe/ — vive en core/ porque más
// de un feature necesita mostrar "jefe inmediato" (Empleado, Posiciones)
// sin que ninguno importe el modelo del otro.
@freezed
abstract class JefeInmediato with _$JefeInmediato {
  const factory JefeInmediato({
    @JsonKey(name: 'posicion_id') String? posicionId,
    String? puesto,
    @JsonKey(name: 'empleado_id') String? empleadoId,
    String? nombre,
  }) = _JefeInmediato;
  factory JefeInmediato.fromJson(Map<String, dynamic> json) =>
      _$JefeInmediatoFromJson(json);
}

@Riverpod(retry: manualRetryOnly)
Future<JefeInmediato> jefeInmediato(Ref ref, String empleadoId) async {
  final api = ref.watch(sessionServiceProvider).api;
  final response = await api.get<Map<String, dynamic>>(
    'employment/empleados/$empleadoId/jefe/',
  );
  return JefeInmediato.fromJson(response.data!);
}
