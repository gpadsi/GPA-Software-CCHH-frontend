import 'package:dio/dio.dart';

/// El motivo que da el servidor cuando un borrado choca con otros registros
/// que todavía lo usan (409), ya redactado en español. Null en cualquier otro
/// caso.
String? conflictDetail(Object error) {
  if (error is DioException && error.response?.statusCode == 409) {
    final data = error.response?.data;
    final detail = data is Map ? data['detail'] : null;
    if (detail is String) {
      return detail;
    }
  }
  return null;
}

/// Los mensajes de validación que da el servidor en un 400
/// (`{campo: [mensajes]}`), ya en español, en una sola frase. [labels] pone el
/// nombre que ve la persona delante del mensaje de cada campo; sin etiqueta
/// (o en errores generales) va solo el mensaje. Null si no hay ninguno.
String? validationDetail(
  Object error, {
  Map<String, String> labels = const {},
}) {
  if (error is! DioException || error.response?.statusCode != 400) return null;
  final data = error.response?.data;
  if (data is! Map) return null;
  final parts = <String>[];
  data.forEach((field, value) {
    final messages = value is List ? value : [value];
    final label = labels[field];
    for (final message in messages) {
      if (message is! String || message.isEmpty) continue;
      parts.add(label == null ? message : '$label: $message');
    }
  });
  return parts.isEmpty ? null : parts.join(' ');
}

String apiErrorMessage(Object error, {bool login = false}) {
  if (error is DioException) {
    final code = error.response?.statusCode;
    if (login && (code == 401 || code == 400)) {
      return 'El usuario o la contraseña son incorrectos. Inténtalo de nuevo.';
    }
    if (code == 401) return 'Tu sesión ha caducado. Inicia sesión nuevamente';
    if (code == 403) return 'Tu cuenta no tiene acceso a esta información.';
    if (code == 404) {
      return 'Esta información no está disponible para tu cuenta.';
    }
    if (code == 429) {
      return 'Hay demasiados intentos. Espera un momento antes de volver a intentar.';
    }
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return 'No pudimos conectar. Revisa tu conexión e inténtalo de nuevo.';
    }
  }
  return 'No pudimos completar la solicitud. Inténtalo de nuevo.';
}
