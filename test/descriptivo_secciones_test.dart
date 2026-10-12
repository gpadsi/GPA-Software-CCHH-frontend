// R4: el descriptivo como página de trabajo: secciones navegables, guardar
// siempre a la vista, datos vinculados a la posición con su aviso de cambios,
// etiquetas de versión, funciones reordenables y protección de salida.
import 'package:capital_humano_front/core/widgets/app_button.dart';
import 'package:capital_humano_front/features/recruitment/data/recruitment_models.dart';
import 'package:capital_humano_front/features/recruitment/presentation/recruitment_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'recruitment_fixtures.dart';
import 'recruitment_harness.dart';
import 'test_session.dart';

const _sections = [
  'Identificación',
  'Propósito y funciones',
  'Perfil',
  'Competencias y recursos',
  'Indicadores y conformidades',
];

const _cambioJefe = CambioPosicion(
  campo: 'reporta_a',
  etiqueta: 'Reporta a',
  guardado: 'Supervisor de Soldadura',
  actual: 'Jefe de Línea',
);

Finder _field(String text) => find.widgetWithText(TextFormField, text);
Finder _chip(String name) => find.widgetWithText(ChoiceChip, name);

VoidCallback? _onPressed(WidgetTester tester, String label) =>
    tester.widget<AppButton>(find.widgetWithText(AppButton, label)).onPressed;

Future<void> _edit(WidgetTester tester, Finder field, String text) async {
  await tester.ensureVisible(field);
  await tester.enterText(field, text);
  // Al escribir, Flutter desplaza la vista para mostrar el cursor: se espera
  // a que termine antes de tocar otra cosa.
  await tester.pumpAndSettle();
}

/// Si el centro del widget cae dentro del área que se desplaza (las etiquetas
/// de los campos ignoran el puntero, así que `hitTestable` no sirve con ellas).
bool _inView(WidgetTester tester, Finder finder) => tester
    .getRect(find.byType(SingleChildScrollView).last)
    .contains(tester.getCenter(finder));

/// Va a una sección con su chip; en la pantalla de pruebas la fila de chips se
/// desplaza porque la fuente es muy ancha.
Future<void> _goTo(WidgetTester tester, String section) async {
  await tester.ensureVisible(_chip(section));
  await tester.pumpAndSettle();
  await tester.tap(_chip(section));
  await tester.pumpAndSettle();
}

Future<void> _tapTooltip(WidgetTester tester, String tooltip) async {
  await tester.ensureVisible(find.byTooltip(tooltip));
  await tester.pumpAndSettle();
  await tester.tap(find.byTooltip(tooltip));
  await tester.pumpAndSettle();
}

Future<void> _tapText(WidgetTester tester, String text) async {
  await tester.ensureVisible(find.text(text));
  await tester.tap(find.text(text));
  await tester.pumpAndSettle();
}

Future<GoRouter> _openDraft(
  WidgetTester tester,
  FakeRecruitmentRepository repository, {
  double height = 900,
}) => pumpRecruitment(
  tester,
  path: '/reclutamiento/descriptivos/d1',
  repository: repository,
  height: height,
);

void main() {
  group('secciones', () {
    testWidgets('las cinco secciones se pueden recorrer', (tester) async {
      await _openDraft(tester, FakeRecruitmentRepository());
      for (final name in _sections) {
        expect(_chip(name), findsOneWidget);
      }
      expect(tester.widget<ChoiceChip>(_chip(_sections[0])).selected, isTrue);

      await _goTo(tester, 'Indicadores y conformidades');
      expect(_inView(tester, find.text('Indicador 1')), isTrue);
      expect(
        tester
            .widget<ChoiceChip>(_chip('Indicadores y conformidades'))
            .selected,
        isTrue,
      );

      await _goTo(tester, 'Perfil');
      expect(_inView(tester, find.text('Escolaridad mínima')), isTrue);
    });

    testWidgets('navegar entre secciones no borra lo capturado', (
      tester,
    ) async {
      await _openDraft(tester, FakeRecruitmentRepository());
      await _edit(
        tester,
        _field('Soldar piezas según el plano.'),
        'Nuevo propósito',
      );
      await _goTo(tester, 'Indicadores y conformidades');
      await _goTo(tester, 'Competencias y recursos');
      await _goTo(tester, 'Identificación');

      expect(_field('Nuevo propósito'), findsOneWidget);
      expect(find.text('Tienes cambios sin guardar.'), findsOneWidget);
    });

    testWidgets('guardar y aprobar están a la vista en cualquier sección', (
      tester,
    ) async {
      await _openDraft(tester, FakeRecruitmentRepository(), height: 700);
      expect(find.text('Guardar borrador').hitTestable(), findsOneWidget);
      expect(find.text('Aprobar versión').hitTestable(), findsOneWidget);

      await _goTo(tester, 'Indicadores y conformidades');
      expect(find.text('Guardar borrador').hitTestable(), findsOneWidget);
      expect(find.text('Aprobar versión').hitTestable(), findsOneWidget);
    });

    testWidgets('un error de otra sección lleva hasta el campo marcado', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await _openDraft(tester, repository);
      await _edit(tester, _field('Otras competencias'), 'x' * 256);
      await _goTo(tester, 'Identificación');
      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();

      expect(find.text('Revisa los campos marcados en rojo.'), findsOneWidget);
      expect(
        find.text('Usa como máximo 255 caracteres.').hitTestable(),
        findsOneWidget,
      );
      expect(repository.savedDescriptivo, isNull);
    });

    testWidgets('si el servidor rechaza el guardado no se pierde nada', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await _openDraft(tester, repository);
      await _edit(tester, _field('Operador de Soldadura'), 'Operador B');
      await _goTo(tester, 'Perfil');
      await _edit(tester, _field('Escolaridad mínima'), 'Secundaria');
      repository.failure = Exception('sin red');
      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();

      repository.failure = null;
      await _goTo(tester, 'Identificación');
      expect(_field('Operador B'), findsOneWidget);
      await _goTo(tester, 'Perfil');
      expect(_field('Secundaria'), findsOneWidget);
      expect(find.text('Tienes cambios sin guardar.'), findsOneWidget);
    });
  });

  group('versión', () {
    testWidgets('un borrador se llama Borrador', (tester) async {
      await _openDraft(tester, FakeRecruitmentRepository());
      expect(find.text('Borrador'), findsOneWidget);
    });

    testWidgets('la versión aprobada más reciente es Aprobada', (tester) async {
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d2',
        repository: FakeRecruitmentRepository(),
      );
      expect(
        find.text('Aprobada el ${shownDate('2026-09-25T10:00:00Z')}'),
        findsOneWidget,
      );
      expect(find.textContaining('Congelad'), findsNothing);
    });

    testWidgets('una versión superada es Histórica y lo explica', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..descriptivosData = [
          descriptivoCongelado.copyWith(estadoVersion: 'historica'),
        ];
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d2',
        repository: repository,
      );
      expect(
        find.text(
          'Histórica · aprobada el ${shownDate('2026-09-25T10:00:00Z')}',
        ),
        findsOneWidget,
      );
      expect(
        find.text('Hay una versión aprobada más reciente de esta posición.'),
        findsOneWidget,
      );
      expect(find.text('Guardar borrador'), findsNothing);
      expect(find.text('Aprobar versión'), findsNothing);
    });

    testWidgets('la lista muestra Borrador, Aprobada e Histórica', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..descriptivosData = [
          descriptivoBorrador,
          descriptivoCongelado,
          descriptivoCongelado.copyWith(
            id: 'd3',
            version: 1,
            estadoVersion: 'historica',
          ),
        ];
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos',
        repository: repository,
      );
      expect(find.text('Borrador'), findsOneWidget);
      expect(find.text('Aprobada'), findsOneWidget);
      expect(find.text('Histórica'), findsOneWidget);
      expect(find.textContaining('Congelad'), findsNothing);
    });
  });

  group('datos vinculados a la posición', () {
    testWidgets('empresa, área y «Reporta a» se ven pero no se escriben', (
      tester,
    ) async {
      await _openDraft(tester, FakeRecruitmentRepository());
      expect(find.text('Vinculado a la posición'), findsOneWidget);
      for (final value in [
        'GPA Azimatronics',
        'PAILERIA',
        'Supervisor de Soldadura',
      ]) {
        expect(find.text(value), findsOneWidget);
        expect(_field(value), findsNothing);
      }
    });

    testWidgets('sin jefe registrado dice «Sin relación registrada»', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..descriptivosData = [descriptivoBorrador.copyWith(reportaA: '')];
      await _openDraft(tester, repository);
      expect(find.text('Sin relación registrada'), findsOneWidget);
    });

    testWidgets('«Supervisa a» no se calcula: se captura a mano', (
      tester,
    ) async {
      await _openDraft(tester, FakeRecruitmentRepository());
      final field = tester.widget<TextField>(
        find.descendant(
          of: _field('Supervisa a'),
          matching: find.byType(TextField),
        ),
      );
      expect(field.readOnly, isFalse);
      expect(find.textContaining('reportes directos'), findsNothing);
    });

    testWidgets('en una versión aprobada quedan como estaban al aprobar', (
      tester,
    ) async {
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d2',
        repository: FakeRecruitmentRepository(),
      );
      expect(
        find.text('Estos datos quedaron como estaban al aprobar la versión.'),
        findsOneWidget,
      );
    });
  });

  group('aviso de cambios en la posición', () {
    testWidgets('sin cambios no hay aviso', (tester) async {
      final repository = FakeRecruitmentRepository();
      await _openDraft(tester, repository);
      expect(repository.cambiosRequests, ['d1']);
      expect(find.text('La posición tiene cambios'), findsNothing);
    });

    testWidgets('muestra lo guardado frente a lo actual y no cambia solo', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..cambiosPosicionData = [_cambioJefe];
      await _openDraft(tester, repository);
      expect(find.text('La posición tiene cambios'), findsOneWidget);
      expect(
        find.text('En esta versión: Supervisor de Soldadura'),
        findsOneWidget,
      );
      expect(find.text('En la posición ahora: Jefe de Línea'), findsOneWidget);
      // El borrador conserva lo suyo hasta que alguien lo incorpore.
      expect(find.text('Supervisor de Soldadura'), findsOneWidget);
      expect(find.text('Tienes cambios sin guardar.'), findsNothing);
      expect(_onPressed(tester, 'Guardar borrador'), isNull);
    });

    testWidgets('incorporar un cambio conserva todo lo demás al guardar', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..cambiosPosicionData = [_cambioJefe];
      await _openDraft(tester, repository);
      await _edit(tester, _field('Operador de Soldadura'), 'Operador B');

      await _tapText(tester, 'Incorporar «Reporta a»');
      expect(find.text('La posición tiene cambios'), findsNothing);
      expect(find.text('Jefe de Línea'), findsOneWidget);
      expect(find.text('Tienes cambios sin guardar.'), findsOneWidget);

      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();
      final saved = repository.savedDescriptivo!;
      expect(saved.reportaA, 'Jefe de Línea');
      expect(saved.nombrePuesto, 'Operador B');
      expect(saved.proposito, 'Soldar piezas según el plano.');
      expect(saved.empresa, 'GPA Azimatronics');
      expect(saved.areaDepartamento, 'PAILERIA');
      expect(find.text('La posición tiene cambios'), findsNothing);
    });

    testWidgets('guardar sin incorporar no toca los datos vinculados', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..cambiosPosicionData = [_cambioJefe];
      await _openDraft(tester, repository);
      await _edit(tester, _field('Operador de Soldadura'), 'Operador B');
      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();
      expect(repository.savedDescriptivo!.reportaA, 'Supervisor de Soldadura');
      // Sigue pendiente de decidir.
      expect(find.text('La posición tiene cambios'), findsOneWidget);
    });

    testWidgets('una versión aprobada nunca lo muestra ni lo pide', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..cambiosPosicionData = [_cambioJefe];
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d2',
        repository: repository,
      );
      expect(find.text('La posición tiene cambios'), findsNothing);
      expect(repository.cambiosRequests, isEmpty);
    });

    testWidgets('quien solo consulta tampoco lo ve ni lo pide', (tester) async {
      final repository = FakeRecruitmentRepository()
        ..cambiosPosicionData = [_cambioJefe];
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: repository,
        user: testColaborador,
      );
      expect(find.text('La posición tiene cambios'), findsNothing);
      expect(repository.cambiosRequests, isEmpty);
    });

    testWidgets('si no se puede revisar, lo dice y deja reintentar', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..cambiosFailure = Exception('sin red');
      await _openDraft(tester, repository);
      expect(
        find.text('No se pudo revisar si la posición cambió.'),
        findsOneWidget,
      );
      // El resto de la página sigue disponible.
      expect(_field('Soldar piezas según el plano.'), findsOneWidget);

      repository
        ..cambiosFailure = null
        ..cambiosPosicionData = [_cambioJefe];
      await tester.tap(find.text('Reintentar'));
      await tester.pumpAndSettle();
      expect(find.text('La posición tiene cambios'), findsOneWidget);
    });
  });

  group('funciones', () {
    testWidgets('se reordenan sin perder lo escrito', (tester) async {
      final repository = FakeRecruitmentRepository();
      await _openDraft(tester, repository, height: 3200);
      await _edit(
        tester,
        find.widgetWithText(TextFormField, 'Responsabilidad 2'),
        'Revisar planos',
      );

      IconButton button(String tooltip) => tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip(tooltip),
          matching: find.byType(IconButton),
        ),
      );
      expect(button('Subir responsabilidad 1').onPressed, isNull);
      expect(button('Bajar responsabilidad 5').onPressed, isNull);

      await _tapTooltip(tester, 'Subir responsabilidad 2');
      expect(find.text('Tienes cambios sin guardar.'), findsOneWidget);

      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();
      final saved = repository.savedDescriptivo!;
      // Los renglones vacíos viajan al final y el servidor no los guarda.
      expect(saved.funciones.take(2).map((f) => f.texto), [
        'Revisar planos',
        'Soldar piezas',
      ]);
      expect(saved.funciones.map((f) => f.orden), [1, 2, 3, 4, 5]);
    });

    testWidgets('también se baja un renglón y se agrega uno nuevo', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await _openDraft(tester, repository, height: 3200);
      await _tapText(tester, 'Agregar responsabilidad');
      await _edit(
        tester,
        find.widgetWithText(TextFormField, 'Responsabilidad 6'),
        'Limpiar estación',
      );
      // Sube hasta el segundo lugar y luego baja el primero: quedan al revés.
      for (var i = 0; i < 4; i++) {
        await _tapTooltip(tester, 'Subir responsabilidad ${6 - i}');
      }
      await _tapTooltip(tester, 'Bajar responsabilidad 1');

      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();
      expect(
        repository.savedDescriptivo!.funciones.take(2).map((f) => f.texto),
        ['Limpiar estación', 'Soldar piezas'],
      );
    });

    testWidgets('en una versión aprobada no hay cómo reordenar', (
      tester,
    ) async {
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d2',
        repository: FakeRecruitmentRepository(),
        height: 3200,
      );
      expect(find.byTooltip('Subir responsabilidad 1'), findsNothing);
      expect(find.byTooltip('Bajar responsabilidad 1'), findsNothing);
    });
  });

  group('protección de salida', () {
    testWidgets('sin cambios se sale sin preguntar', (tester) async {
      final router = await _openDraft(tester, FakeRecruitmentRepository());
      router.go('/reclutamiento/descriptivos');
      await tester.pumpAndSettle();
      expect(find.text('¿Descartar cambios?'), findsNothing);
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/descriptivos',
      );
    });

    testWidgets('con cambios pregunta, y seguir editando conserva todo', (
      tester,
    ) async {
      final router = await _openDraft(tester, FakeRecruitmentRepository());
      await _edit(tester, _field('Operador de Soldadura'), 'Operador B');
      router.go('/reclutamiento/descriptivos');
      await tester.pumpAndSettle();
      expect(find.text('¿Descartar cambios?'), findsOneWidget);
      expect(
        find.text('Hay cambios sin guardar en el descriptivo.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Seguir editando'));
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/descriptivos/d1',
      );
      expect(_field('Operador B'), findsOneWidget);
    });

    testWidgets('descartar permite salir', (tester) async {
      final router = await _openDraft(tester, FakeRecruitmentRepository());
      await _edit(tester, _field('Operador de Soldadura'), 'Operador B');
      router.go('/reclutamiento/descriptivos');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Descartar'));
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/descriptivos',
      );
    });

    testWidgets('«Volver» también pregunta', (tester) async {
      final router = await _openDraft(tester, FakeRecruitmentRepository());
      await _edit(tester, _field('Operador de Soldadura'), 'Operador B');
      await tester.tap(find.text('Volver'));
      await tester.pumpAndSettle();
      expect(find.text('¿Descartar cambios?'), findsOneWidget);
      await tester.tap(find.text('Descartar'));
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/descriptivos',
      );
    });

    testWidgets('guardar deja salir sin preguntar', (tester) async {
      final router = await _openDraft(tester, FakeRecruitmentRepository());
      await _edit(tester, _field('Operador de Soldadura'), 'Operador B');
      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();
      router.go('/reclutamiento/descriptivos');
      await tester.pumpAndSettle();
      expect(find.text('¿Descartar cambios?'), findsNothing);
    });

    testWidgets('eliminar el borrador no vuelve a preguntar', (tester) async {
      final router = await _openDraft(tester, FakeRecruitmentRepository());
      await _edit(tester, _field('Operador de Soldadura'), 'Operador B');
      await _tapText(tester, 'Eliminar borrador');
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();
      expect(find.text('¿Descartar cambios?'), findsNothing);
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/descriptivos',
      );
    });

    testWidgets('aprobar la versión no deja la protección activa', (
      tester,
    ) async {
      final router = await _openDraft(tester, FakeRecruitmentRepository());
      await _edit(tester, _field('Operador de Soldadura'), 'Operador B');
      await _tapText(tester, 'Aprobar versión');
      await tester.tap(find.text('Aprobar'));
      await tester.pumpAndSettle();
      router.go('/reclutamiento/descriptivos');
      await tester.pumpAndSettle();
      expect(find.text('¿Descartar cambios?'), findsNothing);
    });

    testWidgets('quien solo consulta nunca recibe la pregunta', (tester) async {
      final router = await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: FakeRecruitmentRepository(),
        user: testColaborador,
      );
      router.go('/reclutamiento/descriptivos');
      await tester.pumpAndSettle();
      expect(find.text('¿Descartar cambios?'), findsNothing);
    });
  });
}
