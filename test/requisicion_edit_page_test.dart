import 'dart:async';

import 'package:capital_humano_front/core/network/api_page.dart';
import 'package:capital_humano_front/core/network/table_query.dart';
import 'package:capital_humano_front/core/widgets/app_button.dart';
import 'package:capital_humano_front/core/widgets/search_picker_field.dart';
import 'package:capital_humano_front/features/recruitment/application/recruitment_controller.dart';
import 'package:capital_humano_front/features/recruitment/data/recruitment_models.dart';
import 'package:capital_humano_front/features/recruitment/presentation/posicion_contexto_card.dart';
import 'package:capital_humano_front/features/recruitment/presentation/requisicion_edit_page.dart';
import 'package:capital_humano_front/features/recruitment/presentation/requisiciones_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'recruitment_fixtures.dart';
import 'recruitment_harness.dart';
import 'test_session.dart';

class _Repository extends FakeRecruitmentRepository {
  Object? saveError;
  Completer<void>? pending;
  int attempts = 0;
  int lastPage = 0;

  @override
  Future<Requisicion> saveRequisicion(
    Requisicion r, {
    required bool creating,
  }) async {
    attempts++;
    if (pending != null) await pending!.future;
    if (saveError != null) throw saveError!;
    return super.saveRequisicion(r, creating: creating);
  }

  @override
  Future<ApiPage<Requisicion>> requisiciones(
    int page, {
    TableQuery query = const TableQuery(),
  }) async {
    lastPage = page;
    return super.requisiciones(page, query: query);
  }
}

DioException _badRequest(Map<String, Object> fields) => DioException(
  requestOptions: RequestOptions(path: '/requisiciones'),
  type: DioExceptionType.badResponse,
  response: Response(
    requestOptions: RequestOptions(path: '/requisiciones'),
    statusCode: 400,
    data: fields,
  ),
);

Finder _area() => find.descendant(
  of: find.byType(SearchPickerField<AreaSolicitante>),
  matching: find.byType(TextFormField),
);
Finder _textField(String label) => find.widgetWithText(TextFormField, label);
Finder _chip(String label) => find.widgetWithText(ChoiceChip, label);
Future<void> _section(WidgetTester tester, String name) async {
  await tester.ensureVisible(_chip(name));
  await tester.tap(_chip(name));
  await tester.pumpAndSettle();
}

Future<void> _enter(WidgetTester tester, Finder field, String value) async {
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
  await tester.pumpAndSettle();
}

String get _justification =>
    'Justificación de la requisición (obligatoria para este tipo)';

void main() {
  testWidgets('nueva y nueva?posicion son páginas; contexto deriva posición', (
    tester,
  ) async {
    final repo = _Repository();
    final router = await pumpRecruitment(
      tester,
      path: '/reclutamiento/requisiciones/nueva?posicion=pos1',
      repository: repo,
    );
    expect(find.byType(RequisicionEditPage), findsOneWidget);
    expect(find.byType(PosicionContextoCard), findsOneWidget);
    expect(find.byType(SearchPickerField<PosicionElegible>), findsNothing);
    expect(repo.contextoRequests, [('pos1', 'requisicion')]);
    expect(
      router.routeInformationProvider.value.uri.queryParameters['posicion'],
      'pos1',
    );
    router.go('/reclutamiento/requisiciones/nueva');
    await tester.pumpAndSettle();
    expect(find.byType(SearchPickerField<PosicionElegible>), findsOneWidget);
    expect(find.byType(PosicionContextoCard), findsNothing);
  });

  testWidgets(
    'secciones mantienen un Form y revisión muestra nombres y aviso',
    (tester) async {
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/nueva?posicion=pos1',
        repository: _Repository(),
      );
      await choose(
        tester,
        field: 'Tipo de requisición',
        option: 'Nueva Posición',
      );
      await _section(tester, 'Condiciones');
      await _enter(tester, _textField('Idiomas requeridos'), 'Inglés');
      await _section(tester, 'Compensación');
      await _enter(tester, _textField('Nivel de tabulador'), 'N2');
      await _section(tester, 'Revisión');
      expect(find.text('Idiomas requeridos: Inglés'), findsOneWidget);
      expect(find.text('Nivel de tabulador: N2'), findsOneWidget);
      expect(find.text('Tipo de requisición: Nueva Posición'), findsOneWidget);
      expect(
        find.text('Falta la justificación para enviar a autorización.'),
        findsOneWidget,
      );
      expect(find.byType(Form), findsOneWidget);
      expect(tester.widget<ChoiceChip>(_chip('Revisión')).selected, isTrue);
      await tester.ensureVisible(find.text('Ir a Solicitud'));
      await tester.tap(find.text('Ir a Solicitud'));
      await tester.pumpAndSettle();
      expect(tester.widget<ChoiceChip>(_chip('Solicitud')).selected, isTrue);
      await _enter(tester, _textField(_justification), 'Necesaria');
      await _section(tester, 'Revisión');
      expect(find.text('Justificación: Necesaria'), findsOneWidget);
      expect(find.text('Ir a Solicitud'), findsNothing);
    },
  );

  testWidgets(
    'borrador parcial sin justificación pasa a editar y queda limpio',
    (tester) async {
      final repo = _Repository();
      final router = await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/nueva?posicion=pos1',
        repository: repo,
      );
      await choose(
        tester,
        field: 'Tipo de requisición',
        option: 'Nueva Posición',
      );
      await saveForm(tester, label: 'Guardar borrador');
      expect(repo.savedRequisicion!.justificacion, isEmpty);
      expect(repo.savedRequisicion!.estado, estadoBorrador.id);
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/requisiciones/r-nueva/editar',
      );
      expect(find.text('Editar requisición'), findsOneWidget);
      expect(find.text('Requisición guardada.'), findsOneWidget);
      await tester.tap(find.text('Volver'));
      await tester.pumpAndSettle();
      expect(find.text('¿Descartar cambios?'), findsNothing);
    },
  );

  testWidgets(
    'enviar 400 enfoca justificación y vuelve de Revisión a Solicitud',
    (tester) async {
      final repo = _Repository()
        ..saveError = _badRequest({
          'justificacion': ['Este tipo de Requisición exige justificación.'],
        });
      final router = await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/nueva?posicion=pos1',
        repository: repo,
      );
      await choose(
        tester,
        field: 'Tipo de requisición',
        option: 'Nueva Posición',
      );
      await _section(tester, 'Revisión');
      await saveForm(tester, label: 'Enviar a autorización');
      expect(
        find.text('Este tipo de Requisición exige justificación.'),
        findsOneWidget,
      );
      expect(tester.widget<ChoiceChip>(_chip('Solicitud')).selected, isTrue);
      final editable = tester.widget<EditableText>(
        find.descendant(
          of: _textField(_justification),
          matching: find.byType(EditableText),
        ),
      );
      expect(editable.focusNode.hasFocus, isTrue);
      expect(repo.savedRequisicion, isNull);
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/requisiciones/nueva',
      );
      expect(find.text('Requisición enviada.'), findsNothing);
      repo.saveError = null;
      await _enter(
        tester,
        _textField(_justification),
        'Justificación completa',
      );
      await saveForm(tester, label: 'Enviar a autorización');
      expect(repo.savedRequisicion!.estado, estadoPendiente.id);
      expect(
        router.routeInformationProvider.value.uri.path,
        '/reclutamiento/requisiciones/r-nueva',
      );
    },
  );

  testWidgets('el error de un campo del servidor se quita al corregirlo', (
    tester,
  ) async {
    final repo = _Repository();
    await pumpRecruitment(
      tester,
      path: '/reclutamiento/requisiciones/r1/editar',
      repository: repo,
    );
    repo.saveError = _badRequest({
      'idiomas_requeridos': ['Idioma inválido.'],
    });
    await _section(tester, 'Revisión');
    await saveForm(tester);
    expect(find.text('Idioma inválido.'), findsOneWidget);
    await _enter(tester, _textField('Idiomas requeridos'), 'Inglés');
    expect(find.text('Idioma inválido.'), findsNothing);
  });

  testWidgets('el error de tipo se quita al elegir el tipo', (tester) async {
    await pumpRecruitment(
      tester,
      path: '/reclutamiento/requisiciones/nueva?posicion=pos1',
      repository: _Repository(),
    );
    await saveForm(tester, label: 'Guardar borrador');
    expect(find.text('Elige el tipo.'), findsWidgets);
    await choose(
      tester,
      field: 'Tipo de requisición',
      option: 'Nueva Posición',
    );
    expect(find.text('Elige el tipo.'), findsNothing);
  });

  testWidgets('400 de campos y error general se muestran sin perder datos', (
    tester,
  ) async {
    final repo = _Repository();
    await pumpRecruitment(
      tester,
      path: '/reclutamiento/requisiciones/r1/editar',
      repository: repo,
    );
    repo.saveError = _badRequest({
      'idiomas_requeridos': ['Idioma inválido.'],
      'non_field_errors': ['Revisa la solicitud.'],
    });
    await _section(tester, 'Revisión');
    await saveForm(tester);
    expect(find.text('Idioma inválido.'), findsOneWidget);
    expect(find.text('Revisa la solicitud.'), findsOneWidget);
    expect(tester.widget<ChoiceChip>(_chip('Condiciones')).selected, isTrue);
    expect(
      tester
          .widget<TextFormField>(_textField('Idiomas requeridos'))
          .controller!
          .text,
      requisicionPropia.idiomasRequeridos,
    );
  });

  testWidgets('no borrador conserva estado y datos de suspensión', (
    tester,
  ) async {
    final repo = _Repository()
      ..requisicionesData = [
        requisicionPropia.copyWith(
          motivoSuspension: 'Motivo anterior',
          fechaSuspension: '2026-09-01',
          autorizadoPorSuspension: 'Dirección',
        ),
      ];
    await pumpRecruitment(
      tester,
      path: '/reclutamiento/requisiciones/r1/editar',
      repository: repo,
    );
    expect(find.text('Guardar cambios'), findsOneWidget);
    expect(find.text('Enviar a autorización'), findsNothing);
    expect(find.text('Estado'), findsNothing);
    expect(find.text('Motivo de la suspensión'), findsNothing);
    await saveForm(tester);
    expect(repo.savedRequisicion!.estado, requisicionPropia.estado);
    expect(repo.savedRequisicion!.motivoSuspension, 'Motivo anterior');
    expect(repo.savedRequisicion!.fechaSuspension, '2026-09-01');
    expect(repo.savedRequisicion!.autorizadoPorSuspension, 'Dirección');
  });

  testWidgets('edición ajena redirige al detalle con aviso', (tester) async {
    final router = await pumpRecruitment(
      tester,
      path: '/reclutamiento/requisiciones/r1/editar',
      repository: _Repository(),
      user: testColaborador,
    );
    expect(
      router.routeInformationProvider.value.uri.path,
      '/reclutamiento/requisiciones/r1',
    );
    expect(find.text('No puedes editar esta requisición.'), findsOneWidget);
    expect(find.byType(RequisicionEditPage), findsNothing);
  });

  testWidgets(
    'área sugerida vacía se aplica, puede quitarse y no vuelve sola',
    (tester) async {
      final repo = _Repository();
      repo.contextos[('pos1', 'requisicion')] = contextoUno.copyWith(
        areaSolicitanteSugerida: areaSoldadura,
      );
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/nueva?posicion=pos1',
        repository: repo,
      );
      expect(
        tester.widget<TextFormField>(_area()).controller!.text,
        'Soldadura',
      );
      expect(
        find.text('Sugerida a partir del área de la posición.'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Quitar área'));
      await tester.tap(find.text('Quitar área'));
      await tester.pumpAndSettle();
      expect(tester.widget<TextFormField>(_area()).controller!.text, isEmpty);
      await _section(tester, 'Revisión');
      await _section(tester, 'Solicitud');
      expect(tester.widget<TextFormField>(_area()).controller!.text, isEmpty);
    },
  );

  testWidgets('posición elegida aplica sugerencia sin inventar catálogo', (
    tester,
  ) async {
    final repo = _Repository();
    repo.contextos[('pos2', 'requisicion')] = contextoDos.copyWith(
      areaSolicitanteSugerida: areaMaquinados,
    );
    await pumpRecruitment(
      tester,
      path: '/reclutamiento/requisiciones/nueva',
      repository: repo,
    );
    final position = find.descendant(
      of: find.byType(SearchPickerField<PosicionElegible>),
      matching: find.byType(TextFormField),
    );
    await tester.tap(position);
    await pumpDebounce(tester);
    await tester.tap(find.text(posicionDos.etiqueta).last);
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextFormField>(_area()).controller!.text,
      'Maquinados',
    );
    expect(repo.createdAreaName, isNull);
  });

  testWidgets('sugerencia tardía no pisa elección del usuario', (tester) async {
    final repo = _Repository();
    final pending = Completer<PosicionContexto>();
    repo.contextoLoader = (_, _) => pending.future;
    await pumpRecruitment(
      tester,
      path: '/reclutamiento/requisiciones/nueva?posicion=pos1',
      repository: repo,
    );
    await tester.ensureVisible(_area());
    await tester.tap(_area());
    await pumpDebounce(tester);
    await tester.tap(find.text('Maquinados').last);
    await tester.pumpAndSettle();
    pending.complete(
      contextoUno.copyWith(areaSolicitanteSugerida: areaSoldadura),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextFormField>(_area()).controller!.text,
      'Maquinados',
    );
  });

  testWidgets('sugerencia no pisa edición ni campo vacío de edición', (
    tester,
  ) async {
    for (final area in [areaMaquinados.id, null]) {
      final repo = _Repository()
        ..requisicionesData = [
          requisicionPropia.copyWith(
            areaSolicitante: area,
            areaSolicitanteNombre: area == null ? null : 'Maquinados',
          ),
        ];
      repo.contextos[('pos1', 'requisicion')] = contextoUno.copyWith(
        areaSolicitanteSugerida: areaSoldadura,
      );
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/r1/editar',
        repository: repo,
      );
      expect(
        tester.widget<TextFormField>(_area()).controller!.text,
        area == null ? '' : 'Maquinados',
      );
      expect(
        find.text('Sugerida a partir del área de la posición.'),
        findsNothing,
      );
    }
  });

  testWidgets('sin sugerencia queda vacío y puede elegir desde lista', (
    tester,
  ) async {
    await pumpRecruitment(
      tester,
      path: '/reclutamiento/requisiciones/nueva?posicion=pos1',
      repository: _Repository(),
    );
    expect(tester.widget<TextFormField>(_area()).controller!.text, isEmpty);
    await tester.ensureVisible(_area());
    await tester.tap(_area());
    await pumpDebounce(tester);
    expect(find.text('Soldadura'), findsOneWidget);
  });

  testWidgets(
    'sin cambios Volver sale; editar y revertir también sale directo',
    (tester) async {
      for (final revert in [false, true]) {
        final router = await pumpRecruitment(
          tester,
          path: '/reclutamiento/requisiciones/nueva',
          repository: _Repository(),
        );
        if (revert) {
          final justification = _textField(
            'Justificación de la requisición (opcional)',
          );
          await _enter(tester, justification, 'Cambio');
          await _enter(tester, justification, '');
        }
        await tester.tap(find.text('Volver'));
        await tester.pumpAndSettle();
        expect(find.text('¿Descartar cambios?'), findsNothing);
        expect(
          router.routeInformationProvider.value.uri.path,
          '/reclutamiento',
        );
      }
    },
  );

  testWidgets(
    'Volver y navegación interna protegen; seguir conserva y descartar sale',
    (tester) async {
      final router = await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/nueva',
        repository: _Repository(),
      );
      await _enter(
        tester,
        _textField('Justificación de la requisición (opcional)'),
        'Cambio',
      );
      await tester.tap(find.text('Volver'));
      await tester.pumpAndSettle();
      expect(find.text('¿Descartar cambios?'), findsOneWidget);
      await tester.tap(find.text('Seguir editando'));
      await tester.pumpAndSettle();
      expect(
        tester
            .widget<TextFormField>(
              _textField('Justificación de la requisición (opcional)'),
            )
            .controller!
            .text,
        'Cambio',
      );
      router.go('/reclutamiento');
      await tester.pumpAndSettle();
      expect(find.text('¿Descartar cambios?'), findsOneWidget);
      await tester.tap(find.text('Descartar'));
      await tester.pumpAndSettle();
      expect(router.routeInformationProvider.value.uri.path, '/reclutamiento');
      expect(find.byType(RequisicionEditPage), findsNothing);
    },
  );

  testWidgets('atrás del sistema pide descartar una página con cambios', (
    tester,
  ) async {
    final router = await pumpRecruitment(
      tester,
      path: '/reclutamiento',
      repository: _Repository(),
    );
    unawaited(router.push<void>('/reclutamiento/requisiciones/nueva'));
    await tester.pumpAndSettle();
    await _enter(
      tester,
      _textField('Justificación de la requisición (opcional)'),
      'Cambio',
    );
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('¿Descartar cambios?'), findsOneWidget);
    await tester.tap(find.text('Descartar'));
    await tester.pumpAndSettle();
    expect(find.byType(RequisicionEditPage), findsNothing);
  });

  testWidgets(
    'respuesta pendiente deshabilita acciones y no anuncia guardado',
    (tester) async {
      final repo = _Repository();
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/r1/editar',
        repository: repo,
      );
      repo.pending = Completer<void>();
      await tester.tap(find.text('Guardar cambios'));
      await tester.pump();
      expect(repo.attempts, 1);
      expect(find.text('Requisición guardada.'), findsNothing);
      expect(
        tester
            .widget<AppButton>(
              find.widgetWithText(AppButton, 'Guardar cambios'),
            )
            .isLoading,
        isTrue,
      );
      final back = tester.widget<TextButton>(
        find.widgetWithText(TextButton, 'Volver'),
      );
      expect(back.onPressed, isNull);
      repo.pending!.complete();
      await tester.pumpAndSettle();
      expect(find.text('Requisición guardada.'), findsOneWidget);
    },
  );

  testWidgets(
    '320 px, teclado y movimiento reducido conservan campos y acciones',
    (tester) async {
      tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await pumpRecruitment(
        tester,
        path: '/reclutamiento/requisiciones/nueva?posicion=pos1',
        repository: _Repository(),
        width: 320,
        height: 800,
      );
      expect(
        MediaQuery.disableAnimationsOf(
          tester.element(find.byType(RequisicionEditPage)),
        ),
        isTrue,
      );
      expect(tester.takeException(), isNull);
      await _section(tester, 'Condiciones');
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      expect(FocusManager.instance.primaryFocus?.hasFocus, isTrue);
      final reachedSections = <String>{};
      final reachedActions = <String>{};
      for (var i = 0; i < 90; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        final focused = FocusManager.instance.primaryFocus?.context;
        if (focused is Element) {
          focused.visitAncestorElements((element) {
            final widget = element.widget;
            if (widget is ChoiceChip && widget.label is Text) {
              reachedSections.add((widget.label as Text).data!);
            }
            if (widget is AppButton) reachedActions.add(widget.label);
            return true;
          });
        }
        if (reachedSections.length == 4 && reachedActions.length == 2) break;
      }
      expect(
        reachedSections,
        containsAll(['Solicitud', 'Condiciones', 'Compensación', 'Revisión']),
      );
      expect(
        reachedActions,
        containsAll(['Guardar borrador', 'Enviar a autorización']),
      );
      await _section(tester, 'Revisión');
      expect(tester.widget<ChoiceChip>(_chip('Revisión')).selected, isTrue);
      expect(
        tester
            .getRect(find.widgetWithText(AppButton, 'Guardar borrador'))
            .bottom,
        lessThanOrEqualTo(800),
      );
      expect(
        tester
            .getRect(find.widgetWithText(AppButton, 'Enviar a autorización'))
            .right,
        lessThanOrEqualTo(320),
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'lista conserva consulta, página y desplazamiento al volver de detalle y edición',
    (tester) async {
      final repo = _Repository()
        ..requisicionesData = List.generate(
          25,
          (i) => requisicionPropia.copyWith(id: 'r$i'),
        );
      final router = await pumpRecruitment(
        tester,
        path: '/reclutamiento',
        repository: repo,
        height: 700,
      );
      final container = ProviderScope.containerOf(
        tester.element(find.byType(RequisicionesPage)),
      );
      const query = TableQuery(
        search: 'sold',
        ordering: '-fecha_solicitud',
        filters: {'estado': '2', 'tipo': '40'},
      );
      final controller = container.read(
        requisicionesListStateProvider.notifier,
      );
      controller.apply(query);
      controller.page(2);
      await tester.pumpAndSettle();
      final scroll = tester
          .widget<PrimaryScrollController>(
            find
                .descendant(
                  of: find.byType(RequisicionesPage),
                  matching: find.byType(PrimaryScrollController),
                )
                .first,
          )
          .controller!;
      scroll.jumpTo(460);
      await tester.pumpAndSettle();
      expect(
        container.read(requisicionesListStateProvider).offset,
        closeTo(460, .1),
      );
      for (final target in [
        '/reclutamiento/requisiciones/r1',
        '/reclutamiento/requisiciones/r1/editar',
      ]) {
        router.go(target);
        await tester.pumpAndSettle();
        router.go('/reclutamiento');
        await tester.pumpAndSettle();
        final state = container.read(requisicionesListStateProvider);
        expect(state.query, query);
        expect(state.page, 2);
        expect(state.offset, closeTo(460, .1));
        expect(repo.lastPage, 3);
        expect(repo.lastRequisicionesQuery, query);
        final primary = tester.widget<PrimaryScrollController>(
          find
              .descendant(
                of: find.byType(RequisicionesPage),
                matching: find.byType(PrimaryScrollController),
              )
              .first,
        );
        expect(primary.controller!.offset, closeTo(460, .1));
      }
    },
  );

  test('contexto deserializa sugerencia opcional del catálogo existente', () {
    final json = contextoUno.toJson();
    json['area_solicitante_sugerida'] = {
      'id': areaSoldadura.id,
      'name': 'Soldadura',
    };
    expect(
      PosicionContexto.fromJson(json).areaSolicitanteSugerida?.id,
      areaSoldadura.id,
    );
    json['area_solicitante_sugerida'] = null;
    expect(PosicionContexto.fromJson(json).areaSolicitanteSugerida, isNull);
  });
}
