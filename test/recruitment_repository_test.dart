// Lo que las pantallas de Reclutamiento mandan de verdad al servidor, y las
// piezas compartidas que estrenan (filtros de TableQuery, nombre del archivo
// descargado).
import 'package:capital_humano_front/core/files/file_saver.dart';
import 'package:capital_humano_front/core/network/table_query.dart';
import 'package:capital_humano_front/features/recruitment/data/recruitment_models.dart';
import 'package:capital_humano_front/features/recruitment/data/recruitment_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'recruitment_fixtures.dart';
import 'session_service_test.dart' show client, response;

DioException _http(int code, Object? data) => DioException(
  requestOptions: RequestOptions(path: '/x'),
  response: Response(
    requestOptions: RequestOptions(path: '/x'),
    statusCode: code,
    data: data,
  ),
  type: DioExceptionType.badResponse,
);

void main() {
  group('TableQuery con filtros', () {
    test('los filtros vacíos no se mandan y los demás sí', () {
      const query = TableQuery(
        search: 'sold',
        ordering: '-fecha',
        filters: {'estado': '3', 'tipo': ''},
      );
      expect(query.params, {
        'estado': '3',
        'search': 'sold',
        'ordering': '-fecha',
      });
    });

    test('igualdad por contenido, sin importar el orden de los filtros', () {
      const a = TableQuery(filters: {'estado': '3', 'tipo': '1'});
      const b = TableQuery(filters: {'tipo': '1', 'estado': '3'});
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(
        a == const TableQuery(filters: {'estado': '4', 'tipo': '1'}),
        isFalse,
      );
    });

    test('withFilter pone, cambia y quita un filtro sin tocar los demás', () {
      final puesto = const TableQuery(search: 'x').withFilter('estado', '3');
      expect(puesto.filters, {'estado': '3'});
      expect(puesto.search, 'x');
      expect(puesto.withFilter('tipo', '1').filters, {
        'estado': '3',
        'tipo': '1',
      });
      expect(puesto.withFilter('estado', '5').filters, {'estado': '5'});
      expect(puesto.withFilter('estado', '').filters, isEmpty);
    });

    test('copyWith conserva los filtros', () {
      final query = const TableQuery(filters: {'estado': '3'})
          .copyWith(search: 'a');
      expect(query.filters, {'estado': '3'});
    });
  });

  group('nombre del archivo descargado', () {
    test('lee el nombre simple, con o sin comillas', () {
      expect(
        filenameFromContentDisposition(
          'attachment; filename="Requisicion.xlsx"',
          fallback: 'x',
        ),
        'Requisicion.xlsx',
      );
      expect(
        filenameFromContentDisposition(
          'attachment; filename=Requisicion.xlsx',
          fallback: 'x',
        ),
        'Requisicion.xlsx',
      );
    });

    test('lee el nombre con acentos (filename*) y lo prefiere', () {
      expect(
        filenameFromContentDisposition(
          "attachment; filename=\"Requisicion.xlsx\"; filename*=utf-8''Requisici%C3%B3n%20de%20Personal.xlsx",
          fallback: 'x',
        ),
        'Requisición de Personal.xlsx',
      );
    });

    test('sin encabezado, vacío o ilegible usa el nombre de respaldo', () {
      expect(
        filenameFromContentDisposition(null, fallback: 'R.xlsx'),
        'R.xlsx',
      );
      expect(filenameFromContentDisposition('', fallback: 'R.xlsx'), 'R.xlsx');
      expect(
        filenameFromContentDisposition('attachment', fallback: 'R.xlsx'),
        'R.xlsx',
      );
    });

    test('nunca deja una ruta en el nombre', () {
      expect(
        filenameFromContentDisposition(
          'attachment; filename="../../etc/passwd"',
          fallback: 'x',
        ),
        'passwd',
      );
    });
  });

  group('importes', () {
    test('decimalOrNull limpia lo que escribe una persona', () {
      expect(decimalOrNull(r'$12,500.5'), '12500.5');
      expect(decimalOrNull(' 8 000 '), '8000');
      expect(decimalOrNull(''), isNull);
      expect(decimalOrNull('   '), isNull);
      expect(decimalOrNull(null), isNull);
    });
  });

  group('RecruitmentRepository: requisiciones', () {
    test('lista con búsqueda, orden y filtros del servidor', () async {
      final repository = RecruitmentRepository(
        client((request) {
          expect(request.path, 'recruitment/requisiciones/');
          expect(request.queryParameters, {
            'page': 2,
            'page_size': 25,
            'estado': '3',
            'search': 'sold',
            'ordering': '-fecha_solicitud',
          });
          return response({'count': 0, 'results': []});
        }),
      );
      await repository.requisiciones(
        2,
        query: const TableQuery(
          search: 'sold',
          ordering: '-fecha_solicitud',
          filters: {'estado': '3'},
        ),
      );
    });

    test('al crear manda la posición; limpia importes y vacíos', () async {
      final repository = RecruitmentRepository(
        client((request) {
          expect(request.method, 'POST');
          expect(request.path, 'recruitment/requisiciones/');
          final data = request.data as Map<String, dynamic>;
          expect(data['posicion'], 'pos1');
          expect(data['tipo'], 40);
          expect(data['estado'], 1);
          expect(data['fecha_solicitud'], '2026-10-05');
          expect(data['area_solicitante'], 'Soldadura');
          expect(data['sueldo_mensual_bruto'], '12500.5');
          expect(data['sueldo_mensual_neto'], isNull);
          expect(data['fecha_a_cubrir_vacante'], isNull);
          expect(data['disposicion_viajar'], isNull);
          return response(requisicionPropia.toJson(), status: 201);
        }),
      );
      await repository.saveRequisicion(
        const Requisicion(
          id: '',
          posicion: 'pos1',
          tipo: 40,
          estado: 1,
          fechaSolicitud: '2026-10-05',
          areaSolicitante: '  Soldadura ',
          sueldoMensualBruto: r'$12,500.5',
          sueldoMensualNeto: '   ',
        ),
        creating: true,
      );
    });

    test('al editar NO manda la posición y hace PATCH', () async {
      final repository = RecruitmentRepository(
        client((request) {
          expect(request.method, 'PATCH');
          expect(request.path, 'recruitment/requisiciones/r1/');
          expect((request.data as Map).containsKey('posicion'), isFalse);
          return response(requisicionPropia.toJson());
        }),
      );
      await repository.saveRequisicion(requisicionPropia, creating: false);
    });

    test('lee los importes y las aprobaciones que manda el servidor', () async {
      final repository = RecruitmentRepository(
        client(
          (request) => response({
            'id': 'r1',
            'posicion': 'pos1',
            'posicion_etiqueta': 'Operador — PAILERIA',
            'tipo': 40,
            'estado': 2,
            'creado_por': 'u1',
            'solicitante': null,
            'fecha_solicitud': '2026-09-10',
            'sueldo_mensual_bruto': '12500.00',
            'disposicion_viajar': null,
            'aprobaciones': [
              {
                'id': 'a1',
                'requisicion': 'r1',
                'etapa': 10,
                'fecha': '2026-09-12',
                'usuario': null,
                'nombre_manual': 'Luis',
              },
            ],
          }),
        ),
      );
      final r = await repository.requisicion('r1');
      expect(r.sueldoMensualBruto, '12500.00');
      expect(r.solicitante, isNull);
      expect(r.disposicionViajar, isNull);
      expect(r.aprobaciones.single.nombreManual, 'Luis');
      expect(r.tieneDatosDeSuspension, isFalse);
    });

    test('exportarExcel pide bytes y toma el nombre del servidor', () async {
      final repository = RecruitmentRepository(
        client((request) {
          expect(request.path, 'recruitment/requisiciones/r1/exportar-excel/');
          expect(request.responseType, ResponseType.bytes);
          return ResponseBody.fromBytes(
            [10, 20, 30],
            200,
            headers: {
              'content-disposition': [
                "attachment; filename*=utf-8''Requisici%C3%B3n.xlsx",
              ],
            },
          );
        }),
      );
      final file = await repository.exportarExcel('r1');
      expect(file.name, 'Requisición.xlsx');
      expect(file.bytes, [10, 20, 30]);
      expect(file.mimeType, contains('spreadsheetml'));
    });

    test('exportarExcel sin encabezado usa un nombre de respaldo', () async {
      final repository = RecruitmentRepository(
        client((request) => ResponseBody.fromBytes([1], 200)),
      );
      expect((await repository.exportarExcel('r1')).name, 'Requisicion.xlsx');
    });

    test('borrar hace DELETE', () async {
      final repository = RecruitmentRepository(
        client((request) {
          expect(request.method, 'DELETE');
          expect(request.path, 'recruitment/requisiciones/r1/');
          return response(null, status: 204);
        }),
      );
      await repository.deleteRequisicion('r1');
    });
  });

  group('RecruitmentRepository: aprobaciones y conformidades', () {
    test(
      'una aprobación nueva manda requisición, etapa, fecha y quién',
      () async {
        final repository = RecruitmentRepository(
          client((request) {
            expect(request.method, 'POST');
            expect(request.path, 'recruitment/aprobaciones/');
            expect(request.data, {
              'requisicion': 'r1',
              'etapa': 13,
              'fecha': '2026-10-05',
              'usuario': null,
              'nombre_manual': 'Luis Pérez',
            });
            return response({}, status: 201);
          }),
        );
        await repository.saveAprobacion(
          const Aprobacion(
            id: '',
            requisicion: 'r1',
            etapa: 13,
            fecha: '2026-10-05',
            nombreManual: ' Luis Pérez ',
          ),
          creating: true,
        );
      },
    );

    test('corregir una aprobación no manda requisición ni etapa', () async {
      final repository = RecruitmentRepository(
        client((request) {
          expect(request.method, 'PATCH');
          expect(request.path, 'recruitment/aprobaciones/a1/');
          expect(request.data, {
            'fecha': '2026-10-06',
            'usuario': 'u1',
            'nombre_manual': '',
          });
          return response({});
        }),
      );
      await repository.saveAprobacion(
        const Aprobacion(
          id: 'a1',
          requisicion: 'r1',
          etapa: 13,
          fecha: '2026-10-06',
          usuario: 'u1',
        ),
        creating: false,
      );
    });

    test('quitar una aprobación hace DELETE', () async {
      final repository = RecruitmentRepository(
        client((request) {
          expect(request.method, 'DELETE');
          expect(request.path, 'recruitment/aprobaciones/a1/');
          return response(null, status: 204);
        }),
      );
      await repository.deleteAprobacion('a1');
    });

    test(
      'una conformidad nueva manda descriptivo, rol, persona y fecha',
      () async {
        final repository = RecruitmentRepository(
          client((request) {
            expect(request.method, 'POST');
            expect(request.path, 'recruitment/conformidades-descriptivo/');
            expect(request.data, {
              'descriptivo': 'd2',
              'rol': 90,
              'persona': 'p1',
              'fecha': '2026-10-05',
              'usuario': null,
              'nombre_manual': '',
            });
            return response({}, status: 201);
          }),
        );
        await repository.saveConformidad(
          const Conformidad(
            id: '',
            descriptivo: 'd2',
            rol: 90,
            persona: 'p1',
            fecha: '2026-10-05',
          ),
          creating: true,
        );
      },
    );

    test('corregir y quitar una conformidad usan PATCH y DELETE', () async {
      final seen = <String>[];
      final repository = RecruitmentRepository(
        client((request) {
          seen.add('${request.method} ${request.path}');
          if (request.method == 'PATCH') {
            expect((request.data as Map).containsKey('descriptivo'), isFalse);
            expect((request.data as Map).containsKey('rol'), isFalse);
          }
          return response(null, status: request.method == 'DELETE' ? 204 : 200);
        }),
      );
      await repository.saveConformidad(
        const Conformidad(
          id: 'c1',
          descriptivo: 'd2',
          rol: 91,
          fecha: '2026-10-05',
        ),
        creating: false,
      );
      await repository.deleteConformidad('c1');
      expect(seen, [
        'PATCH recruitment/conformidades-descriptivo/c1/',
        'DELETE recruitment/conformidades-descriptivo/c1/',
      ]);
    });
  });

  group('RecruitmentRepository: descriptivos', () {
    test(
      'guardar manda todo, sin renglones vacíos y con las casillas ordenadas',
      () async {
        final repository = RecruitmentRepository(
          client((request) {
            expect(request.method, 'PATCH');
            expect(request.path, 'recruitment/descriptivos/d1/');
            final data = request.data as Map<String, dynamic>;
            expect(data.containsKey('posicion'), isFalse);
            expect(data['nombre_puesto'], 'Operador');
            expect(data['fecha_elaboracion'], '2026-09-20');
            expect(data['competencias'], [70, 71]);
            expect(data['recursos'], <int>[]);
            expect(data['funciones'], [
              {'texto': 'Soldar'},
              {'texto': 'Limpiar'},
            ]);
            expect(data['indicadores'], <Object>[]);
            expect(data['disponibilidad_viajar'], isNull);
            return response(descriptivoBorrador.toJson());
          }),
        );
        await repository.saveDescriptivo(
          descriptivoBorrador.copyWith(
            nombrePuesto: '  Operador ',
            competencias: [70, 71],
            funciones: const [
              TextoNumerado(orden: 1, texto: ' Soldar '),
              TextoNumerado(orden: 2, texto: '   '),
              TextoNumerado(orden: 3, texto: 'Limpiar'),
            ],
            indicadores: const [TextoNumerado(orden: 1, texto: '')],
          ),
        );
      },
    );

    test('crear borrador, congelar y copiar usan sus acciones', () async {
      final seen = <String>[];
      final repository = RecruitmentRepository(
        client((request) {
          seen.add('${request.method} ${request.path}');
          if (request.path.endsWith('crear-borrador/')) {
            expect(request.data, {'posicion': 'pos1'});
          }
          return response(descriptivoBorrador.toJson(), status: 201);
        }),
      );
      await repository.crearBorrador('pos1');
      await repository.congelar('d1');
      await repository.copiar('d2');
      expect(seen, [
        'POST recruitment/descriptivos/crear-borrador/',
        'POST recruitment/descriptivos/d1/congelar/',
        'POST recruitment/descriptivos/d2/copiar/',
      ]);
    });

    test('lee el descriptivo completo, con listas y casillas', () async {
      final repository = RecruitmentRepository(
        client(
          (request) => response({
            'id': 'd1',
            'posicion': 'pos1',
            'posicion_etiqueta': 'Operador — PAILERIA',
            'version': 2,
            'congelado_en': '2026-09-25T10:00:00Z',
            'esta_congelado': true,
            'fecha_elaboracion': '2026-09-24',
            'edad': 50,
            'disponibilidad_viajar': false,
            'competencias': [70, 71],
            'recursos': [80],
            'funciones': [
              {'orden': 1, 'texto': 'Soldar'},
            ],
            'indicadores': [],
            'conformidades': [
              {
                'id': 'c1',
                'descriptivo': 'd1',
                'rol': 90,
                'persona': 'p1',
                'persona_nombre': 'Pérez Juan',
                'fecha': null,
                'usuario': null,
                'nombre_manual': '',
              },
            ],
          }),
        ),
      );
      final d = await repository.descriptivo('d1');
      expect(d.estaCongelado, isTrue);
      expect(d.disponibilidadViajar, isFalse);
      expect(d.competencias, [70, 71]);
      expect(d.funciones.single.texto, 'Soldar');
      expect(d.conformidades.single.personaNombre, 'Pérez Juan');
    });

    test(
      'un colaborador no recibe conformidades y el modelo lo tolera',
      () async {
        final repository = RecruitmentRepository(
          client(
            (request) => response({
              'id': 'd1',
              'posicion': 'pos1',
              'version': 1,
              'fecha_elaboracion': '2026-09-24',
            }),
          ),
        );
        final d = await repository.descriptivo('d1');
        expect(d.conformidades, isEmpty);
        expect(d.posicionEtiqueta, '');
        expect(d.funciones, isEmpty);
      },
    );

    test('exportarWord pide bytes y toma el nombre del servidor', () async {
      final repository = RecruitmentRepository(
        client((request) {
          expect(request.path, 'recruitment/descriptivos/d1/exportar-word/');
          return ResponseBody.fromBytes(
            [7, 8],
            200,
            headers: {
              'content-disposition': [
                'attachment; filename="Descriptivo.docx"',
              ],
            },
          );
        }),
      );
      final file = await repository.exportarWord('d1');
      expect(file.name, 'Descriptivo.docx');
      expect(file.mimeType, contains('wordprocessingml'));
    });

    test('borrar un borrador hace DELETE', () async {
      final repository = RecruitmentRepository(
        client((request) {
          expect(request.method, 'DELETE');
          expect(request.path, 'recruitment/descriptivos/d1/');
          return response(null, status: 204);
        }),
      );
      await repository.deleteDescriptivo('d1');
    });
  });

  group('RecruitmentRepository: catálogos y posiciones', () {
    test(
      'cada catálogo pide su ruta (el tipo de requisición vive en Posiciones)',
      () async {
        final paths = <String>[];
        final repository = RecruitmentRepository(
          client((request) {
            paths.add(request.path);
            return response({'count': 0, 'results': []});
          }),
        );
        await Future.wait([
          repository.estados(),
          repository.etapasAprobacion(),
          repository.tiposContrato(),
          repository.horariosACubrir(),
          repository.tiposRequisicion(),
          repository.rangosEdad(),
          repository.diasPorLaborar(),
          repository.competencias(),
          repository.recursos(),
          repository.rolesConformidad(),
        ]);
        expect(paths.toSet(), {
          'recruitment/estados/',
          'recruitment/etapas-aprobacion/',
          'recruitment/tipos-contrato-ofrecido/',
          'recruitment/horarios-a-cubrir/',
          'positions/tipos-requisicion/',
          'recruitment/rangos-edad/',
          'recruitment/dias-por-laborar/',
          'recruitment/competencias-conductuales/',
          'recruitment/recursos-asignados/',
          'recruitment/roles-conformidad/',
        });
      },
    );

    test('el catálogo de tipos trae si exige justificación', () async {
      final repository = RecruitmentRepository(
        client(
          (request) => response({
            'count': 2,
            'results': [
              {
                'id': 1,
                'code': 'r',
                'name': 'Reemplazo',
                'is_active': true,
                'requiere_justificacion': false,
              },
              {
                'id': 2,
                'code': 'n',
                'name': 'Nueva Posición',
                'is_active': true,
                'requiere_justificacion': true,
              },
            ],
          }),
        ),
      );
      final tipos = await repository.tiposRequisicion();
      expect(tipos.map((t) => t.requiereJustificacion), [false, true]);
    });

    test(
      'searchPosiciones busca en el servidor y lee la etiqueta ya armada',
      () async {
        final repository = RecruitmentRepository(
          client((request) {
            expect(request.path, 'positions/posiciones/');
            expect(request.queryParameters, {'search': 'sold', 'page_size': 8});
            return response({
              'count': 1,
              'results': [
                {
                  'id': 'pos1',
                  'etiqueta': 'Operador — PAILERIA',
                  'organization_node': 'n',
                },
              ],
            });
          }),
        );
        final found = await repository.searchPosiciones('sold');
        expect(found.single.id, 'pos1');
        expect(found.single.etiqueta, 'Operador — PAILERIA');
      },
    );
  });

  group('recruitmentMutationError', () {
    test('explica el motivo del servidor con el nombre del campo', () {
      expect(
        recruitmentMutationError(
          _http(400, {
            'justificacion': ['Este tipo de Requisición exige justificación.'],
          }),
        ),
        'Justificación: Este tipo de Requisición exige justificación.',
      );
      expect(
        recruitmentMutationError(
          _http(400, {
            'non_field_errors': [
              'Esta versión del Descriptivo ya está congelada y no se puede modificar.',
            ],
          }),
        ),
        'Esta versión del Descriptivo ya está congelada y no se puede modificar.',
      );
    });

    test('un estado que no le toca a quien solicita se dice con el motivo', () {
      expect(
        recruitmentMutationError(
          _http(400, {
            'estado': [
              'Solo Capital Humano puede poner una requisición en este estado.',
            ],
          }),
        ),
        'Estado: Solo Capital Humano puede poner una requisición en este estado.',
      );
    });

    test('403 y 404 tienen su texto', () {
      expect(
        recruitmentMutationError(_http(403, {'detail': 'x'})),
        'Tu cuenta no tiene permiso para hacer esto.',
      );
      expect(
        recruitmentMutationError(_http(404, {'detail': 'x'})),
        'Ya no está disponible. Actualiza la lista.',
      );
    });
  });
}
