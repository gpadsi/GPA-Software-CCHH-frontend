// Pantallas de Requisiciones (paso 3 del plan del front, 2026-10-05): lista,
// alta y edición, detalle con aprobaciones y descarga del Excel oficial.
import 'package:capital_humano_front/core/widgets/form_panel.dart';
import 'package:capital_humano_front/core/widgets/search_picker_field.dart';
import 'package:capital_humano_front/features/recruitment/presentation/recruitment_ui.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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

/// El campo «Estado» del formulario (y no el encabezado de la tabla ni el
/// filtro de la página, que están detrás del panel y se llaman igual).
Future<void> openEstadoDelPanel(WidgetTester tester) async {
  final field = find.descendant(
    of: find.byType(AppFormPanel),
    matching: find.text('Estado'),
  );
  await tester.ensureVisible(field.first);
  await tester.tap(field.first);
  await tester.pumpAndSettle();
}

void main() {
  group('lista de requisiciones', () {
    testWidgets(
      'Capital Humano ve la posición, el tipo, el estado y quién la pidió',
      (tester) async {
        await pumpRecruitment(
          tester,
          path: '/reclutamiento',
          repository: FakeRecruitmentRepository(),
        );
        expect(find.text('Reclutamiento'), findsWidgets);
        expect(find.text(posicionUno.etiqueta), findsOneWidget);
        // El tipo y el área van bajo la posición.
        expect(find.text('Reemplazo · Soldadura'), findsOneWidget);
        expect(find.text('Pendiente de Autorización'), findsWidgets);
        expect(find.text('Cuenta de prueba'), findsOneWidget);
        // Las importadas no tienen solicitante: se dice, no se deja en blanco.
        expect(find.text('Importada de GPA'), findsOneWidget);
        expect(find.text('Solicitante'), findsOneWidget); // encabezado
      },
    );

    testWidgets(
      'un Colaborador no ve la columna de solicitante ni puede borrar',
      (tester) async {
        final repository = FakeRecruitmentRepository()
          ..requisicionesData = [
            requisicionPropia.copyWith(creadoPor: testColaborador.id),
            requisicionAjena,
          ];
        await pumpRecruitment(
          tester,
          path: '/reclutamiento',
          repository: repository,
          user: testColaborador,
        );
        expect(find.text('Solicitante'), findsNothing);
        expect(find.textContaining('Eliminar requisición'), findsNothing);
        // Solo puede editar la que él levantó.
        expect(
          find.byTooltip('Editar requisición de ${posicionUno.etiqueta}'),
          findsOneWidget,
        );
        expect(
          find.byTooltip('Editar requisición de ${posicionDos.etiqueta}'),
          findsNothing,
        );
        // Pero sí puede abrir cualquiera de las que ve.
        expect(
          find.byTooltip('Ver requisición de ${posicionDos.etiqueta}'),
          findsOneWidget,
        );
      },
    );

    testWidgets('sin requisiciones, un Colaborador sabe qué hacer', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()..requisicionesData = [];
      await pumpRecruitment(
        tester,
        path: '/reclutamiento',
        repository: repository,
        user: testColaborador,
      );
      expect(find.text('Todavía no hay requisiciones'), findsOneWidget);
      expect(find.textContaining('Usa «Nueva requisición»'), findsOneWidget);
    });

    testWidgets('buscar, filtrar por estado y ordenar le piden al servidor', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento',
        repository: repository,
      );

      await tester.enterText(find.byType(TextField).first, 'sold');
      await pumpDebounce(tester);
      expect(repository.lastRequisicionesQuery.search, 'sold');

      await tester.tap(find.byKey(const ValueKey('Estado:null')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Autorizada').last);
      await tester.pumpAndSettle();
      expect(repository.lastRequisicionesQuery.filters['estado'], '3');
      expect(repository.lastRequisicionesQuery.search, 'sold');

      await tester.tap(find.text('Fecha de solicitud'));
      await tester.pumpAndSettle();
      expect(repository.lastRequisicionesQuery.ordering, 'fecha_solicitud');
    });

    testWidgets('con un filtro sin resultados lo dice de otra forma', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento',
        repository: repository,
      );
      repository.requisicionesData = [];
      await tester.tap(find.byKey(const ValueKey('Tipo:null')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nueva Posición').last);
      await tester.pumpAndSettle();
      expect(
        find.text('Ninguna requisición coincide con los filtros elegidos.'),
        findsOneWidget,
      );
    });

    testWidgets('eliminar pide confirmación y borra; si falla, dice por qué', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento',
        repository: repository,
      );
      repository.failure = _http(403, {'detail': 'x'});
      await tapTooltip(
        tester,
        'Eliminar requisición de ${posicionUno.etiqueta}',
      );
      expect(find.text('Eliminar requisición'), findsOneWidget);
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();
      expect(
        find.text('Tu cuenta no tiene permiso para hacer esto.'),
        findsOneWidget,
      );
      expect(repository.deletedRequisicion, isNull);

      repository.failure = null;
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();
      expect(repository.deletedRequisicion, 'r1');
      expect(find.text('Requisición eliminada.'), findsOneWidget);
    });
  });

  group('alta y edición de una requisición', () {
    Future<void> pickPosicion(WidgetTester tester) async {
      await tester.enterText(find.byType(TextFormField).first, 'ingen');
      await pumpDebounce(tester);
      await tester.tap(find.text(posicionDos.etiqueta).last);
      await tester.pumpAndSettle();
    }

    testWidgets(
      'una Nueva Posición exige justificación y arranca en Borrador',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        final router = await pumpRecruitment(
          tester,
          path: '/reclutamiento',
          repository: repository,
        );

        await tester.tap(find.text('Nueva requisición').first);
        await tester.pumpAndSettle();
        expect(find.byType(AppFormPanel), findsOneWidget);

        await pickPosicion(tester);
        expect(repository.searches, ['ingen']);
        await choose(
          tester,
          field: 'Tipo de requisición',
          option: 'Nueva Posición',
        );

        // Sin justificación no guarda, y lo dice el propio formulario.
        await saveForm(tester);
        expect(
          find.text('Este tipo de requisición exige justificación.'),
          findsOneWidget,
        );
        expect(repository.savedRequisicion, isNull);

        await tester.enterText(
          find.widgetWithText(
            TextFormField,
            'Justificación de la requisición (obligatoria para este tipo)',
          ),
          'Se abre una línea nueva',
        );
        await saveForm(tester);

        final saved = repository.savedRequisicion!;
        expect(repository.requisicionCreated, isTrue);
        expect(saved.posicion, 'pos2');
        expect(saved.tipo, tipoNueva.id);
        expect(saved.estado, estadoBorrador.id);
        expect(saved.justificacion, 'Se abre una línea nueva');
        expect(saved.fechaSolicitud, toIsoDate(DateTime.now()));
        // Se abre el detalle de lo recién creado.
        expect(
          router.routeInformationProvider.value.uri.path,
          '/reclutamiento/requisiciones/nueva',
        );
      },
    );

    testWidgets('el tipo Reemplazo no pide justificación', (tester) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento',
        repository: repository,
      );
      await tester.tap(find.text('Nueva requisición').first);
      await tester.pumpAndSettle();
      await pickPosicion(tester);
      await choose(tester, field: 'Tipo de requisición', option: 'Reemplazo');
      expect(
        find.text('Justificación de la requisición (opcional)'),
        findsOneWidget,
      );
      await saveForm(tester);
      expect(repository.savedRequisicion?.tipo, tipoReemplazo.id);
    });

    testWidgets('sin elegir la posición de la lista no guarda', (tester) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento',
        repository: repository,
      );
      await tester.tap(find.text('Nueva requisición').first);
      await tester.pumpAndSettle();
      await choose(tester, field: 'Tipo de requisición', option: 'Reemplazo');
      await saveForm(tester);
      expect(find.text('Elige la posición de la lista.'), findsOneWidget);
      expect(repository.savedRequisicion, isNull);
    });

    testWidgets('quien solicita solo puede elegir Borrador o Pendiente', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento',
        repository: repository,
        user: testColaborador,
      );
      await tester.tap(find.text('Nueva requisición').first);
      await tester.pumpAndSettle();
      await openEstadoDelPanel(tester);
      // Solo las opciones del menú (la tabla de atrás también dice «Autorizada»).
      Finder option(String name) =>
          find.widgetWithText(DropdownMenuItem<int>, name);
      expect(option('Pendiente de Autorización'), findsWidgets);
      expect(option('Borrador'), findsWidgets);
      expect(option('Autorizada'), findsNothing);
      expect(option('Cubierta'), findsNothing);
      expect(find.textContaining('Capital Humano la autoriza'), findsOneWidget);
    });

    testWidgets(
      'Capital Humano ve todos los estados y la suspensión al editar',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        await pumpRecruitment(
          tester,
          path: '/reclutamiento',
          repository: repository,
        );
        await tapTooltip(
          tester,
          'Editar requisición de ${posicionUno.etiqueta}',
        );
        expect(find.text('Editar requisición'), findsOneWidget);
        expect(find.text('Suspensión (solo si aplica)'), findsOneWidget);
        await openEstadoDelPanel(tester);
        expect(
          find.widgetWithText(DropdownMenuItem<int>, 'Autorizada'),
          findsWidgets,
        );
        expect(
          find.widgetWithText(DropdownMenuItem<int>, 'Cubierta'),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'editar parte de lo capturado, no deja cambiar la posición y guarda',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        await pumpRecruitment(
          tester,
          path: '/reclutamiento',
          repository: repository,
        );
        await tapTooltip(
          tester,
          'Editar requisición de ${posicionUno.etiqueta}',
        );
        // La posición se muestra, pero ya no hay buscador.
        expect(find.byType(SearchPickerField<dynamic>), findsNothing);
        expect(find.widgetWithText(TextFormField, 'Soldadura'), findsOneWidget);

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Soldadura'),
          'Maquinados',
        );
        await saveForm(tester);

        final saved = repository.savedRequisicion!;
        expect(repository.requisicionCreated, isFalse);
        expect(saved.id, 'r1');
        expect(saved.areaSolicitante, 'Maquinados');
        expect(saved.sueldoMensualBruto, '12500.00');
        expect(find.text('Requisición guardada.'), findsOneWidget);
      },
    );

    testWidgets('un importe mal escrito se marca antes de mandarlo', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento',
        repository: repository,
      );
      await tapTooltip(tester, 'Editar requisición de ${posicionUno.etiqueta}');
      await tester.enterText(
        find.widgetWithText(TextFormField, '12500.00'),
        '12.345',
      );
      await saveForm(tester);
      expect(
        find.text('Escribe un importe válido, con hasta 2 decimales.'),
        findsOneWidget,
      );
      expect(repository.savedRequisicion, isNull);
    });

    testWidgets(
      'el servidor rechaza el estado: el motivo se ve y el panel sigue',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        await pumpRecruitment(
          tester,
          path: '/reclutamiento',
          repository: repository,
        );
        await tapTooltip(
          tester,
          'Editar requisición de ${posicionUno.etiqueta}',
        );
        repository.failure = _http(400, {
          'posicion': ['Esta Posición ya tiene una Requisición abierta.'],
        });
        await saveForm(tester);
        expect(
          find.text(
            'Posición: Esta Posición ya tiene una Requisición abierta.',
          ),
          findsOneWidget,
        );
        expect(find.byType(AppFormPanel), findsOneWidget);
      },
    );
  });

  group('detalle de una requisición', () {
    testWidgets(
      'muestra la solicitud, el perfil, la compensación y las firmas',
      (tester) async {
        await pumpRecruitment(
          tester,
          path: '/reclutamiento/requisiciones/r1',
          repository: FakeRecruitmentRepository(),
        );
        expect(find.text(posicionUno.etiqueta), findsWidgets);
        expect(find.text('Solicitud'), findsOneWidget);
        expect(find.text(shownDate('2026-09-10')!), findsOneWidget);
        expect(find.text('Soldadura'), findsOneWidget);
        expect(find.text('Cuenta de prueba'), findsOneWidget);
        expect(find.text('Inglés básico'), findsOneWidget);
        expect(find.text('Sí'), findsOneWidget); // disposición para viajar
        expect(find.text(shownMoney('12500.00')!), findsOneWidget);
        // Lo que no se capturó lo dice, no queda en blanco.
        expect(find.text('No capturado'), findsWidgets);
        // La suspensión y la justificación no aplican: no se muestran.
        expect(find.text('Suspensión'), findsNothing);
        expect(find.text('Justificación'), findsNothing);
        // Cuatro etapas: una aprobada por escrito, tres pendientes.
        expect(
          find.text('Aprobada el ${shownDate('2026-09-12')}'),
          findsOneWidget,
        );
        expect(find.text('por Luis Pérez'), findsOneWidget);
        expect(find.text('Pendiente'), findsNWidgets(3));
      },
    );

    testWidgets('una importada dice que nadie la levantó', (tester) async {
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/r2',
        repository: FakeRecruitmentRepository(),
      );
      expect(find.text('Importada de los datos de GPA'), findsOneWidget);
    });

    testWidgets(
      'Capital Humano registra una aprobación con el nombre de quien firmó',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        await pumpRecruitment(
          tester,
          path: '/reclutamiento/requisiciones/r1',
          repository: repository,
        );
        expect(find.text('Registrar aprobación'), findsNWidgets(3));
        await tester.ensureVisible(find.text('Registrar aprobación').first);
        await tester.tap(find.text('Registrar aprobación').first);
        await tester.pumpAndSettle();
        expect(find.text('Aprobación: Gerencia del Área'), findsOneWidget);

        // Por defecto se captura el nombre de quien firmó (lo normal es una
        // firma en papel); sin nombre no guarda.
        await saveForm(tester);
        expect(find.text('Escribe quién aprobó.'), findsOneWidget);
        expect(repository.savedAprobacion, isNull);

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre de quien aprobó'),
          'Ana Ruiz',
        );
        await saveForm(tester);

        final saved = repository.savedAprobacion!;
        expect(repository.aprobacionCreated, isTrue);
        expect(saved.requisicion, 'r1');
        expect(saved.etapa, etapaGerencia.id);
        expect(saved.nombreManual, 'Ana Ruiz');
        expect(saved.usuario, isNull);
        expect(saved.fecha, toIsoDate(DateTime.now()));
        expect(find.text('Aprobación guardada.'), findsOneWidget);
      },
    );

    testWidgets('con «la aprobé yo» queda a nombre de la cuenta', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/r1',
        repository: repository,
      );
      await tester.ensureVisible(find.text('Registrar aprobación').last);
      await tester.tap(find.text('Registrar aprobación').last);
      await tester.pumpAndSettle();
      expect(find.text('Aprobación: Capital Humano'), findsOneWidget);
      await tester.tap(find.byType(SwitchListTile)); // «la aprobé yo»
      await tester.pumpAndSettle();
      await saveForm(tester);
      expect(repository.savedAprobacion?.usuario, testUser.id);
      expect(repository.savedAprobacion?.nombreManual, isEmpty);
    });

    testWidgets('quitar una aprobación pide confirmación', (tester) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/r1',
        repository: repository,
      );
      await tester.ensureVisible(
        find.byTooltip('Eliminar aprobación de Jefe Inmediato'),
      );
      await tapTooltip(tester, 'Eliminar aprobación de Jefe Inmediato');
      expect(find.text('Quitar aprobación'), findsOneWidget);
      await tester.tap(find.text('Quitar'));
      await tester.pumpAndSettle();
      expect(repository.deletedAprobacion, 'a1');
    });

    testWidgets('un Colaborador ve las firmas pero no puede registrarlas', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..requisicionesData = [
          requisicionPropia.copyWith(creadoPor: testColaborador.id),
        ];
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/r1',
        repository: repository,
        user: testColaborador,
      );
      expect(
        find.text('Aprobada el ${shownDate('2026-09-12')}'),
        findsOneWidget,
      );
      expect(find.text('Registrar aprobación'), findsNothing);
      expect(
        find.byTooltip('Eliminar aprobación de Jefe Inmediato'),
        findsNothing,
      );
      // Es suya: puede editarla.
      expect(find.text('Editar'), findsOneWidget);
    });

    testWidgets('una requisición ajena no se puede editar desde el detalle', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..requisicionesData = [requisicionAjena];
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/r3',
        repository: repository,
        user: testColaborador,
      );
      expect(find.text('Editar'), findsNothing);
      expect(find.text('Descargar Excel oficial'), findsOneWidget);
    });

    testWidgets('descarga el Excel oficial con el nombre que da el servidor', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      final saver = FakeFileSaver();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/r1',
        repository: repository,
        saver: saver,
      );
      await tester.tap(find.text('Descargar Excel oficial'));
      await tester.pumpAndSettle();
      expect(repository.calls, ['excel:r1']);
      expect(saver.saved.single.name, 'FO-C0-CH-08 Reemplazo.xlsx');
      expect(saver.saved.single.bytes, [1, 2, 3]);
      expect(
        find.text('Se descargó «FO-C0-CH-08 Reemplazo.xlsx».'),
        findsOneWidget,
      );
    });

    testWidgets(
      'si la descarga falla lo dice y el botón vuelve a estar listo',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        final saver = FakeFileSaver()
          ..failure = UnsupportedError('La descarga no está disponible.');
        await pumpRecruitment(
          tester,
          path: '/reclutamiento/requisiciones/r1',
          repository: repository,
          saver: saver,
        );
        await tester.tap(find.text('Descargar Excel oficial'));
        await tester.pumpAndSettle();
        expect(
          find.text('No pudimos completar la solicitud. Inténtalo de nuevo.'),
          findsOneWidget,
        );
        saver.failure = null;
        await tester.pump(const Duration(seconds: 5)); // cierra el aviso
        await tester.tap(find.text('Descargar Excel oficial'));
        await tester.pumpAndSettle();
        expect(saver.saved, hasLength(1));
      },
    );

    testWidgets('si la requisición ya no existe ofrece reintentar', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()..requisicionesData = [];
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/nada',
        repository: repository,
      );
      expect(find.text('No pudimos cargar la información'), findsOneWidget);
      expect(find.text('Reintentar'), findsOneWidget);
    });
  });
}
