// R5: lo que se midió y se corrigió para que las pantallas no se congelen:
// secciones del descriptivo armadas por fotograma, comparación de cambios sin
// reconstruir el editor, catálogos compartidos entre pantallas y acciones de
// fila livianas.
import 'dart:async';

import 'package:capital_humano_front/core/widgets/app_card.dart';
import 'package:capital_humano_front/core/widgets/app_data_table.dart';
import 'package:capital_humano_front/core/widgets/app_row_actions.dart';
import 'package:capital_humano_front/core/widgets/app_text_field.dart';
import 'package:capital_humano_front/features/recruitment/data/recruitment_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'recruitment_fixtures.dart';
import 'recruitment_harness.dart';

Finder _chip(String name) => find.widgetWithText(ChoiceChip, name);
Finder _field(String text) => find.widgetWithText(TextFormField, text);

Future<void> _openEditor(
  WidgetTester tester,
  FakeRecruitmentRepository repository,
) => pumpRecruitment(
  tester,
  path: '/reclutamiento/descriptivos/d1',
  repository: repository,
  height: 900,
);

void main() {
  group('editor del descriptivo: solo la sección abierta', () {
    testWidgets(
      'al abrir solo se arma «Identificación»; las demás, al pedirlas',
      (tester) async {
        await _openEditor(tester, FakeRecruitmentRepository());
        expect(find.text('Datos del puesto'), findsOneWidget);
        // Aunque pase el tiempo, lo que no se abre no se arma.
        await tester.pump(const Duration(seconds: 1));
        expect(find.text('Propósito del puesto'), findsNothing);
        expect(find.text('Perfil del puesto'), findsNothing);
        expect(find.text('Indicadores de desempeño'), findsNothing);
        expect(find.byType(TextFormField), findsNWidgets(2));

        await openSection(tester, 'Perfil');
        expect(find.text('Perfil del puesto'), findsOneWidget);
        // Y la sección que se deja ya no está armada.
        expect(find.text('Datos del puesto'), findsNothing);
      },
    );

    testWidgets('lo capturado no se pierde al ir y volver entre secciones', (
      tester,
    ) async {
      await _openEditor(tester, FakeRecruitmentRepository());
      await tester.enterText(_field('Operador de Soldadura'), 'Operador B');
      await tester.pumpAndSettle();
      await openSection(tester, 'Indicadores y conformidades');
      await openSection(tester, 'Identificación');
      expect(_field('Operador B'), findsOneWidget);
      expect(find.text('Tienes cambios sin guardar.'), findsOneWidget);
    });

    testWidgets('cada sección empieza desde arriba al abrirla', (tester) async {
      await _openEditor(tester, FakeRecruitmentRepository());
      await openSection(tester, 'Propósito y funciones');
      final scroll = find.byType(SingleChildScrollView).last;
      await tester.drag(scroll, const Offset(0, -600));
      await tester.pumpAndSettle();
      await openSection(tester, 'Perfil');
      final viewport = tester.getRect(scroll);
      expect(
        viewport.contains(tester.getCenter(find.text('Perfil del puesto'))),
        isTrue,
      );
    });

    testWidgets('guardar valida también las secciones que no están abiertas', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..descriptivosData = [
          descriptivoBorrador.copyWith(competenciasOtras: 'x' * 256),
        ];
      await _openEditor(tester, repository);
      expect(find.text('Otras competencias'), findsNothing);
      await tester.enterText(_field('Operador de Soldadura'), 'Operador B');
      await tester.pump();
      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();
      // Abre la sección del problema, lo marca y no manda nada.
      expect(
        tester.widget<ChoiceChip>(_chip('Competencias y recursos')).selected,
        isTrue,
      );
      expect(find.text('Revisa los campos marcados en rojo.'), findsOneWidget);
      expect(find.text('Usa como máximo 255 caracteres.'), findsOneWidget);
      expect(repository.savedDescriptivo, isNull);
    });

    testWidgets('aprobar también valida las secciones que no están abiertas', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..descriptivosData = [
          descriptivoBorrador.copyWith(recursosOtro: 'x' * 256),
        ];
      await _openEditor(tester, repository);
      await tester.ensureVisible(find.text('Aprobar versión'));
      await tester.tap(find.text('Aprobar versión'));
      await tester.pumpAndSettle();
      expect(find.text('Revisa los campos marcados en rojo.'), findsOneWidget);
      expect(find.text('Usa como máximo 255 caracteres.'), findsOneWidget);
      expect(find.text('Aprobar versión 1'), findsNothing);
      expect(repository.calls, isEmpty);
    });

    testWidgets('el texto de «Otro» sin elegir «Otro» no impide guardar', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..descriptivosData = [
          descriptivoBorrador.copyWith(edadOtro: 'x' * 101),
        ];
      await _openEditor(tester, repository);
      await tester.enterText(_field('Operador de Soldadura'), 'Operador B');
      await tester.pump();
      await tester.tap(find.text('Guardar borrador'));
      await tester.pumpAndSettle();
      // No se eligió «Otro»: ese texto no se guarda, así que no se valida.
      expect(repository.savedDescriptivo?.nombrePuesto, 'Operador B');
      expect(repository.savedDescriptivo?.edadOtro, isEmpty);
    });
  });

  group('aviso de cambios en la posición', () {
    testWidgets('su llegada tardía no reconstruye todo el editor', (
      tester,
    ) async {
      final gate = Completer<List<CambioPosicion>>();
      final repository = FakeRecruitmentRepository()..cambiosGate = gate.future;
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: repository,
        height: 3200,
      );
      expect(find.text('La posición tiene cambios'), findsNothing);
      final before = tester.widget(find.byType(AppTextField).first);

      gate.complete(const [
        CambioPosicion(
          campo: 'reporta_a',
          etiqueta: 'Reporta a',
          guardado: 'Supervisor de Soldadura',
          actual: 'Jefe de Línea',
        ),
      ]);
      await tester.pumpAndSettle();
      expect(find.text('La posición tiene cambios'), findsOneWidget);
      // El mismo widget: el editor no se volvió a armar, solo el aviso.
      expect(
        identical(tester.widget(find.byType(AppTextField).first), before),
        isTrue,
      );
    });
  });

  group('comparación con la posición', () {
    testWidgets(
      'no se vuelve a pedir cada vez que se vuelve a «Identificación»',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        await _openEditor(tester, repository);
        expect(repository.cambiosRequests, ['d1']);
        await openSection(tester, 'Perfil');
        await openSection(tester, 'Identificación');
        await openSection(tester, 'Indicadores y conformidades');
        await openSection(tester, 'Identificación');
        expect(repository.cambiosRequests, ['d1']);
      },
    );
  });

  group('catálogos compartidos', () {
    testWidgets('volver a la lista no vuelve a pedir los catálogos', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      final router = await pumpRecruitment(
        tester,
        path: '/reclutamiento',
        repository: repository,
      );
      expect(repository.catalogCalls, {
        'estados': 1,
        'etapasAprobacion': 1,
        'tiposContrato': 1,
        'horariosACubrir': 1,
        'tiposRequisicion': 1,
      });

      router.go('/reclutamiento/descriptivos');
      await tester.pumpAndSettle();
      router.go('/reclutamiento');
      await tester.pumpAndSettle();
      expect(find.text('Operador de Soldadura — PAILERIA'), findsWidgets);
      expect(repository.catalogCalls['estados'], 1);
      expect(repository.catalogCalls['tiposRequisicion'], 1);
    });

    testWidgets('«Actualizar» sí los vuelve a pedir', (tester) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento',
        repository: repository,
      );
      await tester.tap(find.text('Actualizar'));
      await tester.pumpAndSettle();
      expect(repository.catalogCalls['estados'], 2);
    });

    testWidgets('los catálogos del descriptivo se piden una vez por sesión', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      final router = await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos/d1',
        repository: repository,
        height: 3200,
      );
      expect(repository.catalogCalls['rangosEdad'], 1);
      router.go('/reclutamiento/descriptivos');
      await tester.pumpAndSettle();
      router.go('/reclutamiento/descriptivos/d2');
      await tester.pumpAndSettle();
      expect(repository.catalogCalls['rangosEdad'], 1);
      expect(repository.catalogCalls['competencias'], 1);
    });
  });

  group('acciones de fila', () {
    Future<void> pumpActions(
      WidgetTester tester, {
      VoidCallback? onView,
      VoidCallback? onEdit,
      VoidCallback? onDelete,
    }) => tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: AppRowActions(
              subject: 'requisición de Operador',
              onView: onView,
              onEdit: onEdit,
              onDelete: onDelete,
            ),
          ),
        ),
      ),
    );

    testWidgets('solo se dibujan las acciones que tienen callback', (
      tester,
    ) async {
      await pumpActions(tester, onView: () {}, onDelete: () {});
      expect(find.byTooltip('Ver requisición de Operador'), findsOneWidget);
      expect(find.byTooltip('Editar requisición de Operador'), findsNothing);
      expect(
        find.byTooltip('Eliminar requisición de Operador'),
        findsOneWidget,
      );
    });

    testWidgets('cada acción llama a su callback con un toque', (tester) async {
      final calls = <String>[];
      await pumpActions(
        tester,
        onView: () => calls.add('ver'),
        onEdit: () => calls.add('editar'),
        onDelete: () => calls.add('eliminar'),
      );
      await tester.tap(find.byTooltip('Editar requisición de Operador'));
      await tester.tap(find.byTooltip('Eliminar requisición de Operador'));
      await tester.tap(find.byTooltip('Ver requisición de Operador'));
      expect(calls, ['editar', 'eliminar', 'ver']);
    });

    testWidgets('se activan con el teclado (Enter) y son botones semánticos', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      var views = 0;
      await pumpActions(tester, onView: () => views++);
      // Foco por teclado y activación.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(views, 1);
      expect(
        tester.getSemantics(find.byType(InkResponse)),
        isSemantics(
          tooltip: 'Ver requisición de Operador',
          isButton: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
        ),
      );
      semantics.dispose();
    });

    testWidgets('mantienen el área táctil de 48 px', (tester) async {
      await pumpActions(tester, onView: () {}, onEdit: () {}, onDelete: () {});
      for (final tooltip in [
        'Ver requisición de Operador',
        'Editar requisición de Operador',
        'Eliminar requisición de Operador',
      ]) {
        final size = tester.getSize(find.byTooltip(tooltip));
        expect(size.width, greaterThanOrEqualTo(48), reason: tooltip);
        expect(size.height, greaterThanOrEqualTo(48), reason: tooltip);
      }
    });
  });

  group('tabla: filas bajo demanda', () {
    List<Requisicion> muchas(int n) => [
      for (var i = 1; i <= n; i++)
        requisicionPropia.copyWith(
          id: 'r$i',
          posicionEtiqueta: 'Posición número ${i.toString().padLeft(2, '0')}',
        ),
    ];

    testWidgets(
      'solo se arman las filas que se ven; las demás al desplazarse',
      (tester) async {
        final repository = FakeRecruitmentRepository()
          ..requisicionesData = muchas(25);
        await pumpRecruitment(
          tester,
          path: '/reclutamiento',
          repository: repository,
          height: 900,
        );
        expect(find.text('Posición número 01'), findsOneWidget);
        // La última fila de la página no está armada todavía…
        expect(find.text('Posición número 25'), findsNothing);
        expect(find.text('1–25 de 25 resultados'), findsOneWidget);

        // …y aparece al llegar a ella, sin perder las de arriba.
        // El desplazamiento vertical de la página (no el de la barra lateral).
        final pagina = find
            .ancestor(
              of: find.text('Posición número 01'),
              matching: find.byWidgetPredicate(
                (widget) =>
                    widget is Scrollable &&
                    widget.axisDirection == AxisDirection.down,
              ),
            )
            .first;
        await tester.scrollUntilVisible(
          find.text('Posición número 25'),
          300,
          scrollable: pagina,
        );
        expect(find.text('Posición número 25'), findsOneWidget);
        expect(find.text('Posición número 01'), findsOneWidget);
      },
    );

    testWidgets('una fila armada se puede tocar para abrir su detalle', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..requisicionesData = muchas(3);
      final router = await pumpRecruitment(
        tester,
        path: '/reclutamiento',
        repository: repository,
      );
      await tester.tap(find.text('Posición número 02'));
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/requisiciones/r2',
      );
    });

    testWidgets(
      'la columna de acciones mide lo que sus botones, sin medirlos',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 1000,
                child: AppDataTable(
                  columns: const [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        const DataCell(Text('Uno')),
                        DataCell(
                          AppRowActions(
                            subject: 'uno',
                            onView: () {},
                            onEdit: () {},
                            onDelete: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                  totalCount: 1,
                  pageIndex: 0,
                  pageSize: 25,
                  onPageChanged: null,
                ),
              ),
            ),
          ),
        );
        final acciones = tester.getRect(find.byType(AppRowActions));
        expect(acciones.width, AppRowActions.width(3));
        // El resto del ancho es para el texto.
        expect(tester.getRect(find.text('Uno')).left, lessThan(40));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'en pantallas angostas la tabla se desplaza de lado sin desbordar',
      (tester) async {
        final repository = FakeRecruitmentRepository()
          ..requisicionesData = muchas(3);
        await pumpRecruitment(
          tester,
          path: '/reclutamiento',
          repository: repository,
          width: 360,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Posición número 01'), findsOneWidget);
      },
    );
  });

  group('movimiento y espacio', () {
    testWidgets(
      'el selector aparece centrado y se puede cerrar al pulsar fuera',
      (tester) async {
        await pumpRecruitment(
          tester,
          path: '/reclutamiento/descriptivos',
          repository: FakeRecruitmentRepository(),
        );
        await tester.tap(find.text('Nuevo descriptivo').first);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 60));
        // La ventana aparece en su lugar desde el primer tramo de la animación.
        final title = tester.getRect(find.text('Nuevo descriptivo de puesto'));
        expect(title.left, lessThan(1440));
        await tester.pumpAndSettle();
        final surface = find
            .ancestor(
              of: find.text('Nuevo descriptivo de puesto'),
              matching: find.byType(Material),
            )
            .first;
        expect(tester.getRect(surface).center.dx, closeTo(720, 1));
        expect(tester.getRect(surface).width, 640);
        await tester.tapAt(const Offset(20, 500));
        await tester.pumpAndSettle();
        expect(find.text('Nuevo descriptivo de puesto'), findsNothing);
      },
    );

    testWidgets('las filas del selector solo crecen si llevan etiqueta', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..posicionesElegiblesData = [
          const PosicionElegible(
            id: 'p1',
            etiqueta: 'Operador — GPA',
            unidad: 'GPA',
            area: 'Producción',
            estatus: 'Vacante Activa',
            estatusCode: 'vacante-activa',
            ocupada: false,
          ),
          const PosicionElegible(
            id: 'p2',
            etiqueta: 'Soldador — GPA',
            unidad: 'GPA',
            estatus: 'Colaborador Activo',
            estatusCode: 'colaborador-activo',
            ocupada: true,
            tramiteAbierto: TramiteAbierto(tipo: 'descriptivo', id: 'd9'),
          ),
        ];
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/descriptivos',
        repository: repository,
      );
      await tester.tap(find.text('Nuevo descriptivo').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(TextFormField).first);
      await tester.pumpAndSettle();
      final sinEtiqueta = tester.getSize(
        find.ancestor(
          of: find.text('Operador — GPA'),
          matching: find.byType(InkWell),
        ),
      );
      final conEtiqueta = tester.getSize(
        find.ancestor(
          of: find.text('Soldador — GPA'),
          matching: find.byType(InkWell),
        ),
      );
      expect(sinEtiqueta.height, lessThan(90));
      expect(conEtiqueta.height, greaterThan(sinEtiqueta.height));
    });

    testWidgets('la tarjeta de contexto de la posición es compacta', (
      tester,
    ) async {
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/nueva?posicion=pos1',
        repository: FakeRecruitmentRepository(),
      );
      final card = find
          .ancestor(of: find.text('Reporta a'), matching: find.byType(AppCard))
          .first;
      expect(tester.getSize(card).height, lessThan(260));
    });
  });
}
