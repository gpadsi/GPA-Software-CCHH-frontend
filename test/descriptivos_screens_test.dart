// Pantallas de Descriptivos de puesto (paso 3 del plan del front, 2026-10-05):
// lista, alta de borrador, editor, congelar, copiar, descarga del Word oficial
// y conformidades.
import 'package:capital_humano_front/core/widgets/app_button.dart';
import 'package:capital_humano_front/core/widgets/form_panel.dart';
import 'package:capital_humano_front/features/recruitment/presentation/recruitment_ui.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'phase_three_fixtures.dart';
import 'recruitment_fixtures.dart';
import 'recruitment_harness.dart';
import 'test_session.dart';

DioException _http(int code, [Object? data]) => DioException(
  requestOptions: RequestOptions(path: '/x'),
  response: Response(
    requestOptions: RequestOptions(path: '/x'),
    statusCode: code,
    data: data,
  ),
  type: DioExceptionType.badResponse,
);

Finder _field(String text) => find.widgetWithText(TextFormField, text);

VoidCallback? _onPressed(WidgetTester tester, String label) =>
    tester.widget<AppButton>(find.widgetWithText(AppButton, label)).onPressed;

Future<void> _edit(WidgetTester tester, Finder field, String text) async {
  await tester.ensureVisible(field);
  await tester.enterText(field, text);
  await tester.pump();
}

Future<void> _tapText(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text));
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

void main() {
  group('lista de descriptivos', () {
    testWidgets(
      'muestra cada versión con su estado y manda el orden por defecto',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        await pumpRecruitment(
          tester,
          path: '/reclutamiento/descriptivos',
          repository: repository,
        );
        expect(find.text('Descriptivos de puesto'), findsWidgets);
        expect(find.text('Operador de Soldadura'), findsWidgets);
        expect(find.text('v1'), findsOneWidget);
        expect(find.text('Borrador'), findsOneWidget);
        expect(find.text('v2'), findsOneWidget);
        expect(find.text('Congelado'), findsWidgets);
        // Lo más reciente primero.
        expect(
          repository.lastDescriptivosQuery.ordering,
          '-fecha_elaboracion,-version',
        );
      },
    );

    testWidgets('solo un borrador se puede eliminar desde la lista', (
      tester,
    ) async {
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos',
        repository: FakeRecruitmentRepository(),
      );
      expect(
        find.byTooltip(
          'Eliminar descriptivo v1 de Operador de Soldadura — PAILERIA',
        ),
        findsOneWidget,
      );
      expect(
        find.byTooltip(
          'Eliminar descriptivo v2 de Ingeniero de Servicio — SERVICIO TECNICO',
        ),
        findsNothing,
      );
    });

    testWidgets('los filtros de borradores y congelados se piden al servidor', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos',
        repository: repository,
      );
      await tester.tap(find.text('Borradores'));
      await tester.pumpAndSettle();
      expect(repository.lastDescriptivosQuery.filters['congelado'], 'false');
      await tester.tap(find.text('Congelados'));
      await tester.pumpAndSettle();
      expect(repository.lastDescriptivosQuery.filters['congelado'], 'true');
      await tester.tap(find.text('Todos'));
      await tester.pumpAndSettle();
      expect(repository.lastDescriptivosQuery.filters, isEmpty);
    });

    testWidgets('buscar y ordenar por encabezado le piden al servidor', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos',
        repository: repository,
      );
      await tester.enterText(find.byType(TextField).first, 'soldad');
      await pumpDebounce(tester);
      expect(repository.lastDescriptivosQuery.search, 'soldad');
      await tester.tap(find.text('Versión'));
      await tester.pumpAndSettle();
      expect(repository.lastDescriptivosQuery.ordering, 'version');
    });

    testWidgets('un Colaborador consulta pero no puede crear ni eliminar', (
      tester,
    ) async {
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos',
        repository: FakeRecruitmentRepository(),
        user: testColaborador,
      );
      expect(find.text('Nuevo descriptivo'), findsNothing);
      expect(find.textContaining('Eliminar descriptivo'), findsNothing);
      expect(find.byTooltip(RegExp('^Ver descriptivo')), findsWidgets);
    });

    testWidgets('con un filtro sin resultados dice que no hay coincidencias', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos',
        repository: repository,
      );
      repository.descriptivosData = [];
      await tester.tap(find.text('Borradores'));
      await tester.pumpAndSettle();
      expect(
        find.text('Ningún descriptivo coincide con el filtro elegido.'),
        findsOneWidget,
      );
    });

    testWidgets('eliminar un borrador pide confirmación', (tester) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos',
        repository: repository,
      );
      await tapTooltip(
        tester,
        'Eliminar descriptivo v1 de Operador de Soldadura — PAILERIA',
      );
      expect(find.text('Eliminar borrador'), findsOneWidget);
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();
      expect(repository.calls, ['eliminar:d1']);
      expect(find.text('Borrador eliminado.'), findsOneWidget);
    });
  });

  group('nuevo descriptivo', () {
    Future<void> openPanel(WidgetTester tester) async {
      await tester.tap(find.text('Nuevo descriptivo').first);
      await tester.pumpAndSettle();
    }

    testWidgets('elige la posición, crea el borrador y abre el editor', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      final router = await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos',
        repository: repository,
      );
      await openPanel(tester);
      expect(find.byType(AppFormPanel), findsOneWidget);

      // Sin elegir la posición no hace nada.
      await saveForm(tester, label: 'Crear borrador');
      expect(find.text('Elige la posición de la lista.'), findsOneWidget);
      expect(repository.createdDraftFor, isNull);

      await tester.enterText(find.byType(TextFormField).first, 'ingen');
      await pumpDebounce(tester);
      await tester.tap(find.text(posicionDos.etiqueta).last);
      await tester.pumpAndSettle();
      await saveForm(tester, label: 'Crear borrador');

      expect(repository.createdDraftFor, 'pos2');
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/descriptivos/nuevo',
      );
      expect(find.text('Guardar borrador'), findsOneWidget); // ya es el editor
    });

    testWidgets('si la posición ya tiene un borrador abierto lo explica', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos',
        repository: repository,
      );
      await openPanel(tester);
      await tester.enterText(find.byType(TextFormField).first, 'ingen');
      await pumpDebounce(tester);
      await tester.tap(find.text(posicionDos.etiqueta).last);
      await tester.pumpAndSettle();
      repository.failure = _http(400, {
        'posicion': [
          'Esta Posición ya tiene un borrador de Descriptivo abierto.',
        ],
      });
      await saveForm(tester, label: 'Crear borrador');
      expect(
        find.text(
          'Posición: Esta Posición ya tiene un borrador de Descriptivo abierto.',
        ),
        findsOneWidget,
      );
      expect(find.byType(AppFormPanel), findsOneWidget);
    });
  });

  group('editor de un borrador', () {
    testWidgets('trae lo capturado y el guardado espera a que haya cambios', (
      tester,
    ) async {
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: FakeRecruitmentRepository(),
        height: 3200,
      );
      expect(find.text('Borrador'), findsOneWidget);
      expect(_field('Operador de Soldadura'), findsOneWidget);
      expect(_field('GPA Azimatronics'), findsOneWidget);
      expect(_field('Soldar piezas según el plano.'), findsOneWidget);
      expect(_field('Soldar piezas'), findsOneWidget);
      expect(_field('Piezas sin retrabajo'), findsOneWidget);
      // Sin cambios no hay nada que guardar.
      expect(_onPressed(tester, 'Guardar borrador'), isNull);
      expect(find.text('Tienes cambios sin guardar.'), findsNothing);
    });

    testWidgets('al editar avisa de lo no guardado y guarda texto y casillas', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: repository,
        height: 3200,
      );
      await _edit(
        tester,
        _field('Soldar piezas según el plano.'),
        'Soldar y ensamblar piezas.',
      );
      expect(find.text('Tienes cambios sin guardar.'), findsOneWidget);
      expect(_onPressed(tester, 'Guardar borrador'), isNotNull);

      await tester.ensureVisible(find.text('Trabajo en equipo'));
      await tester.tap(find.text('Trabajo en equipo'));
      await tester.pump();
      await tester.ensureVisible(find.text('Laptop'));
      await tester.tap(find.text('Laptop'));
      await tester.pump();

      await tester.ensureVisible(find.text('Guardar borrador'));
      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();

      final saved = repository.savedDescriptivo!;
      expect(saved.id, 'd1');
      expect(saved.proposito, 'Soldar y ensamblar piezas.');
      expect(saved.competencias, [70, 71]);
      expect(saved.recursos, [80]);
      expect(find.text('Borrador guardado.'), findsOneWidget);
      // Ya no hay nada pendiente y el editor sigue en pantalla con lo escrito.
      expect(find.text('Tienes cambios sin guardar.'), findsNothing);
      expect(_field('Soldar y ensamblar piezas.'), findsOneWidget);
      expect(_onPressed(tester, 'Guardar borrador'), isNull);
    });

    testWidgets(
      'funciones e indicadores: renglones del formulario, se agregan y se quitan',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        await pumpRecruitment(
          tester,
          path: '/reclutamiento/descriptivos/d1',
          repository: repository,
          height: 3600,
        );
        // 1 capturada + 4 vacías (el formulario oficial trae 5), y 3 indicadores.
        expect(find.text('Responsabilidad 5'), findsOneWidget);
        expect(find.text('Responsabilidad 6'), findsNothing);
        expect(find.text('Indicador 3'), findsOneWidget);

        await _tapText(tester, 'Agregar responsabilidad');
        expect(find.text('Responsabilidad 6'), findsOneWidget);
        expect(find.text('Tienes cambios sin guardar.'), findsOneWidget);

        await tester.ensureVisible(find.byTooltip('Quitar responsabilidad 2'));
        await tester.tap(find.byTooltip('Quitar responsabilidad 2'));
        await tester.pumpAndSettle();
        expect(find.text('Responsabilidad 6'), findsNothing);
        expect(find.text('Responsabilidad 5'), findsOneWidget);

        await _edit(
          tester,
          find.widgetWithText(TextFormField, 'Responsabilidad 2'),
          'Revisar planos',
        );
        await tester.ensureVisible(find.text('Guardar borrador'));
        await tester.tap(find.text('Guardar borrador'));
        await tester.pumpAndSettle();
        final saved = repository.savedDescriptivo!;
        expect(saved.funciones.first.texto, 'Soldar piezas');
        expect(saved.funciones[1].texto, 'Revisar planos');
        expect(saved.funciones.map((f) => f.orden), [1, 2, 3, 4, 5]);
      },
    );

    testWidgets('«Otro» pide su propio texto solo cuando se elige', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: repository,
        height: 3200,
      );
      expect(find.text('Edad (otro)'), findsNothing);
      await choose(tester, field: 'Edad', option: 'Otro');
      expect(find.text('Edad (otro)'), findsOneWidget);
      await _edit(tester, _field('Edad (otro)'), '56 a 60');
      await choose(
        tester,
        field: 'Días por laborar',
        option: 'Lunes a Viernes',
      );
      expect(find.text('Días por laborar (otro)'), findsNothing);

      await tester.ensureVisible(find.text('Guardar borrador'));
      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();
      final saved = repository.savedDescriptivo!;
      expect(saved.edad, edadOtro.id);
      expect(saved.edadOtro, '56 a 60');
      expect(saved.diasPorLaborar, diasLv.id);
    });

    testWidgets('elegir otra opción descarta el texto de «Otro»', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: repository,
        height: 3200,
      );
      await choose(tester, field: 'Edad', option: 'Otro');
      await _edit(tester, _field('Edad (otro)'), '56 a 60');
      await choose(tester, field: 'Edad', option: '18 - 25');
      await tester.ensureVisible(find.text('Guardar borrador'));
      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();
      expect(repository.savedDescriptivo?.edad, edad1825.id);
      expect(repository.savedDescriptivo?.edadOtro, isEmpty);
    });

    testWidgets('un texto demasiado largo se marca y no se manda', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: repository,
        height: 3200,
      );
      await _edit(tester, _field('Operador de Soldadura'), 'x' * 151);
      await tester.ensureVisible(find.text('Guardar borrador'));
      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();
      expect(find.text('Usa como máximo 150 caracteres.'), findsOneWidget);
      expect(find.text('Revisa los campos marcados en rojo.'), findsOneWidget);
      expect(repository.savedDescriptivo, isNull);
    });

    testWidgets('si el servidor rechaza el guardado, el motivo se ve arriba', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: repository,
        height: 3200,
      );
      await _edit(tester, _field('Operador de Soldadura'), 'Operador B');
      repository.failure = _http(400, {
        'non_field_errors': [
          'Esta versión del Descriptivo ya está congelada y no se puede modificar.',
        ],
      });
      await tester.ensureVisible(find.text('Guardar borrador'));
      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Esta versión del Descriptivo ya está congelada y no se puede modificar.',
        ),
        findsOneWidget,
      );
      // Sigue marcado como pendiente: no se perdió lo escrito.
      expect(find.text('Tienes cambios sin guardar.'), findsOneWidget);
      expect(_field('Operador B'), findsOneWidget);
    });

    testWidgets(
      'congelar guarda lo que se ve y luego congela, tras confirmar',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        await pumpRecruitment(
          tester,
          path: '/reclutamiento/descriptivos/d1',
          repository: repository,
          height: 3200,
        );
        await _edit(tester, _field('Operador de Soldadura'), 'Operador B');
        await _tapText(tester, 'Congelar versión');
        expect(find.text('Congelar versión 1'), findsOneWidget);
        // Todavía no se tocó nada del servidor.
        expect(repository.calls, isEmpty);

        await tester.tap(find.text('Congelar'));
        await tester.pumpAndSettle();
        expect(repository.calls, ['guardar:d1', 'congelar:d1']);
        expect(repository.savedDescriptivo?.nombrePuesto, 'Operador B');
        // El editor se rearma ya sin edición.
        expect(find.text('Guardar borrador'), findsNothing);
        expect(find.text('Congelar versión'), findsNothing);
        expect(find.text('Copiar a un borrador nuevo'), findsOneWidget);
      },
    );

    testWidgets('cancelar la confirmación no congela nada', (tester) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: repository,
        height: 3200,
      );
      await _tapText(tester, 'Congelar versión');
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(repository.calls, isEmpty);
      expect(find.text('Guardar borrador'), findsOneWidget);
    });

    testWidgets('si congelar falla, el diálogo se queda y dice por qué', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: repository,
        height: 3200,
      );
      await _tapText(tester, 'Congelar versión');
      repository.failure = _http(400, {
        'non_field_errors': [
          'Esta versión del Descriptivo ya estaba congelada.',
        ],
      });
      await tester.tap(find.text('Congelar'));
      await tester.pumpAndSettle();
      expect(find.text('Congelar versión 1'), findsOneWidget);
      expect(
        find.text('Esta versión del Descriptivo ya estaba congelada.'),
        findsOneWidget,
      );
    });

    testWidgets(
      'descargar el Word guarda antes los cambios y entrega el archivo',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        final saver = FakeFileSaver();
        await pumpRecruitment(
          tester,
          path: '/reclutamiento/descriptivos/d1',
          repository: repository,
          saver: saver,
          height: 3200,
        );
        await _edit(tester, _field('Operador de Soldadura'), 'Operador B');
        await _tapText(tester, 'Descargar Word oficial');
        // Lo que se exporta es lo guardado: primero se guardó.
        expect(repository.calls, ['guardar:d1', 'word:d1']);
        expect(saver.saved.single.name, 'FO-C0-CH-04 Descriptivo.docx');
        expect(find.text('Tienes cambios sin guardar.'), findsNothing);
      },
    );

    testWidgets('si no se puede guardar, no se descarga una versión vieja', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      final saver = FakeFileSaver();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: repository,
        saver: saver,
        height: 3200,
      );
      await _edit(tester, _field('Operador de Soldadura'), 'x' * 151);
      await _tapText(tester, 'Descargar Word oficial');
      expect(saver.saved, isEmpty);
      expect(repository.calls, isEmpty);
    });

    testWidgets('eliminar el borrador pide confirmación y vuelve a la lista', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      final router = await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: repository,
        height: 3200,
      );
      await _tapText(tester, 'Eliminar borrador');
      expect(find.text('Eliminar borrador'), findsWidgets);
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();
      expect(repository.calls, ['eliminar:d1']);
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/descriptivos',
      );
    });
  });

  group('una versión congelada', () {
    testWidgets('no se edita: sin guardar, congelar ni eliminar', (
      tester,
    ) async {
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d2',
        repository: FakeRecruitmentRepository(),
        height: 3200,
      );
      expect(find.textContaining('Congelado el'), findsOneWidget);
      expect(find.text('Guardar borrador'), findsNothing);
      expect(find.text('Congelar versión'), findsNothing);
      expect(find.text('Eliminar borrador'), findsNothing);
      expect(find.text('Descargar Word oficial'), findsOneWidget);
      expect(find.text('Copiar a un borrador nuevo'), findsOneWidget);
      // Los campos se ven pero son de solo lectura.
      final field = tester.widget<TextField>(
        find.descendant(
          of: _field('Dar servicio técnico.'),
          matching: find.byType(TextField),
        ),
      );
      expect(field.readOnly, isTrue);
      // Y no hay botones para agregar ni quitar renglones.
      expect(find.text('Agregar responsabilidad'), findsNothing);
      expect(find.byTooltip('Quitar responsabilidad 1'), findsNothing);
    });

    testWidgets('copiar abre un borrador nuevo a partir de ella', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      final router = await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d2',
        repository: repository,
        height: 3200,
      );
      await _tapText(tester, 'Copiar a un borrador nuevo');
      expect(repository.calls, ['copiar:d2']);
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/descriptivos/copia',
      );
      expect(find.text('Guardar borrador'), findsOneWidget);
    });

    testWidgets('si ya hay un borrador abierto, copiar lo explica', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d2',
        repository: repository,
        height: 3200,
      );
      repository.failure = _http(400, {
        'posicion': ['Esta Posición ya tiene un borrador abierto.'],
      });
      await _tapText(tester, 'Copiar a un borrador nuevo');
      expect(
        find.text('Posición: Esta Posición ya tiene un borrador abierto.'),
        findsOneWidget,
      );
    });

    testWidgets('las conformidades muestran quién firmó y lo que falta', (
      tester,
    ) async {
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d2',
        repository: FakeRecruitmentRepository(),
        height: 3200,
      );
      expect(find.text('Conformidades'), findsOneWidget);
      expect(
        find.text('Conforme el ${shownDate('2026-09-26')}'),
        findsOneWidget,
      );
      expect(find.text('Ana Ruiz'), findsOneWidget);
      // Colaborador y Capital Humano todavía no firman.
      expect(find.text('Pendiente'), findsNWidgets(2));
    });

    testWidgets(
      'registrar la conformidad de Capital Humano a nombre de quien la registra',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        await pumpRecruitment(
          tester,
          path: '/reclutamiento/descriptivos/d2',
          repository: repository,
          height: 3200,
        );
        // Jefe inmediato ya firmó (rol de una sola firma): solo quedan dos botones.
        expect(find.text('Registrar conformidad'), findsNWidgets(2));
        await tester.ensureVisible(find.text('Registrar conformidad').last);
        await tester.tap(find.text('Registrar conformidad').last);
        await tester.pumpAndSettle();
        expect(find.text('Conformidad: Capital Humano'), findsOneWidget);

        // Por defecto se escribe quién la dio.
        await saveForm(tester);
        expect(find.text('Escribe quién la dio.'), findsOneWidget);
        await tester.tap(find.byType(SwitchListTile));
        await tester.pumpAndSettle();
        await saveForm(tester);

        final saved = repository.savedConformidad!;
        expect(repository.conformidadCreated, isTrue);
        expect(saved.descriptivo, 'd2');
        expect(saved.rol, rolCh.id);
        expect(saved.usuario, testUser.id);
        expect(saved.persona, isNull);
      },
    );

    testWidgets(
      'el Colaborador firma a nombre de una persona elegida de la lista',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        final employment = FakeEmploymentRepository();
        await pumpRecruitment(
          tester,
          path: '/reclutamiento/descriptivos/d2',
          repository: repository,
          employment: employment,
          height: 3200,
        );
        await tester.ensureVisible(find.text('Registrar conformidad').first);
        await tester.tap(find.text('Registrar conformidad').first);
        await tester.pumpAndSettle();
        expect(find.text('Conformidad: Colaborador'), findsOneWidget);

        // Sin elegir a la persona no guarda.
        await saveForm(tester);
        expect(find.text('Elige a la persona de la lista.'), findsOneWidget);
        expect(repository.savedConformidad, isNull);

        await tester.enterText(
          find
              .descendant(
                of: find.byType(AppFormPanel),
                matching: find.byType(TextFormField),
              )
              .first,
          'ana',
        );
        await pumpDebounce(tester);
        await tester.tap(find.text('Ruiz Ana'));
        await tester.pumpAndSettle();
        await saveForm(tester);

        expect(employment.searches, ['ana']);
        expect(repository.savedConformidad?.rol, rolColaborador.id);
        expect(repository.savedConformidad?.persona, 'p2');
      },
    );

    testWidgets('quitar una conformidad pide confirmación', (tester) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d2',
        repository: repository,
        height: 3200,
      );
      await tapTooltip(tester, 'Eliminar conformidad de Jefe inmediato');
      expect(find.text('Quitar conformidad'), findsOneWidget);
      await tester.tap(find.text('Quitar'));
      await tester.pumpAndSettle();
      expect(repository.deletedConformidad, 'c1');
    });
  });

  group('un Colaborador ante un descriptivo', () {
    testWidgets('lo consulta y lo descarga, pero no lo edita', (tester) async {
      final repository = FakeRecruitmentRepository();
      final saver = FakeFileSaver();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: repository,
        saver: saver,
        user: testColaborador,
        height: 3200,
      );
      expect(find.text('Guardar borrador'), findsNothing);
      expect(find.text('Congelar versión'), findsNothing);
      expect(find.text('Eliminar borrador'), findsNothing);
      expect(find.text('Agregar responsabilidad'), findsNothing);
      expect(
        find.textContaining('Solo Capital Humano edita los descriptivos'),
        findsOneWidget,
      );
      // Sin renglones vacíos de relleno: solo lo que hay capturado.
      expect(find.text('Responsabilidad 2'), findsNothing);
      expect(find.text('Responsabilidad 1'), findsOneWidget);

      await tester.tap(find.text('Descargar Word oficial'));
      await tester.pumpAndSettle();
      expect(saver.saved, hasLength(1));
      // Descargar no guarda nada: no puede editar.
      expect(repository.calls, ['word:d1']);
    });

    testWidgets('en una versión congelada no ve las conformidades', (
      tester,
    ) async {
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d2',
        repository: FakeRecruitmentRepository(),
        user: testColaborador,
        height: 3200,
      );
      expect(find.text('Conformidades'), findsNothing);
      expect(find.text('Copiar a un borrador nuevo'), findsNothing);
      expect(find.text('Descargar Word oficial'), findsOneWidget);
    });
  });

  testWidgets('si el descriptivo ya no existe ofrece reintentar', (
    tester,
  ) async {
    final repository = FakeRecruitmentRepository()..descriptivosData = [];
    await pumpRecruitment(
      tester,
      path: '/reclutamiento/descriptivos/nada',
      repository: repository,
    );
    expect(find.text('No pudimos cargar la información'), findsOneWidget);
    expect(find.text('Reintentar'), findsOneWidget);
  });
}
