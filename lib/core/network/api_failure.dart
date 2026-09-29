import 'package:dio/dio.dart';

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
