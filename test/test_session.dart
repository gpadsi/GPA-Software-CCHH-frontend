import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/auth/session_controller.dart';

const testUser = SessionUser(
  id: '11111111-1111-4111-8111-111111111111',
  username: 'cuenta_prueba',
  email: 'prueba@example.test',
  firstName: 'Nombre de prueba especialmente largo',
  lastName: 'Apellidos de prueba especialmente largos',
  isActive: true,
);

class TestSessionController extends SessionController {
  TestSessionController({this.signedIn = true});
  final bool signedIn;
  @override
  SessionState build() => signedIn
      ? const SessionState(status: SessionStatus.signedIn, user: testUser)
      : const SessionState(status: SessionStatus.signedOut);

  @override
  Future<void> login(String username, String password) async {
    state = const SessionState(
      status: SessionStatus.signedOut,
      isSubmitting: true,
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));
    state = username == 'correcto' && password == 'clave-prueba'
        ? const SessionState(status: SessionStatus.signedIn, user: testUser)
        : const SessionState(
            status: SessionStatus.signedOut,
            message: 'El usuario o la contraseña no son correctos.',
          );
  }

  @override
  Future<void> logout() async =>
      state = const SessionState(status: SessionStatus.signedOut);
}
