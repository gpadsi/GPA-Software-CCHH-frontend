import 'package:capital_humano_front/core/auth/auth_models.dart';
import 'package:capital_humano_front/core/auth/session_controller.dart';

const testUser = SessionUser(
  id: '11111111-1111-4111-8111-111111111111',
  username: 'cuenta_prueba',
  email: 'prueba@example.test',
  firstName: 'Nombre de prueba especialmente largo',
  lastName: 'Apellidos de prueba especialmente largos',
  isActive: true,
  role: SessionRole(code: 'capital-humano', name: 'Capital Humano'),
  canManageHr: true,
);

/// Una cuenta de Colaborador: lee, pero la API no le deja escribir.
const testColaborador = SessionUser(
  id: '22222222-2222-4222-8222-222222222222',
  username: 'colaborador_prueba',
  email: 'colaborador@example.test',
  firstName: 'Colaboradora',
  lastName: 'De Prueba',
  isActive: true,
  role: SessionRole(code: 'colaborador', name: 'Colaborador'),
);

class TestSessionController extends SessionController {
  TestSessionController({this.signedIn = true, this.user = testUser});
  final bool signedIn;
  final SessionUser user;
  @override
  SessionState build() => signedIn
      ? SessionState(status: SessionStatus.signedIn, user: user)
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
