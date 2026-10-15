// Componentes compartidos del bloque de fundamentos de diseño (2026-10-02):
// diálogo de confirmación único, panel de formulario, fundido de contenido y
// esqueleto de carga con movimiento.
import 'package:capital_humano_front/core/design_system/app_themes.dart';
import 'package:capital_humano_front/core/design_system/theme.dart';
import 'package:capital_humano_front/core/widgets/app_fade_switcher.dart';
import 'package:capital_humano_front/core/widgets/app_overlays.dart';
import 'package:capital_humano_front/core/widgets/app_shimmer.dart';
import 'package:capital_humano_front/core/widgets/confirm_dialog.dart';
import 'package:capital_humano_front/core/widgets/form_dialog.dart';
import 'package:capital_humano_front/core/widgets/loading_skeleton.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app(Widget home, {bool disableAnimations = false}) => MaterialApp(
  theme: AppTheme.of(AppThemeId.fallback),
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: home,
  ),
);

DioException _http(int code) => DioException(
  requestOptions: RequestOptions(path: '/x'),
  response: Response(
    requestOptions: RequestOptions(path: '/x'),
    statusCode: code,
  ),
  type: DioExceptionType.badResponse,
);

/// Un botón que abre el diálogo de confirmación y guarda el resultado.
class _Host extends StatefulWidget {
  const _Host({required this.onConfirm, this.errorMessage});
  final Future<void> Function() onConfirm;
  final String Function(Object)? errorMessage;
  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  bool? result;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Column(
      children: [
        TextButton(
          onPressed: () async {
            final value = await showConfirmDialog(
              context,
              title: 'Eliminar cosa',
              message: '¿Eliminar «Cosa»?',
              details: deleteLinkedRecordsHint,
              onConfirm: widget.onConfirm,
              errorMessage: widget.errorMessage,
            );
            setState(() => result = value);
          },
          child: const Text('abrir'),
        ),
        Text('resultado: ${result ?? 'ninguno'}'),
      ],
    ),
  );
}

void main() {
  group('showConfirmDialog', () {
    testWidgets('si la acción sale bien, cierra y devuelve true', (
      tester,
    ) async {
      var llamadas = 0;
      await tester.pumpWidget(_app(_Host(onConfirm: () async => llamadas++)));
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      expect(find.text('Eliminar cosa'), findsOneWidget);
      expect(find.text(deleteLinkedRecordsHint), findsOneWidget);

      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      expect(llamadas, 1);
      expect(find.text('Eliminar cosa'), findsNothing);
      expect(find.text('resultado: true'), findsOneWidget);
    });

    testWidgets('cancelar cierra, devuelve false y no ejecuta la acción', (
      tester,
    ) async {
      var llamadas = 0;
      await tester.pumpWidget(_app(_Host(onConfirm: () async => llamadas++)));
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(llamadas, 0);
      expect(find.text('resultado: false'), findsOneWidget);
    });

    // El defecto que tenían los diálogos de borrado copiados: si la API
    // fallaba, el diálogo se cerraba en silencio como si nada hubiera pasado.
    testWidgets('si la acción falla, NO se cierra y muestra el motivo', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(_Host(onConfirm: () async => throw _http(403))),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();

      expect(find.text('Eliminar cosa'), findsOneWidget); // sigue abierto
      expect(
        find.text('Tu cuenta no tiene permiso para eliminar este registro.'),
        findsOneWidget,
      );
      expect(find.text('resultado: ninguno'), findsOneWidget);
    });

    testWidgets('tras un fallo se puede reintentar y salir bien', (
      tester,
    ) async {
      var intento = 0;
      await tester.pumpWidget(
        _app(
          _Host(
            onConfirm: () async {
              if (++intento == 1) throw _http(500);
            },
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('registros vinculados, deben resolverse'),
        findsOneWidget,
      );

      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();
      expect(find.text('resultado: true'), findsOneWidget);
      expect(intento, 2);
    });

    testWidgets('un mensaje de error propio sustituye al genérico', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          _Host(
            onConfirm: () async => throw _http(400),
            errorMessage: (_) => 'Mensaje de la pantalla.',
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Eliminar'));
      await tester.pumpAndSettle();
      expect(find.text('Mensaje de la pantalla.'), findsOneWidget);
    });

    test('deleteErrorMessage distingue permiso, inexistente y vinculados', () {
      expect(deleteErrorMessage(_http(403)), contains('permiso'));
      expect(deleteErrorMessage(_http(404)), contains('ya no está disponible'));
      expect(deleteErrorMessage(_http(500)), contains('registros vinculados'));
      expect(deleteErrorMessage(_http(401)), contains('sesión'));
      expect(deleteErrorMessage(StateError('x')), contains('No pudimos'));
    });
  });

  group('AppFormDialog', () {
    Future<void> abrir(
      WidgetTester tester, {
      required Size size,
      bool busy = false,
      String? error,
      bool canSave = true,
      VoidCallback? onSave,
      double textScale = 1,
      bool? dirty,
    }) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      tester.platformDispatcher.textScaleFactorTestValue = textScale;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showAppDialog<bool>(
                  context: context,
                  builder: (_) => AppFormDialog(
                    title: 'Agregar persona',
                    subtitle: 'Los datos obligatorios están marcados.',
                    busy: busy,
                    error: error,
                    canSave: canSave,
                    dirty: dirty,
                    onSave: onSave ?? () {},
                    child: Column(
                      children: [for (var i = 0; i < 30; i++) Text('Campo $i')],
                    ),
                  ),
                ),
                child: const Text('abrir'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      if (busy) {
        // El botón cargando muestra un indicador infinito: pumpAndSettle no
        // terminaría nunca. Se avanza lo que dura la animación del panel.
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
      } else {
        await tester.pumpAndSettle();
      }
    }

    Rect superficie(WidgetTester tester) => tester.getRect(
      find
          .ancestor(
            of: find.text('Agregar persona'),
            matching: find.byType(Material),
          )
          .first,
    );

    testWidgets('en pantalla ancha es una ventana centrada de ancho acotado', (
      tester,
    ) async {
      await abrir(tester, size: const Size(1440, 900));
      final ventana = superficie(tester);
      expect(ventana.center.dx, closeTo(720, 1));
      expect(ventana.center.dy, closeTo(450, 1));
      expect(ventana.width, AppDialogSize.medium.width);
      // Mide lo que su contenido hasta el alto de la pantalla, sin tocarla.
      expect(ventana.height, lessThanOrEqualTo(900 - 48));
    });

    testWidgets('en un teléfono ocupa toda la pantalla', (tester) async {
      await abrir(tester, size: const Size(390, 844));
      final ventana = superficie(tester);
      expect(ventana, const Rect.fromLTWH(0, 0, 390, 844));
      // El pie queda abajo aunque el cuerpo sea corto o largo.
      expect(
        tester.getRect(find.text('Guardar')).bottom,
        greaterThan(844 - 80),
      );
    });

    testWidgets('un formulario corto no deja la ventana vacía', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(1440, 900);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showAppDialog<bool>(
                  context: context,
                  builder: (_) => AppFormDialog(
                    title: 'Agregar puesto',
                    onSave: () {},
                    child: const Text('Un solo campo'),
                  ),
                ),
                child: const Text('abrir'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      final ventana = tester.getRect(
        find
            .ancestor(
              of: find.text('Agregar puesto'),
              matching: find.byType(Material),
            )
            .first,
      );
      expect(ventana.height, lessThan(300));
    });

    testWidgets('los botones siguen a la vista aunque el cuerpo sea largo', (
      tester,
    ) async {
      await abrir(tester, size: const Size(1440, 700));
      expect(find.text('Guardar').hitTestable(), findsOneWidget);
      expect(find.text('Cancelar').hitTestable(), findsOneWidget);
      expect(
        find.text('Campo 29').hitTestable(),
        findsNothing,
      ); // el cuerpo hace scroll
    });

    testWidgets('Guardar llama onSave y Cancelar cierra el panel', (
      tester,
    ) async {
      var guardado = 0;
      await abrir(
        tester,
        size: const Size(1440, 900),
        onSave: () => guardado++,
      );
      await tester.tap(find.text('Guardar'));
      await tester.pump();
      expect(guardado, 1);

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.byType(AppFormDialog), findsNothing);
    });

    testWidgets('la X de cerrar también cierra', (tester) async {
      await abrir(tester, size: const Size(1440, 900));
      await tester.tap(find.byTooltip('Cerrar'));
      await tester.pumpAndSettle();
      expect(find.byType(AppFormDialog), findsNothing);
    });

    testWidgets('mientras guarda no se puede cerrar ni con atrás', (
      tester,
    ) async {
      await abrir(tester, size: const Size(1440, 900), busy: true);
      final cancelar = tester.widget<TextButton>(
        find.ancestor(
          of: find.text('Cancelar'),
          matching: find.byType(TextButton),
        ),
      );
      expect(cancelar.onPressed, isNull);
      final cerrar = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.close_rounded),
      );
      expect(cerrar.onPressed, isNull);
      expect(
        tester
            .widget<PopScope<Object?>>(
              find.byWidgetPredicate((widget) => widget is PopScope).last,
            )
            .canPop,
        isFalse,
      );
    });

    testWidgets('sin saber si hay cambios, Escape y el clic fuera no cierran', (
      tester,
    ) async {
      await abrir(tester, size: const Size(1440, 900));
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
      expect(find.byType(AppFormDialog), findsOneWidget);
      expect(find.text('¿Descartar cambios?'), findsNothing);
    });

    for (final escape in [false, true]) {
      final how = escape ? 'Escape' : 'el clic fuera';
      testWidgets('sin cambios, $how cierra directo', (tester) async {
        await abrir(tester, size: const Size(1440, 900), dirty: false);
        if (escape) {
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        } else {
          await tester.tapAt(const Offset(10, 10));
        }
        await tester.pumpAndSettle();
        expect(find.byType(AppFormDialog), findsNothing);
      });

      testWidgets('con cambios, $how pregunta antes de descartar', (
        tester,
      ) async {
        await abrir(tester, size: const Size(1440, 900), dirty: true);
        if (escape) {
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        } else {
          await tester.tapAt(const Offset(10, 10));
        }
        await tester.pumpAndSettle();
        expect(find.text('¿Descartar cambios?'), findsOneWidget);
        await tester.tap(find.text('Seguir editando'));
        await tester.pumpAndSettle();
        expect(find.byType(AppFormDialog), findsOneWidget);

        await tester.tap(find.text('Cancelar'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Descartar'));
        await tester.pumpAndSettle();
        expect(find.byType(AppFormDialog), findsNothing);
      });
    }

    testWidgets('muestra el error arriba de los botones', (tester) async {
      await abrir(
        tester,
        size: const Size(1440, 900),
        error: 'No se pudo guardar.',
      );
      expect(find.text('No se pudo guardar.'), findsOneWidget);
    });

    testWidgets('canSave=false deshabilita Guardar', (tester) async {
      await abrir(tester, size: const Size(1440, 900), canSave: false);
      final guardar = tester.widget<TextButton>(
        find.ancestor(
          of: find.text('Guardar'),
          matching: find.byType(TextButton),
        ),
      );
      expect(guardar.onPressed, isNull);
    });

    for (final size in const [
      Size(320, 640),
      Size(640, 800),
      Size(1024, 700),
    ]) {
      testWidgets('sin desbordamiento a ${size.width.toInt()} px y texto 1.5', (
        tester,
      ) async {
        await abrir(
          tester,
          size: size,
          error: 'Un error largo que debe ajustarse sin desbordar.',
          textScale: 1.5,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Guardar').hitTestable(), findsOneWidget);
      });
    }
  });

  group('AppFadeSwitcher', () {
    testWidgets(
      'cambiar de tipo hace fundido: durante la transición conviven los dos',
      (tester) async {
        final estado = ValueNotifier<Widget>(
          const Text('cargando', key: ValueKey('a')),
        );
        await tester.pumpWidget(
          _app(
            Scaffold(
              body: ValueListenableBuilder<Widget>(
                valueListenable: estado,
                builder: (_, child, _) => AppFadeSwitcher(child: child),
              ),
            ),
          ),
        );
        expect(find.text('cargando'), findsOneWidget);

        estado.value = const SizedBox(key: ValueKey('b'), child: Text('datos'));
        await tester.pump(const Duration(milliseconds: 40));
        expect(find.text('cargando'), findsOneWidget);
        expect(find.text('datos'), findsOneWidget);

        await tester.pumpAndSettle();
        expect(find.text('cargando'), findsNothing);
        expect(find.text('datos'), findsOneWidget);
      },
    );

    testWidgets('con movimiento reducido cambia al instante, sin fundido', (
      tester,
    ) async {
      final estado = ValueNotifier<Widget>(
        const Text('cargando', key: ValueKey('a')),
      );
      await tester.pumpWidget(
        _app(
          Scaffold(
            body: ValueListenableBuilder<Widget>(
              valueListenable: estado,
              builder: (_, child, _) => AppFadeSwitcher(child: child),
            ),
          ),
          disableAnimations: true,
        ),
      );
      estado.value = const SizedBox(key: ValueKey('b'), child: Text('datos'));
      await tester.pump();
      await tester.pump();
      expect(find.text('cargando'), findsNothing);
      expect(find.text('datos'), findsOneWidget);
    });
  });

  group('LoadingSkeleton y AppShimmer', () {
    BoxDecoration decoracion(WidgetTester tester) =>
        tester
                .widget<Container>(
                  find.descendant(
                    of: find.byType(LoadingSkeleton),
                    matching: find.byType(Container),
                  ),
                )
                .decoration!
            as BoxDecoration;

    testWidgets('dentro de AppShimmer el brillo se mueve con el tiempo', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const Scaffold(body: AppShimmer(child: LoadingSkeleton(width: 120))),
        ),
      );
      final antes = (decoracion(tester).gradient! as LinearGradient).begin;
      await tester.pump(const Duration(milliseconds: 400));
      final despues = (decoracion(tester).gradient! as LinearGradient).begin;
      expect(despues, isNot(antes));
    });

    testWidgets('sin AppShimmer queda estático (color plano)', (tester) async {
      await tester.pumpWidget(
        _app(const Scaffold(body: LoadingSkeleton(width: 120))),
      );
      expect(decoracion(tester).gradient, isNull);
      expect(decoracion(tester).color, isNotNull);
    });

    testWidgets(
      'con movimiento reducido queda estático aunque haya AppShimmer',
      (tester) async {
        await tester.pumpWidget(
          _app(
            const Scaffold(
              body: AppShimmer(child: LoadingSkeleton(width: 120)),
            ),
            disableAnimations: true,
          ),
        );
        expect(decoracion(tester).gradient, isNull);
        await tester
            .pumpAndSettle(); // no hay animación infinita: debe asentarse
      },
    );

    testWidgets(
      'varios bloques comparten la misma fase (brillo sincronizado)',
      (tester) async {
        await tester.pumpWidget(
          _app(
            const Scaffold(
              body: AppShimmer(
                child: Column(
                  children: [
                    LoadingSkeleton(width: 120),
                    LoadingSkeleton(width: 120),
                  ],
                ),
              ),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 500));
        final gradientes = tester
            .widgetList<Container>(
              find.descendant(
                of: find.byType(LoadingSkeleton),
                matching: find.byType(Container),
              ),
            )
            .map(
              (c) =>
                  ((c.decoration! as BoxDecoration).gradient! as LinearGradient)
                      .begin,
            )
            .toList();
        expect(gradientes, hasLength(2));
        expect(gradientes[0], gradientes[1]);
      },
    );
  });
}
