import 'dart:async';

import 'package:capital_humano_front/core/widgets/form_panel.dart';
import 'package:capital_humano_front/core/widgets/search_picker_create_dialog.dart';
import 'package:capital_humano_front/core/widgets/search_picker_field.dart';
import 'package:capital_humano_front/features/recruitment/data/recruitment_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'phase_four_fixtures.dart';
import 'recruitment_fixtures.dart';
import 'recruitment_harness.dart';
import 'search_picker_field_test.dart' show openOverlay;
import 'test_session.dart';

Finder _areaPicker() => find.byType(SearchPickerField<AreaSolicitante>);
Finder _areaField() =>
    find.descendant(of: _areaPicker(), matching: find.byType(TextFormField));
Finder _nombreField() => find.widgetWithText(TextFormField, 'Nombre');

Future<void> _escribir(WidgetTester tester, Finder field, String text) async {
  await tester.ensureVisible(field);
  await tester.enterText(field, text);
  await pumpDebounce(tester);
}

Future<void> _abrirRequisicion(
  WidgetTester tester,
  FakeRecruitmentRepository repository, {
  bool colaborador = false,
}) async {
  await pumpRecruitment(
    tester,
    path: '/reclutamiento',
    repository: repository,
    user: colaborador ? testColaborador : testUser,
  );
  await tester.tap(find.text('Nueva requisición').first);
  await tester.pumpAndSettle();
}

Future<void> _agregarArea(WidgetTester tester, String text) async {
  await _escribir(tester, _areaField(), text);
  await tester.tap(find.text('Agregar «$text»'));
  await tester.pumpAndSettle();
}

void main() {
  group('acción Agregar del selector', () {
    for (final teclado in [false, true]) {
      testWidgets(
        'la acción ${teclado ? 'con Enter' : 'con clic'} crea solo al guardar y selecciona',
        (tester) async {
          String? selected;
          String? created;
          await openOverlay(
            tester,
            SearchPickerField<String>(
              label: 'Área solicitante',
              search: (_) async => [],
              labelOf: (item) => item,
              onChanged: (item) => selected = item,
              onCreate: (name) async {
                created = name;
                return name;
              },
            ),
          );
          await _escribir(tester, find.byType(TextFormField), 'Mantenimiento');
          expect(find.text('Agregar «Mantenimiento»'), findsOneWidget);
          if (teclado) {
            await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
            await tester.pumpAndSettle();
            await tester.sendKeyEvent(LogicalKeyboardKey.enter);
            await tester.testTextInput.receiveAction(TextInputAction.done);
          } else {
            await tester.tap(find.text('Agregar «Mantenimiento»'));
          }
          await tester.pumpAndSettle();
          expect(find.byType(SearchPickerCreateDialog<String>), findsOneWidget);
          expect(
            tester.widget<TextFormField>(_nombreField()).controller!.text,
            'Mantenimiento',
          );
          expect(selected, isNull);
          expect(created, isNull);
          await tester.tap(find.text('Guardar').last);
          await tester.pumpAndSettle();
          expect(created, 'Mantenimiento');
          expect(selected, 'Mantenimiento');
          expect(find.byType(SearchPickerCreateDialog<String>), findsNothing);
          final field = tester.widget<TextFormField>(
            find.byType(TextFormField),
          );
          expect(field.controller!.text, 'Mantenimiento');
          expect(
            tester
                .widget<EditableText>(find.byType(EditableText))
                .focusNode
                .hasFocus,
            isTrue,
          );
          expect(find.byType(AppFormPanel), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('Agregar sigue a coincidencias parciales y no es un valor', (
      tester,
    ) async {
      String? selected;
      await openOverlay(
        tester,
        SearchPickerField<String>(
          label: 'Área solicitante',
          search: (_) async => ['Producción técnica'],
          labelOf: (item) => item,
          onChanged: (item) => selected = item,
          onCreate: (name) async => name,
        ),
      );
      await _escribir(tester, find.byType(TextFormField), 'Producción');
      expect(find.text('Producción técnica'), findsOneWidget);
      expect(find.text('Agregar «Producción»'), findsOneWidget);
      expect(selected, isNull);
    });

    for (final name in [' PRODUCCION   TECNICA ', 'Producción técnica']) {
      testWidgets('coincidencia exacta sin acentos no ofrece Agregar: $name', (
        tester,
      ) async {
        await openOverlay(
          tester,
          SearchPickerField<String>(
            label: 'Área solicitante',
            search: (_) async => ['Producción técnica'],
            labelOf: (item) => item,
            onChanged: (_) {},
            onCreate: (name) async => name,
          ),
        );
        await _escribir(tester, find.byType(TextFormField), name);
        expect(find.text('Producción técnica'), findsOneWidget);
        expect(find.textContaining('Agregar «'), findsNothing);
      });
    }

    testWidgets(
      'sin onCreate conserva Sin coincidencias y Enter no elige centinelas',
      (tester) async {
        String? selected;
        await openOverlay(
          tester,
          SearchPickerField<String>(
            label: 'Área solicitante',
            search: (_) async => [],
            labelOf: (item) => item,
            onChanged: (item) => selected = item,
          ),
        );
        await _escribir(tester, find.byType(TextFormField), 'No existe');
        expect(find.text('Sin coincidencias para «No existe»'), findsOneWidget);
        expect(find.textContaining('Agregar «'), findsNothing);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(selected, isNull);
        expect(find.byType(Dialog), findsNothing);
      },
    );

    testWidgets('un nombre de una letra también permite agregar', (
      tester,
    ) async {
      await openOverlay(
        tester,
        SearchPickerField<String>(
          label: 'Área solicitante',
          search: (_) async => [],
          labelOf: (item) => item,
          onChanged: (_) {},
          onCreate: (name) async => name,
        ),
      );
      await _escribir(tester, find.byType(TextFormField), 'X');
      expect(find.text('Agregar «X»'), findsOneWidget);
    });
  });

  group('diálogo de alta', () {
    for (final escape in [false, true]) {
      testWidgets(
        'sin cambios ${escape ? 'Escape' : 'clic exterior'} cierra directo y regresa foco',
        (tester) async {
          var creates = 0;
          await openOverlay(
            tester,
            SearchPickerField<String>(
              label: 'Área solicitante',
              search: (_) async => [],
              labelOf: (item) => item,
              onChanged: (_) {},
              onCreate: (name) async {
                creates++;
                return name;
              },
            ),
          );
          await _escribir(tester, find.byType(TextFormField), 'Mantenimiento');
          await tester.tap(find.text('Agregar «Mantenimiento»'));
          await tester.pumpAndSettle();
          if (escape) {
            await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          } else {
            await tester.tapAt(const Offset(10, 10));
          }
          await tester.pumpAndSettle();
          expect(find.byType(SearchPickerCreateDialog<String>), findsNothing);
          expect(find.text('Descartar cambios'), findsNothing);
          expect(creates, 0);
          expect(find.byType(AppFormPanel), findsOneWidget);
          expect(
            tester
                .widget<EditableText>(find.byType(EditableText))
                .focusNode
                .hasFocus,
            isTrue,
          );
        },
      );

      testWidgets(
        'nombre modificado pide descartar con ${escape ? 'Escape' : 'clic exterior'}',
        (tester) async {
          await openOverlay(
            tester,
            SearchPickerField<String>(
              label: 'Área solicitante',
              search: (_) async => [],
              labelOf: (item) => item,
              onChanged: (_) {},
              onCreate: (name) async => name,
            ),
          );
          await _escribir(tester, find.byType(TextFormField), 'Mantenimiento');
          await tester.tap(find.text('Agregar «Mantenimiento»'));
          await tester.pumpAndSettle();
          await tester.enterText(_nombreField(), 'Calidad');
          await tester.pump();
          if (escape) {
            await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          } else {
            await tester.tapAt(const Offset(10, 10));
          }
          await tester.pumpAndSettle();
          expect(find.text('Descartar cambios'), findsOneWidget);
          await tester.tap(find.text('Cancelar').last);
          await tester.pumpAndSettle();
          expect(find.byType(SearchPickerCreateDialog<String>), findsOneWidget);
          expect(
            tester.widget<TextFormField>(_nombreField()).controller!.text,
            'Calidad',
          );
          await tester.tap(find.text('Cancelar').last);
          await tester.pumpAndSettle();
          await tester.tap(find.text('Descartar'));
          await tester.pumpAndSettle();
          expect(find.byType(SearchPickerCreateDialog<String>), findsNothing);
          expect(find.byType(AppFormPanel), findsOneWidget);
          expect(
            tester
                .widget<EditableText>(find.byType(EditableText))
                .focusNode
                .hasFocus,
            isTrue,
          );
        },
      );
    }

    testWidgets('fallo queda visible y se puede reintentar sin perder nombre', (
      tester,
    ) async {
      var calls = 0;
      await openOverlay(
        tester,
        SearchPickerField<String>(
          label: 'Área solicitante',
          search: (_) async => [],
          labelOf: (item) => item,
          onChanged: (_) {},
          onCreate: (name) async {
            if (++calls == 1) throw StateError('fallo');
            return name;
          },
        ),
      );
      await _escribir(tester, find.byType(TextFormField), 'Calidad');
      await tester.tap(find.text('Agregar «Calidad»'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar').last);
      await tester.pumpAndSettle();
      expect(find.byType(SearchPickerCreateDialog<String>), findsOneWidget);
      expect(
        find.text('No pudimos completar la solicitud. Inténtalo de nuevo.'),
        findsOneWidget,
      );
      expect(
        tester.widget<TextFormField>(_nombreField()).controller!.text,
        'Calidad',
      );
      await tester.tap(find.text('Guardar').last);
      await tester.pumpAndSettle();
      expect(calls, 2);
      expect(find.byType(SearchPickerCreateDialog<String>), findsNothing);
    });

    testWidgets('no se cierra ni duplica guardado mientras crea', (
      tester,
    ) async {
      final pending = Completer<String>();
      var calls = 0;
      await openOverlay(
        tester,
        SearchPickerField<String>(
          label: 'Área solicitante',
          search: (_) async => [],
          labelOf: (item) => item,
          onChanged: (_) {},
          onCreate: (_) {
            calls++;
            return pending.future;
          },
        ),
      );
      await _escribir(tester, find.byType(TextFormField), 'Calidad');
      await tester.tap(find.text('Agregar «Calidad»'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar').last);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();
      expect(find.byType(SearchPickerCreateDialog<String>), findsOneWidget);
      expect(calls, 1);
      pending.complete('Calidad');
      await tester.pumpAndSettle();
      expect(find.byType(SearchPickerCreateDialog<String>), findsNothing);
    });
  });

  group('área solicitante en requisiciones', () {
    for (final colaborador in [false, true]) {
      testWidgets(
        'catálogo vacío sin texto orienta a ${colaborador ? 'Colaborador' : 'Capital Humano'}',
        (tester) async {
          final repository = FakeRecruitmentRepository()
            ..areasSolicitantesData = [];
          await _abrirRequisicion(tester, repository, colaborador: colaborador);
          await tester.ensureVisible(_areaField());
          await tester.tap(_areaField());
          await pumpDebounce(tester);
          final mensaje = colaborador
              ? 'Todavía no hay áreas registradas. Pídele a Capital Humano que las agregue.'
              : 'Todavía no hay áreas. Escribe un nombre para agregar la primera.';
          expect(find.text(mensaje), findsOneWidget);
          expect(find.text('Sin coincidencias para «»'), findsNothing);
          expect(find.textContaining('Agregar «'), findsNothing);
          expect(repository.areaSearches, ['']);

          await _escribir(tester, _areaField(), 'No existe');
          expect(find.text(mensaje), findsNothing);
          expect(
            find.text(
              colaborador
                  ? 'No está en la lista. Pídele a Capital Humano que la agregue.'
                  : 'Sin coincidencias para «No existe»',
            ),
            findsOneWidget,
          );
          expect(
            find.text('Agregar «No existe»'),
            colaborador ? findsNothing : findsOneWidget,
          );

          await _escribir(tester, _areaField(), '');
          expect(find.text(mensaje), findsOneWidget);
          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('alta con permiso agrega un área y guarda su id', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await pumpRecruitment(
        tester,
        path: '/posiciones',
        repository: repository,
        positions: FakePositionsRepository(),
      );
      await tapTooltip(tester, 'Crear requisición');
      await _agregarArea(tester, 'Mantenimiento');
      await tester.tap(find.text('Guardar').last);
      await tester.pumpAndSettle();
      expect(repository.createdAreaName, 'Mantenimiento');
      expect(
        tester.widget<TextFormField>(_areaField()).controller!.text,
        'Mantenimiento',
      );
      await choose(tester, field: 'Tipo de requisición', option: 'Reemplazo');
      await saveForm(tester);
      expect(repository.savedRequisicion!.areaSolicitante, 99);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Colaborador solo elige y el área sigue opcional', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository();
      await _abrirRequisicion(tester, repository, colaborador: true);
      await tester.ensureVisible(_areaField());
      await tester.tap(_areaField());
      await pumpDebounce(tester);
      expect(repository.areaSearches, ['']);
      expect(find.text('Soldadura'), findsOneWidget);
      await tester.tap(find.text('Soldadura'));
      await tester.pumpAndSettle();
      await _escribir(tester, _areaField(), 'No existe');
      expect(
        find.text(
          'No está en la lista. Pídele a Capital Humano que la agregue.',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('Agregar «'), findsNothing);
      expect(repository.createdAreaName, isNull);
      await tester.tap(find.text('Cancelar').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Nueva requisición').first);
      await tester.pumpAndSettle();
      final posicion = find.descendant(
        of: find.byType(SearchPickerField<PosicionElegible>),
        matching: find.byType(TextFormField),
      );
      await _escribir(tester, posicion, 'ingen');
      await tester.tap(find.text(posicionDos.etiqueta).last);
      await tester.pumpAndSettle();
      await choose(tester, field: 'Tipo de requisición', option: 'Reemplazo');
      await saveForm(tester);
      expect(repository.savedRequisicion!.areaSolicitante, isNull);
    });

    testWidgets('duplicado en alta selecciona existente sin error', (
      tester,
    ) async {
      final repository = FakeRecruitmentRepository()
        ..areasSolicitantesData = []
        ..areaExistente = areaSoldadura;
      await _abrirRequisicion(tester, repository);
      await _agregarArea(tester, 'SOLDADURA');
      await tester.tap(find.text('Guardar').last);
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextFormField>(_areaField()).controller!.text,
        'Soldadura',
      );
      expect(
        find.byType(SearchPickerCreateDialog<AreaSolicitante>),
        findsNothing,
      );
      expect(
        find.text('No pudimos completar la solicitud. Inténtalo de nuevo.'),
        findsNothing,
      );
    });

    testWidgets(
      'edición conserva el área actual y escribir sin elegir la limpia',
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
        expect(
          tester.widget<TextFormField>(_areaField()).controller!.text,
          'Soldadura',
        );
        await saveForm(tester);
        expect(repository.savedRequisicion!.areaSolicitante, areaSoldadura.id);
        await tapTooltip(
          tester,
          'Editar requisición de ${posicionUno.etiqueta}',
        );
        await _escribir(tester, _areaField(), 'Texto sin seleccionar');
        await saveForm(tester);
        expect(repository.savedRequisicion!.areaSolicitante, isNull);
      },
    );

    testWidgets(
      'lista y detalle muestran el nombre y búsqueda sigue en el servidor',
      (tester) async {
        final repository = FakeRecruitmentRepository();
        final router = await pumpRecruitment(
          tester,
          path: '/reclutamiento',
          repository: repository,
        );
        expect(find.textContaining('Reemplazo · Soldadura'), findsOneWidget);
        await tester.enterText(find.byType(TextField).first, 'Soldadura');
        await pumpDebounce(tester);
        expect(repository.lastRequisicionesQuery.search, 'Soldadura');
        router.go('/reclutamiento/requisiciones/r1');
        await tester.pumpAndSettle();
        expect(find.text('Soldadura'), findsOneWidget);
        expect(find.text('Área solicitante'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('no se ofrecen áreas inactivas', (tester) async {
      final repository = FakeRecruitmentRepository()
        ..areasSolicitantesData = [
          areaSoldadura.copyWith(isActive: false),
          areaMaquinados,
        ];
      await _abrirRequisicion(tester, repository);
      await tester.ensureVisible(_areaField());
      await tester.tap(_areaField());
      await pumpDebounce(tester);
      expect(find.text('Maquinados'), findsOneWidget);
      expect(find.text('Soldadura'), findsNothing);
    });
  });
}
