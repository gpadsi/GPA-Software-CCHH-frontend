// Comportamiento a nivel de pantalla del bloque de fundamentos de diseño
// (2026-10-02): filas clicables, edición desde la lista, formularios en panel
// y borrados que ya no fallan en silencio.
import 'package:capital_humano_front/core/widgets/confirm_dialog.dart';
import 'package:capital_humano_front/core/widgets/form_panel.dart';
import 'package:capital_humano_front/features/persons/presentation/person_form.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'phase_three_fixtures.dart';
import 'phase_three_widget_test.dart' show pumpPhaseThree;

DioException _http(int code) => DioException(
  requestOptions: RequestOptions(path: '/x'),
  response: Response(
    requestOptions: RequestOptions(path: '/x'),
    statusCode: code,
  ),
  type: DioExceptionType.badResponse,
);

void main() {
  testWidgets('personas: clic en la fila abre el expediente', (tester) async {
    final router = await pumpPhaseThree(tester, path: '/personas');
    await tester.tap(find.text('Pérez López Juan'));
    await tester.pumpAndSettle();
    expect(router.routeInformationProvider.value.uri.path, '/personas/p1');
  });

  testWidgets(
    'personas: editar desde la lista abre el panel con los datos y guarda',
    (tester) async {
      final repository = FakePersonsRepository();
      await pumpPhaseThree(tester, path: '/personas', persons: repository);

      await tester.tap(find.byTooltip('Editar a Pérez López Juan'));
      await tester.pumpAndSettle();

      // El formulario vive en un panel, no en un diálogo centrado.
      expect(find.byType(AppFormPanel), findsOneWidget);
      expect(find.byType(PersonForm), findsOneWidget);
      expect(find.text('Editar persona'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Juan'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Juan'),
        'Juanito',
      );
      await tester.ensureVisible(find.text('Guardar'));
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      expect(repository.created, false); // edición, no alta
      expect(repository.saved?.id, 'p1');
      expect(repository.saved?.firstName, 'Juanito');
      expect(find.byType(AppFormPanel), findsNothing);
      expect(find.text('Persona guardada.'), findsOneWidget);
    },
  );

  testWidgets('personas: agregar sigue abriendo el panel vacío', (
    tester,
  ) async {
    await pumpPhaseThree(tester, path: '/personas');
    await tester.tap(find.text('Agregar persona'));
    await tester.pumpAndSettle();
    expect(find.byType(AppFormPanel), findsOneWidget);
    expect(find.text('Agregar persona'), findsWidgets);
    expect(find.widgetWithText(TextFormField, 'Juan'), findsNothing);
  });

  testWidgets('personas: borrar pide confirmación y elimina', (tester) async {
    final repository = FakePersonsRepository();
    await pumpPhaseThree(tester, path: '/personas', persons: repository);

    await tester.tap(find.byTooltip('Eliminar a Pérez López Juan'));
    await tester.pumpAndSettle();
    expect(find.text('Eliminar persona'), findsOneWidget);
    expect(find.text(deleteLinkedRecordsHint), findsOneWidget);

    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();
    expect(repository.deleted, 'p1');
    expect(find.text('Eliminar persona'), findsNothing);
    expect(find.text('Pérez López Juan'), findsNothing);
  });

  // Antes: el diálogo de borrado de Personas se cerraba en silencio si la API
  // fallaba, sin decir nada. Ahora se queda abierto y explica el motivo.
  testWidgets('personas: un borrado que falla NO se cierra en silencio', (
    tester,
  ) async {
    final repository = FakePersonsRepository();
    await pumpPhaseThree(tester, path: '/personas', persons: repository);
    repository.failure = _http(403); // falla solo a partir de aquí

    await tester.tap(find.byTooltip('Eliminar a Pérez López Juan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eliminar'));
    await tester.pumpAndSettle();

    expect(find.text('Eliminar persona'), findsOneWidget);
    expect(
      find.text('Tu cuenta no tiene permiso para eliminar este registro.'),
      findsOneWidget,
    );
    expect(repository.deleted, isNull);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Eliminar persona'), findsNothing);
    expect(find.text('Pérez López Juan'), findsOneWidget); // sigue en la lista
  });

  testWidgets(
    'detalle de persona: borrar un contacto ya no deja un error sin atender',
    (tester) async {
      final repository = FakePersonsRepository();
      await pumpPhaseThree(tester, path: '/personas/p1', persons: repository);
      await tester.tap(find.text('Contacto de urgencia'));
      await tester.pumpAndSettle();
      repository.failure = _http(500);

      await tester.tap(find.byTooltip('Eliminar a Mamá').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull); // antes: excepción sin atender
      expect(find.textContaining('registros vinculados'), findsOneWidget);
    },
  );
}
