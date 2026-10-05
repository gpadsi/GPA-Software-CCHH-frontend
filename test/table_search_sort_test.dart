// Búsqueda y orden en tablas (2026-10-02): TableQuery, el ayudante del
// cliente, la barra de búsqueda, los encabezados ordenables y su conexión en
// cada pantalla.
import 'package:capital_humano_front/core/design_system/theme.dart';
import 'package:capital_humano_front/core/network/api_page.dart';
import 'package:capital_humano_front/core/network/client_table.dart';
import 'package:capital_humano_front/core/network/table_query.dart';
import 'package:capital_humano_front/core/widgets/app_data_table.dart';
import 'package:capital_humano_front/core/widgets/app_table_toolbar.dart';
import 'package:capital_humano_front/features/persons/data/person_models.dart';
import 'package:capital_humano_front/features/positions/data/position_models.dart';
import 'package:capital_humano_front/features/schedules/data/schedule_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'phase_five_fixtures.dart';
import 'phase_five_widget_test.dart' show pumpPhaseFive;
import 'phase_four_fixtures.dart';
import 'phase_four_widget_test.dart' show pumpPhaseFour;
import 'phase_three_fixtures.dart';
import 'phase_three_widget_test.dart' show pumpPhaseThree;
import 'phase_two_fixtures.dart';
import 'phase_two_widget_test.dart' show pumpPhaseTwo;

Widget _app(Widget child) => MaterialApp(
  theme: AppTheme.light,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

void main() {
  group('TableQuery', () {
    test('solo manda los parámetros que tienen valor', () {
      expect(const TableQuery().params, isEmpty);
      expect(const TableQuery(search: 'perez').params, {'search': 'perez'});
      expect(const TableQuery(ordering: '-name').params, {'ordering': '-name'});
      expect(const TableQuery(search: 'a', ordering: 'b').params, {
        'search': 'a',
        'ordering': 'b',
      });
    });

    test('igualdad por contenido (los proveedores de Riverpod se identifican por ==)', () {
      expect(
        const TableQuery(search: 'a', ordering: 'b'),
        const TableQuery(search: 'a', ordering: 'b'),
      );
      expect(
        const TableQuery(search: 'a').hashCode,
        const TableQuery(search: 'a').hashCode,
      );
      expect(
        const TableQuery(search: 'a'),
        isNot(const TableQuery(search: 'b')),
      );
    });

    test('copyWith cambia solo lo pedido', () {
      const base = TableQuery(search: 'a', ordering: 'b');
      expect(
        base.copyWith(search: 'z'),
        const TableQuery(search: 'z', ordering: 'b'),
      );
      expect(
        base.copyWith(ordering: '-b'),
        const TableQuery(search: 'a', ordering: '-b'),
      );
      expect(base.isSearching, isTrue);
      expect(const TableQuery().isSearching, isFalse);
    });
  });

  group('fetchPage', () {
    Future<Map<String, dynamic>> consulta(
      TableQuery query, {
      Map<String, dynamic> extra = const {},
    }) async {
      final dio = Dio();
      Map<String, dynamic>? recibido;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            recibido = options.queryParameters;
            handler.resolve(
              Response(
                requestOptions: options,
                data: {'count': 0, 'results': <Object>[]},
              ),
            );
          },
        ),
      );
      await fetchPage<Object>(
        dio,
        'x/',
        (j) => j,
        query: query,
        queryParameters: extra,
      );
      return recibido!;
    }

    test('sin búsqueda ni orden solo manda la paginación', () async {
      expect(await consulta(const TableQuery()), {'page': 1, 'page_size': 25});
    });

    test('con búsqueda y orden los agrega a la petición', () async {
      expect(
        await consulta(
          const TableQuery(search: 'pérez', ordering: '-last_name_paternal'),
        ),
        {
          'page': 1,
          'page_size': 25,
          'search': 'pérez',
          'ordering': '-last_name_paternal',
        },
      );
    });

    test('convive con otros filtros de la pantalla', () async {
      final params = await consulta(
        const TableQuery(search: 'a'),
        extra: {'persona': 'p1'},
      );
      expect(params, containsPair('persona', 'p1'));
      expect(params, containsPair('search', 'a'));
    });
  });

  group('clientPage y foldAccents', () {
    const items = ['Técnico B', 'Soldador', 'tecnico a', 'Ñandú', 'Operador'];
    ClientPage<String> pagina(TableQuery q, {int page = 0, int size = 25}) =>
        clientPage<String>(
          items,
          query: q,
          page: page,
          pageSize: size,
          searchTexts: (s) => [s],
          comparators: {
            'name': (a, b) => foldAccents(a).compareTo(foldAccents(b)),
          },
        );

    test('foldAccents ignora acentos, ñ y mayúsculas', () {
      expect(foldAccents('Técnico Ñandú ÁÉÍÓÚ Üa'), 'tecnico nandu aeiou ua');
      expect(foldAccents('Plain'), 'plain');
    });

    test('busca sin acentos ni mayúsculas', () {
      expect(pagina(const TableQuery(search: 'tecnico')).rows, [
        'Técnico B',
        'tecnico a',
      ]);
      expect(pagina(const TableQuery(search: 'TÉCNICO')).rows, [
        'Técnico B',
        'tecnico a',
      ]);
      expect(pagina(const TableQuery(search: 'nandu')).rows, ['Ñandú']);
    });

    test('varias palabras deben aparecer todas (en cualquier orden)', () {
      expect(pagina(const TableQuery(search: 'b tecnico')).rows, ['Técnico B']);
      expect(
        pagina(const TableQuery(search: 'tecnico soldador')).rows,
        isEmpty,
      );
    });

    test('sin búsqueda trae todo; sin coincidencias, nada', () {
      expect(pagina(const TableQuery()).total, 5);
      expect(pagina(const TableQuery(search: '   ')).total, 5);
      final nada = pagina(const TableQuery(search: 'zzz'));
      expect(nada.rows, isEmpty);
      expect(nada.total, 0);
    });

    test('ordena ascendente y descendente ignorando acentos', () {
      expect(pagina(const TableQuery(ordering: 'name')).rows, [
        'Ñandú',
        'Operador',
        'Soldador',
        'tecnico a',
        'Técnico B',
      ]);
      expect(pagina(const TableQuery(ordering: '-name')).rows, [
        'Técnico B',
        'tecnico a',
        'Soldador',
        'Operador',
        'Ñandú',
      ]);
    });

    test('un campo sin comparador se ignora, como el servidor', () {
      expect(pagina(const TableQuery(ordering: 'inventado')).rows, items);
      expect(
        pagina(const TableQuery(ordering: '-inventado,name')).rows.first,
        'Ñandú',
      );
    });

    test('es estable: filas iguales conservan su orden original', () {
      final r = clientPage<String>(
        ['b1', 'a1', 'b2', 'a2'],
        query: const TableQuery(ordering: 'letra'),
        page: 0,
        searchTexts: (s) => [s],
        comparators: {'letra': (a, b) => a[0].compareTo(b[0])},
      );
      expect(r.rows, ['a1', 'a2', 'b1', 'b2']);
    });

    test('la página y el total son de lo que cumple la búsqueda', () {
      final grandes = [
        for (var i = 0; i < 60; i++) 'Puesto ${i.toString().padLeft(2, '0')}',
      ];
      ClientPage<String> p(int page) => clientPage<String>(
        grandes,
        query: const TableQuery(search: 'puesto'),
        page: page,
        searchTexts: (s) => [s],
        comparators: const {},
      );
      expect(p(0).rows, hasLength(25));
      expect(p(1).rows.first, 'Puesto 25');
      expect(p(2).rows, hasLength(10));
      expect(p(2).total, 60);
      expect(p(3).rows, isEmpty); // más allá del final: vacío, sin error
    });
  });

  group('AppTableToolbar', () {
    Future<List<String>> pumpToolbar(
      WidgetTester tester, {
      String value = '',
    }) async {
      final emitido = <String>[];
      await tester.pumpWidget(
        _app(
          AppTableToolbar(
            hint: 'Buscar por algo',
            value: value,
            onSearch: emitido.add,
          ),
        ),
      );
      return emitido;
    }

    testWidgets('espera a que se deje de teclear antes de avisar', (
      tester,
    ) async {
      final emitido = await pumpToolbar(tester);
      await tester.enterText(find.byType(TextField), 'pér');
      await tester.pump(const Duration(milliseconds: 300));
      expect(emitido, isEmpty); // todavía no: sigue la espera
      await tester.enterText(find.byType(TextField), 'pérez');
      await tester.pump(const Duration(milliseconds: 300));
      expect(emitido, isEmpty); // teclear de nuevo reinició la espera
      await tester.pump(const Duration(milliseconds: 100));
      expect(emitido, ['pérez']); // un solo aviso, con el texto final
    });

    testWidgets('Enter avisa de inmediato y recorta espacios', (tester) async {
      final emitido = await pumpToolbar(tester);
      await tester.enterText(find.byType(TextField), '  perez  ');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();
      expect(emitido, ['perez']);
      await tester.pump(
        const Duration(seconds: 1),
      ); // el aviso diferido ya no dispara otro
      expect(emitido, ['perez']);
    });

    testWidgets('no avisa si el texto aplicado es el mismo', (tester) async {
      final emitido = await pumpToolbar(tester, value: 'perez');
      await tester.enterText(find.byType(TextField), 'perez ');
      await tester.pump(const Duration(milliseconds: 400));
      expect(emitido, isEmpty);
    });

    testWidgets(
      'el botón de limpiar solo aparece con texto, vacía el campo y avisa al instante',
      (tester) async {
        final emitido = await pumpToolbar(tester);
        expect(find.byTooltip('Limpiar búsqueda'), findsNothing);
        await tester.enterText(find.byType(TextField), 'perez');
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.byTooltip('Limpiar búsqueda'), findsOneWidget);

        await tester.tap(find.byTooltip('Limpiar búsqueda'));
        await tester.pump();
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          '',
        );
        expect(emitido.last, '');
        expect(find.byTooltip('Limpiar búsqueda'), findsNothing);
      },
    );

    testWidgets('sigue a la pantalla si la búsqueda cambia desde fuera', (
      tester,
    ) async {
      final valor = ValueNotifier('perez');
      await tester.pumpWidget(
        _app(
          ValueListenableBuilder<String>(
            valueListenable: valor,
            builder: (_, v, _) =>
                AppTableToolbar(hint: 'x', value: v, onSearch: (_) {}),
          ),
        ),
      );
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        'perez',
      );
      valor.value =
          ''; // p. ej. "Limpiar búsqueda" del estado vacío de la tabla
      await tester.pump();
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        '',
      );
    });

    testWidgets('mientras se teclea no pisa el texto ni mueve el cursor', (
      tester,
    ) async {
      await pumpToolbar(tester);
      await tester.enterText(find.byType(TextField), 'abc');
      await tester.pump();
      final controller = tester
          .widget<TextField>(find.byType(TextField))
          .controller!;
      expect(controller.text, 'abc');
      expect(controller.selection.baseOffset, 3);
    });
  });

  group('AppDataTable: orden y búsqueda sin resultados', () {
    Future<List<String>> pumpTable(
      WidgetTester tester, {
      String ordering = '',
      String searchTerm = '',
      List<DataRow> rows = const [],
      VoidCallback? onClear,
    }) async {
      final pedidos = <String>[];
      await tester.pumpWidget(
        _app(
          AppDataTable(
            columns: const [
              DataColumn(label: Text('Nombre')),
              DataColumn(label: Text('Edad')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: rows,
            sortFields: const ['last,first', 'age', null],
            ordering: ordering,
            onOrderingChanged: pedidos.add,
            searchTerm: searchTerm,
            onClearSearch: onClear,
            totalCount: rows.length,
            pageIndex: 0,
            pageSize: 25,
            onPageChanged: null,
          ),
        ),
      );
      return pedidos;
    }

    DataTable table(WidgetTester tester) =>
        tester.widget<DataTable>(find.byType(DataTable));

    testWidgets(
      'tocar un encabezado ordena ascendente; volver a tocarlo, descendente',
      (tester) async {
        final pedidos = await pumpTable(tester);
        await tester.tap(find.text('Edad'));
        expect(pedidos, ['age']);
      },
    );

    testWidgets(
      'el segundo toque sobre la misma columna invierte TODOS sus campos',
      (tester) async {
        final pedidos = await pumpTable(tester, ordering: 'last,first');
        await tester.tap(find.text('Nombre'));
        expect(pedidos, ['-last,-first']);
      },
    );

    testWidgets('la flecha sale del orden actual, ascendente o descendente', (
      tester,
    ) async {
      await pumpTable(tester, ordering: 'age');
      expect(table(tester).sortColumnIndex, 1);
      expect(table(tester).sortAscending, isTrue);

      await pumpTable(tester, ordering: '-last,-first');
      expect(table(tester).sortColumnIndex, 0);
      expect(table(tester).sortAscending, isFalse);

      await pumpTable(tester, ordering: '');
      expect(table(tester).sortColumnIndex, isNull);
    });

    testWidgets('una columna sin campo (Acciones) no es ordenable', (
      tester,
    ) async {
      await pumpTable(tester);
      final columnas = table(tester).columns;
      expect(columnas[0].onSort, isNotNull);
      expect(columnas[1].onSort, isNotNull);
      expect(columnas[2].onSort, isNull);
      expect(columnas[0].tooltip, 'Ordenar por nombre');
    });

    testWidgets(
      'sin filas y con búsqueda habla de la búsqueda y ofrece limpiarla',
      (tester) async {
        var limpiada = 0;
        await pumpTable(tester, searchTerm: 'zzz', onClear: () => limpiada++);
        expect(
          find.textContaining('No encontramos nada para «zzz»'),
          findsOneWidget,
        );
        expect(
          find.text('No hay registros para mostrar en este momento.'),
          findsNothing,
        );
        await tester.tap(find.text('Limpiar búsqueda'));
        expect(limpiada, 1);
      },
    );

    testWidgets(
      'sin filas y sin búsqueda sigue diciendo que no hay registros',
      (tester) async {
        await pumpTable(tester);
        expect(
          find.text('No hay registros para mostrar en este momento.'),
          findsOneWidget,
        );
        expect(find.text('Limpiar búsqueda'), findsNothing);
      },
    );
  });

  // ---------------------------------------------------------------------
  // Conexión en cada pantalla: la barra manda ?search=, el encabezado manda
  // ?ordering= y la búsqueda conserva el orden.
  // ---------------------------------------------------------------------
  group('pantallas con paginación del servidor', () {
    final casos =
        <
          ({
            String nombre,
            String hint,
            String encabezado,
            String ordenAsc,
            String ordenDesc,
            Future<TableQuery Function()> Function(WidgetTester) abrir,
          })
        >[
          (
            nombre: 'Personas',
            hint: 'Buscar por nombre, CURP, correo o teléfono',
            encabezado: 'Nombre completo',
            ordenAsc: 'last_name_paternal,last_name_maternal,first_name',
            ordenDesc: '-last_name_paternal,-last_name_maternal,-first_name',
            abrir: (tester) async {
              final repo = FakePersonsRepository();
              await pumpPhaseThree(tester, path: '/personas', persons: repo);
              return () => repo.lastQuery;
            },
          ),
          (
            nombre: 'Empleados',
            hint: 'Buscar por número de nómina o nombre',
            encabezado: 'Número de nómina',
            ordenAsc: 'work_number',
            ordenDesc: '-work_number',
            abrir: (tester) async {
              final repo = FakeEmploymentRepository();
              await pumpPhaseThree(
                tester,
                path: '/empleados',
                employment: repo,
              );
              return () => repo.lastQuery;
            },
          ),
          (
            nombre: 'Posiciones',
            hint: 'Buscar por puesto, área, unidad o estatus',
            encabezado: 'Puesto',
            ordenAsc: 'puesto__name',
            ordenDesc: '-puesto__name',
            abrir: (tester) async {
              final repo = FakePositionsRepository();
              await pumpPhaseFour(tester, path: '/posiciones', positions: repo);
              return () => repo.lastQuery;
            },
          ),
          (
            nombre: 'Ubicaciones',
            hint: 'Buscar por código, nombre o registro patronal',
            encabezado: 'Código',
            ordenAsc: 'code',
            ordenDesc: '-code',
            abrir: (tester) async {
              final repo = FakeLocationsRepository();
              await pumpPhaseTwo(tester, path: '/ubicaciones', locations: repo);
              return () => repo.lastQuery;
            },
          ),
          (
            nombre: 'Empresas',
            hint: 'Buscar por empresa, razón social o RFC',
            encabezado: 'Razón social',
            ordenAsc: 'legal_name',
            ordenDesc: '-legal_name',
            abrir: (tester) async {
              final repo = FakeOrganizationsRepository();
              await pumpPhaseTwo(
                tester,
                path: '/organizacion/empresas',
                organizations: repo,
              );
              return () => repo.lastQuery;
            },
          ),
          (
            nombre: 'Catorcenas',
            hint: 'Buscar por número o año',
            encabezado: 'Catorcena',
            ordenAsc: 'anio,numero',
            ordenDesc: '-anio,-numero',
            abrir: (tester) async {
              final repo = FakeSchedulesRepository();
              await pumpPhaseFive(
                tester,
                path: '/horarios/catorcenas',
                schedules: repo,
              );
              return () => repo.lastCatorcenasQuery;
            },
          ),
          (
            nombre: 'Asignaciones de horario',
            hint: 'Buscar por empleado o tipo de horario',
            encabezado: 'Tipo de horario',
            ordenAsc: 'tipo_horario__name',
            ordenDesc: '-tipo_horario__name',
            abrir: (tester) async {
              final repo = FakeSchedulesRepository();
              await pumpPhaseFive(
                tester,
                path: '/horarios/asignaciones-horario',
                schedules: repo,
              );
              return () => repo.lastAsignacionesHorarioQuery;
            },
          ),
        ];

    for (final caso in casos) {
      testWidgets(
        '${caso.nombre}: búsqueda y orden llegan al servidor y se combinan',
        (tester) async {
          final ultima = await caso.abrir(tester);
          expect(ultima(), const TableQuery());
          expect(find.text(caso.hint), findsOneWidget);

          await tester.tap(
            find.descendant(
              of: find.byType(DataTable),
              matching: find.text(caso.encabezado),
            ),
          );
          await tester.pumpAndSettle();
          expect(ultima().ordering, caso.ordenAsc);

          await tester.tap(
            find.descendant(
              of: find.byType(DataTable),
              matching: find.text(caso.encabezado),
            ),
          );
          await tester.pumpAndSettle();
          expect(ultima().ordering, caso.ordenDesc);

          await tester.enterText(find.byType(TextField), 'tecnico');
          await tester.pump(const Duration(milliseconds: 400));
          await tester.pumpAndSettle();
          expect(
            ultima(),
            TableQuery(search: 'tecnico', ordering: caso.ordenDesc),
          ); // el orden se conserva
        },
      );
    }

    testWidgets(
      'el campo de búsqueda conserva texto y foco mientras la tabla recarga',
      (tester) async {
        await FakePersonsRepository().let((repo) async {
          await pumpPhaseThree(tester, path: '/personas', persons: repo);
          await tester.tap(find.byType(TextField));
          await tester.pump();
          await tester.enterText(find.byType(TextField), 'pérez');
          await tester.pump(const Duration(milliseconds: 400));
          await tester.pumpAndSettle();

          expect(repo.lastQuery.search, 'pérez');
          final campo = tester.widget<EditableText>(find.byType(EditableText));
          expect(campo.controller.text, 'pérez');
          expect(
            campo.focusNode.hasFocus,
            isTrue,
          ); // la tabla recargó y el campo sigue ahí
        });
      },
    );

    testWidgets(
      'sin resultados: mensaje de búsqueda y "Limpiar búsqueda" restablece la lista',
      (tester) async {
        final repo = FakePersonsRepository();
        await pumpPhaseThree(tester, path: '/personas', persons: repo);
        final originales = [...repo.personas];
        repo.personas.clear();

        await tester.enterText(find.byType(TextField), 'zzz');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pumpAndSettle();
        expect(
          find.textContaining('No encontramos nada para «zzz»'),
          findsOneWidget,
        );

        repo.personas.addAll(originales);
        await tester.tap(find.text('Limpiar búsqueda'));
        await tester.pumpAndSettle();
        expect(repo.lastQuery.search, '');
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          '',
        );
        expect(find.text('Pérez López Juan'), findsOneWidget);
      },
    );

    testWidgets('buscar vuelve a la primera página', (tester) async {
      final repo = _VariasPaginasPersons();
      await pumpPhaseThree(tester, path: '/personas', persons: repo);
      await tester.tap(find.byTooltip('Página siguiente'));
      await tester.pumpAndSettle();
      expect(repo.paginas.last, 2);

      await tester.enterText(find.byType(TextField), 'x');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(repo.paginas.last, 1);
      expect(repo.lastQuery.search, 'x');
    });
  });

  group('catálogos completos en memoria (búsqueda y orden en el cliente)', () {
    testWidgets('Puestos: busca sin acentos, ordena y pagina de 25 en 25', (
      tester,
    ) async {
      final repo = _PuestosFake([
        for (var i = 0; i < 30; i++)
          PositionCatalogEntry(
            id: i,
            code: 'P${i.toString().padLeft(2, '0')}',
            name: 'Técnico ${(30 - i).toString().padLeft(2, '0')}',
            isActive: i.isEven,
          ),
        const PositionCatalogEntry(
          id: 99,
          code: 'ZZ',
          name: 'Soldador',
          isActive: true,
        ),
      ]);
      await pumpPhaseFour(tester, path: '/posiciones/puestos', positions: repo);

      expect(find.text('1–25 de 31 resultados'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'tecnico');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('1–25 de 30 resultados'), findsOneWidget);
      expect(find.text('Soldador'), findsNothing);

      await _tocar(tester, find.byTooltip('Página siguiente'));
      expect(find.text('26–30 de 30 resultados'), findsOneWidget);

      // Ordenar vuelve a la primera página y respeta la búsqueda.
      await tester.tap(
        find.descendant(
          of: find.byType(DataTable),
          matching: find.text('Nombre'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('1–25 de 30 resultados'), findsOneWidget);
      expect(find.text('Técnico 01'), findsOneWidget); // ascendente: 01 primero
      expect(find.text('Técnico 30'), findsNothing); // quedó en la página 2

      await tester.tap(
        find.descendant(
          of: find.byType(DataTable),
          matching: find.text('Nombre'),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Técnico 30'),
        findsOneWidget,
      ); // descendente: 30 primero
    });

    testWidgets('Puestos: sin coincidencias ofrece limpiar la búsqueda', (
      tester,
    ) async {
      await pumpPhaseFour(
        tester,
        path: '/posiciones/puestos',
        positions: FakePositionsRepository(),
      );
      await tester.enterText(find.byType(TextField), 'zzz');
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('No encontramos nada para «zzz»'),
        findsOneWidget,
      );
      await tester.tap(find.text('Limpiar búsqueda'));
      await tester.pumpAndSettle();
      expect(find.text(puestoCatalogA.name), findsOneWidget);
    });

    testWidgets(
      'Tipos de horario: busca también por la descripción del horario',
      (tester) async {
        await pumpPhaseFive(
          tester,
          path: '/horarios/tipos',
          schedules: _TiposFake(),
        );
        expect(find.text('Matutino'), findsOneWidget);
        expect(find.text('Nocturno'), findsOneWidget);

        await tester.enterText(find.byType(TextField), '23:00');
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pumpAndSettle();
        expect(find.text('Nocturno'), findsOneWidget);
        expect(find.text('Matutino'), findsNothing);
      },
    );
  });
}

/// La tabla de 25 filas es más alta que la ventana de prueba: se desplaza hasta
/// el control antes de tocarlo.
Future<void> _tocar(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

extension _Let<T> on T {
  R let<R>(R Function(T) f) => f(this);
}

class _VariasPaginasPersons extends FakePersonsRepository {
  final paginas = <int>[];
  @override
  Future<ApiPage<Persona>> list(
    int page, {
    TableQuery query = const TableQuery(),
  }) async {
    paginas.add(page);
    lastQuery = query;
    return ApiPage(count: 60, results: [personaA]);
  }
}

class _PuestosFake extends FakePositionsRepository {
  _PuestosFake(this.puestos);
  final List<PositionCatalogEntry> puestos;
  @override
  Future<PositionCatalogs> catalogs() async => PositionCatalogs(
    alcances: positionCatalogsFixture.alcances,
    tiposPosicion: positionCatalogsFixture.tiposPosicion,
    tiposRequisicion: positionCatalogsFixture.tiposRequisicion,
    estatus: positionCatalogsFixture.estatus,
    puestos: puestos,
    generos: positionCatalogsFixture.generos,
    organizationNodes: positionCatalogsFixture.organizationNodes,
    areas: positionCatalogsFixture.areas,
  );
}

class _TiposFake extends FakeSchedulesRepository {
  @override
  Future<List<TipoHorarioRef>> tiposHorario() async => const [
    TipoHorarioRef(
      id: 1,
      code: 'MAT',
      name: 'Matutino',
      descripcion: '07:00 a 15:00',
      isActive: true,
    ),
    TipoHorarioRef(
      id: 2,
      code: 'NOC',
      name: 'Nocturno',
      descripcion: '23:00 a 07:00',
      isActive: true,
    ),
  ];
}
