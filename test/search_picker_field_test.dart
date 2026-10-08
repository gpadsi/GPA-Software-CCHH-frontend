import 'dart:async';

import 'package:capital_humano_front/core/design_system/colors.dart';
import 'package:capital_humano_front/core/widgets/app_overlays.dart';
import 'package:capital_humano_front/core/widgets/form_panel.dart';
import 'package:capital_humano_front/core/widgets/search_picker_field.dart';
import 'package:capital_humano_front/features/employment/application/employment_controller.dart';
import 'package:capital_humano_front/features/employment/data/employment_models.dart';
import 'package:capital_humano_front/features/employment/presentation/persona_picker_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'phase_three_fixtures.dart';
import 'recruitment_harness.dart' show pumpDebounce;

Widget picker({
  required Future<List<String>> Function(String) search,
  ValueChanged<String?>? onChanged,
  bool suggest = false,
  String? errorText,
  int attention = 0,
}) => SearchPickerField<String>(
  label: 'Posición',
  search: search,
  labelOf: (item) => item,
  detailOf: (item) => 'Vacante activa · Área de $item',
  badgeOf: (_) => 'Borrador abierto',
  onChanged: onChanged ?? (_) {},
  suggestOnFocus: suggest,
  errorText: errorText,
  attention: attention,
);

Future<void> mount(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(child: SizedBox(width: 480, child: child)),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> type(WidgetTester tester, String text) async {
  await tester.enterText(find.byType(TextFormField), text);
  await tester.pump();
  await pumpDebounce(tester);
}

Future<void> openOverlay(
  WidgetTester tester,
  Widget child, {
  bool dialog = false,
}) async {
  await mount(
    tester,
    Builder(
      builder: (context) => TextButton(
        onPressed: () {
          if (dialog) {
            showAppDialog<void>(
              context: context,
              builder: (_) => Dialog(
                child: SizedBox(
                  width: 480,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: child,
                  ),
                ),
              ),
            );
          } else {
            showAppPanel<void>(
              context: context,
              builder: (_) => AppFormPanel(
                title: 'Panel de prueba',
                onSave: () {},
                child: child,
              ),
            );
          }
        },
        child: const Text('Abrir'),
      ),
    ),
  );
  await tester.tap(find.text('Abrir'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('sin sugerencias conserva el mínimo de caracteres', (
    tester,
  ) async {
    final calls = <String>[];
    await mount(
      tester,
      picker(
        search: (text) async {
          calls.add(text);
          return ['Uno'];
        },
      ),
    );
    await tester.tap(find.byType(TextFormField));
    await tester.pumpAndSettle();
    expect(calls, isEmpty);
    await type(tester, 'u');
    expect(calls, isEmpty);
    await type(tester, 'un');
    expect(calls, ['un']);
    expect(find.text('Uno'), findsOneWidget);
  });

  testWidgets(
    'consulta sugerencias al enfocar y la ayuda no depende del foco',
    (tester) async {
      final calls = <String>[];
      await mount(
        tester,
        picker(
          suggest: true,
          search: (text) async {
            calls.add(text);
            return ['Uno'];
          },
        ),
      );
      expect(
        find.text('Elige una sugerencia o escribe puesto, unidad o área'),
        findsOneWidget,
      );
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();
      expect(calls, ['']);
      expect(find.text('Uno'), findsOneWidget);
      FocusManager.instance.primaryFocus!.unfocus();
      await tester.pumpAndSettle();
      expect(
        find.text('Elige una sugerencia o escribe puesto, unidad o área'),
        findsOneWidget,
      );
    },
  );

  testWidgets('muestra carga y Enter no selecciona el centinela', (
    tester,
  ) async {
    final result = Completer<List<String>>();
    String? selected;
    await mount(
      tester,
      picker(
        search: (_) => result.future,
        onChanged: (item) => selected = item,
      ),
    );
    await tester.enterText(find.byType(TextFormField), 'un');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    await tester.pump();
    expect(find.text('Buscando…'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final loadingSize = tester.getSize(find.byType(ListView));
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(selected, isNull);
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField)).controller!.text,
      'un',
    );
    result.complete(['Uno']);
    await tester.pumpAndSettle();
    expect(find.text('Buscando…'), findsNothing);
    expect(find.text('Uno'), findsOneWidget);
    expect(tester.getSize(find.byType(ListView)), loadingSize);
  });

  testWidgets('muestra sin coincidencias y el centinela no se selecciona', (
    tester,
  ) async {
    String? selected;
    await mount(
      tester,
      picker(search: (_) async => [], onChanged: (item) => selected = item),
    );
    await type(tester, 'ausente');
    expect(find.text('Sin coincidencias para «ausente»'), findsOneWidget);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    expect(selected, isNull);
    expect(find.text('Sin coincidencias para «ausente»'), findsOneWidget);
  });

  testWidgets('un error permite reintentar la misma consulta', (tester) async {
    final calls = <String>[];
    await mount(
      tester,
      picker(
        search: (text) async {
          calls.add(text);
          if (calls.length == 1) throw StateError('Sin conexión');
          return ['Uno'];
        },
      ),
    );
    await type(tester, 'un');
    expect(find.text('No se pudo buscar.'), findsOneWidget);
    expect(find.textContaining('Sin coincidencias'), findsNothing);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.tap(find.text('Reintentar'));
    await tester.pumpAndSettle();
    expect(calls, ['un', 'un']);
    expect(find.text('Uno'), findsOneWidget);
  });

  testWidgets('descarta una respuesta de una búsqueda superada', (
    tester,
  ) async {
    final antigua = Completer<List<String>>();
    await mount(
      tester,
      picker(
        search: (text) => text == 'un' ? antigua.future : Future.value(['Dos']),
      ),
    );
    await tester.enterText(find.byType(TextFormField), 'un');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    await type(tester, 'dos');
    expect(find.text('Dos'), findsOneWidget);
    antigua.complete(['Uno']);
    await tester.pumpAndSettle();
    expect(find.text('Uno'), findsNothing);
    expect(find.text('Dos'), findsOneWidget);
  });

  testWidgets('Enter elige la primera fila resaltada por defecto', (
    tester,
  ) async {
    String? selected;
    await mount(
      tester,
      picker(
        search: (_) async => ['Uno', 'Dos'],
        onChanged: (item) => selected = item,
      ),
    );
    await type(tester, 'un');
    final row = find
        .ancestor(of: find.text('Uno'), matching: find.byType(Container))
        .first;
    expect(tester.widget<Container>(row).color, AppColors.primarySurface);
    expect(find.text('Vacante activa · Área de Uno'), findsOneWidget);
    expect(find.text('Borrador abierto'), findsWidgets);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    // El motor traduce Enter a done; sendKeyEvent solo alcanza el framework.
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(selected, 'Uno');
    expect(
      tester.widget<TextFormField>(find.byType(TextFormField)).controller!.text,
      'Uno',
    );
  });

  testWidgets('flechas resaltan, desplazan y Enter selecciona la fila activa', (
    tester,
  ) async {
    String? selected;
    await mount(
      tester,
      picker(
        search: (_) async => List.generate(8, (i) => 'Opción $i'),
        onChanged: (item) => selected = item,
      ),
    );
    await type(tester, 'op');
    for (var i = 0; i < 7; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
    }
    expect(find.text('Opción 7').hitTestable(), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(selected, 'Opción 6');
  });

  testWidgets(
    'clic real dentro de showAppPanel selecciona sin perder la opción',
    (tester) async {
      String? selected;
      await openOverlay(
        tester,
        picker(
          suggest: true,
          search: (_) async => ['Uno'],
          onChanged: (item) => selected = item,
        ),
      );
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle();
      expect(find.text('Uno').hitTestable(), findsOneWidget);
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Uno')),
      );
      await tester.pump(const Duration(milliseconds: 20));
      expect(find.text('Uno'), findsOneWidget);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(selected, 'Uno');
      expect(find.byType(AppFormPanel), findsOneWidget);
    },
  );

  testWidgets('Escape cierra solo la lista dentro del panel', (tester) async {
    await openOverlay(
      tester,
      picker(suggest: true, search: (_) async => ['Uno']),
    );
    await tester.tap(find.byType(TextFormField));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Uno'), findsNothing);
    expect(find.byType(AppFormPanel), findsOneWidget);
  });

  testWidgets(
    'Escape durante carga descarta la respuesta sin cerrar el panel',
    (tester) async {
      final result = Completer<List<String>>();
      await openOverlay(
        tester,
        picker(suggest: true, search: (_) => result.future),
      );
      await tester.tap(find.byType(TextFormField));
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(find.text('Buscando…'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Buscando…'), findsNothing);
      result.complete(['Uno']);
      await tester.pumpAndSettle();
      expect(find.text('Uno'), findsNothing);
      expect(find.byType(AppFormPanel), findsOneWidget);
    },
  );

  testWidgets('la opción también se puede pulsar dentro de showAppDialog', (
    tester,
  ) async {
    String? selected;
    await openOverlay(
      tester,
      picker(
        suggest: true,
        search: (_) async => ['Uno'],
        onChanged: (item) => selected = item,
      ),
      dialog: true,
    );
    await tester.tap(find.byType(TextFormField));
    await tester.pumpAndSettle();
    expect(find.text('Uno').hitTestable(), findsOneWidget);
    await tester.tap(find.text('Uno'));
    await tester.pumpAndSettle();
    expect(selected, 'Uno');
    expect(find.byType(Dialog), findsOneWidget);
  });

  testWidgets('un error de validación reabre las coincidencias del texto', (
    tester,
  ) async {
    String? error;
    var attention = 0;
    await mount(
      tester,
      StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            picker(
              search: (_) async => ['Uno'],
              errorText: error,
              attention: attention,
            ),
            TextButton(
              onPressed: () => setState(() {
                error = 'Elige la posición de la lista.';
                attention++;
              }),
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
    await type(tester, 'un');
    FocusManager.instance.primaryFocus!.unfocus();
    await tester.pumpAndSettle();
    expect(find.text('Uno'), findsNothing);
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Elige la posición de la lista.'), findsOneWidget);
    expect(find.text('Uno'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Uno'), findsOneWidget);
  });

  testWidgets(
    'reconstruir el formulario con el error visible no le quita el foco a otro campo',
    (tester) async {
      var searches = 0;
      var ticks = 0;
      late StateSetter rebuild;
      final other = FocusNode();
      addTearDown(other.dispose);
      await mount(
        tester,
        StatefulBuilder(
          builder: (context, setState) {
            rebuild = setState;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                picker(
                  search: (_) async {
                    searches++;
                    return ['Uno'];
                  },
                  errorText: 'Elige la posición de la lista.',
                  attention: 1,
                ),
                TextField(focusNode: other),
                Text('Reconstrucciones $ticks'),
              ],
            );
          },
        ),
      );
      other.requestFocus();
      await tester.pumpAndSettle();
      final antes = searches;
      rebuild(() => ticks++);
      await tester.pumpAndSettle();
      await pumpDebounce(tester);
      expect(find.text('Reconstrucciones 1'), findsOneWidget);
      expect(other.hasFocus, isTrue);
      expect(searches, antes);
      expect(find.text('Uno'), findsNothing);
    },
  );

  testWidgets('el selector de personas conserva búsqueda y selección', (
    tester,
  ) async {
    final repository = FakeEmploymentRepository();
    PersonSummary? selected;
    await mount(
      tester,
      ProviderScope(
        overrides: [employmentRepositoryProvider.overrideWithValue(repository)],
        child: PersonaPickerField(onChanged: (item) => selected = item),
      ),
    );
    await tester.tap(find.byType(TextFormField));
    await tester.pumpAndSettle();
    expect(repository.searches, isEmpty);
    await type(tester, 'ana');
    expect(repository.searches, ['ana']);
    await tester.tap(find.text(personSummaryB.fullName));
    await tester.pumpAndSettle();
    expect(selected, personSummaryB);
    await type(tester, 'otro');
    expect(selected, isNull);
  });
}
