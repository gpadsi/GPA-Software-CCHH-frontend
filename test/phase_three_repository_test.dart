import 'package:capital_humano_front/features/employment/data/employment_repository.dart';
import 'package:capital_humano_front/features/persons/data/persons_repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'phase_three_fixtures.dart';
import 'session_service_test.dart' show client, response;

void main() {
  group('PersonsRepository', () {
    test('list pagina del lado del servidor', () async {
      final repository = PersonsRepository(
        client((request) {
          expect(request.path, 'persons/personas/');
          expect(request.queryParameters, {'page': 2, 'page_size': 25});
          return response({
            'count': 30,
            'results': [personaA.toJson()],
          });
        }),
      );
      final page = await repository.list(2);
      expect(page.count, 30);
    });

    test('save al crear envía todos los campos, sin id', () async {
      final repository = PersonsRepository(
        client((request) {
          expect(request.method, 'POST');
          expect(request.path, 'persons/personas/');
          final payload = request.data as Map<String, dynamic>;
          expect(payload.containsKey('id'), isFalse);
          expect(payload['first_name'], 'Juan');
          expect(payload['has_children'], false);
          return response(personaA.toJson());
        }),
      );
      await repository.save(personaA, creating: true);
    });

    test('save al editar hace PATCH a la persona específica', () async {
      final repository = PersonsRepository(
        client((request) {
          expect(request.method, 'PATCH');
          expect(request.path, 'persons/personas/p1/');
          return response(personaA.toJson());
        }),
      );
      await repository.save(personaA, creating: false);
    });

    test('contactosDe filtra por persona en el servidor', () async {
      final repository = PersonsRepository(
        client((request) {
          expect(request.path, 'persons/contactos-urgencia/');
          expect(request.queryParameters['persona'], 'p1');
          return response({
            'count': 1,
            'results': [contactoA.toJson()],
          });
        }),
      );
      final contactos = await repository.contactosDe('p1');
      expect(contactos.single.name, 'Mamá');
    });

    test('perfilDe regresa null cuando no hay resultados', () async {
      final repository = PersonsRepository(
        client((request) {
          expect(request.queryParameters['persona'], 'p1');
          return response({'count': 0, 'results': []});
        }),
      );
      expect(await repository.perfilDe('p1'), isNull);
    });
  });

  group('EmploymentRepository', () {
    test('contratoVigente regresa null cuando el backend responde null', () async {
      final repository = EmploymentRepository(
        client((request) {
          expect(request.path, 'employment/empleados/e1/contrato-vigente/');
          return response(null);
        }),
      );
      expect(await repository.contratoVigente('e1'), isNull);
    });

    test('contratoVigente decodifica el contrato cuando existe', () async {
      final repository = EmploymentRepository(
        client((request) => response(contratoA.toJson())),
      );
      final contrato = await repository.contratoVigente('e1');
      expect(contrato?.posicion, 'pos1');
    });

    test('persona/posicion/puesto/estatus piden el recurso correcto', () async {
      final calledPaths = <String>[];
      final repository = EmploymentRepository(
        client((request) {
          calledPaths.add(request.path);
          if (request.path.startsWith('persons/')) {
            return response(personSummaryA.toJson());
          }
          if (request.path == 'positions/posiciones/pos1/') {
            return response(posicionSummaryA.toJson());
          }
          return response(puestoRefA.toJson());
        }),
      );
      await repository.persona('p1');
      await repository.posicion('pos1');
      await repository.puesto(10);
      await repository.estatus(20);
      expect(calledPaths, [
        'persons/personas/p1/',
        'positions/posiciones/pos1/',
        'positions/puestos/10/',
        'positions/estatus/20/',
      ]);
    });
  });
}
