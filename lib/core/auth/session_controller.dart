import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/api_failure.dart';
import 'auth_models.dart';
import 'session_service.dart';
import 'token_store.dart';

part 'session_controller.g.dart';

@Riverpod(keepAlive: true)
TokenStore tokenStore(Ref ref) => SecureTokenStore();

@Riverpod(keepAlive: true)
SessionService sessionService(Ref ref) {
  final service = SessionService(store: ref.watch(tokenStoreProvider));
  ref.onDispose(service.dispose);
  return service;
}

/// Si la cuenta en sesión puede crear, editar y borrar datos de Capital Humano.
/// Las pantallas lo usan para no mostrar botones que la API rechazaría.
@Riverpod(keepAlive: true)
bool canManageHr(Ref ref) =>
    ref.watch(sessionControllerProvider).user?.canManageHr ?? false;

@Riverpod(keepAlive: true)
class SessionController extends _$SessionController {
  int _operation = 0;

  @override
  SessionState build() {
    final service = ref.watch(sessionServiceProvider);
    service.onExpired = () {
      if (ref.mounted) {
        ++_operation;
        state = const SessionState(status: SessionStatus.signedOut);
      }
    };
    unawaited(Future.microtask(restore));
    return const SessionState();
  }

  Future<void> restore() async {
    final operation = ++_operation;
    state = const SessionState();
    try {
      final user = await ref.read(sessionServiceProvider).restore();
      if (!ref.mounted || operation != _operation) return;
      state = SessionState(
        status: user == null ? SessionStatus.signedOut : SessionStatus.signedIn,
        user: user,
      );
    } on Object catch (error) {
      if (!ref.mounted || operation != _operation) return;
      state = SessionState(
        status: SessionStatus.unavailable,
        message: apiErrorMessage(error),
      );
    }
  }

  Future<void> login(String username, String password) async {
    if (state.isSubmitting) return;
    final operation = ++_operation;
    state = const SessionState(
      status: SessionStatus.signedOut,
      isSubmitting: true,
    );
    try {
      final user = await ref
          .read(sessionServiceProvider)
          .login(username.trim(), password);
      if (!ref.mounted || operation != _operation) return;
      state = SessionState(status: SessionStatus.signedIn, user: user);
    } on Object catch (error) {
      if (!ref.mounted || operation != _operation) return;
      state = SessionState(
        status: SessionStatus.signedOut,
        message: apiErrorMessage(error, login: true),
      );
    }
  }

  Future<void> logout() async {
    try {
      await ref.read(sessionServiceProvider).logout();
    } on Object {
      if (ref.mounted) {
        state = const SessionState(
          status: SessionStatus.signedOut,
          message: 'No se pudo borrar la sesión guardada. Cierra esta ventana y elimina los datos del sitio antes de salir de un equipo compartido.',
        );
      }
    }
  }
}
