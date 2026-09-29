import 'package:capital_humano_front/core/network/api_page.dart';
import 'package:capital_humano_front/features/schedules/data/schedule_models.dart';
import 'package:capital_humano_front/features/schedules/data/schedules_repository.dart';
import 'package:dio/dio.dart';

const catorcenaA = Catorcena(
  id: 'k1',
  numero: 5,
  anio: 2026,
  fechaInicio: '2026-01-01',
  fechaFin: '2026-01-14',
);

const tipoHorarioA = TipoHorarioRef(
  id: 1,
  code: 'H01',
  name: 'Horario 1',
  descripcion: '07:00 - 16:00',
  isActive: true,
);

const areaRefA = AreaRef(id: 'area1', code: 'A1', name: 'Producción');

const empleadoRefA = EmpleadoRef(id: 'e1', workNumber: 'ADV0001');

const asignacionHorarioA = AsignacionHorario(
  id: 'ah1',
  empleado: 'e1',
  fechaReferencia: '2026-02-01',
  tipoHorario: 1,
);

const asignacionUbicacionA = AsignacionUbicacion(
  id: 'au1',
  empleado: 'e1',
  fechaReferencia: '2026-02-01',
  area: 'area1',
);

class FakeSchedulesRepository extends SchedulesRepository {
  FakeSchedulesRepository() : super(Dio());
  Object? failure;

  Catorcena? saved;
  bool? created;
  String? deleted;
  final catorcenas = [catorcenaA];

  AsignacionHorario? savedHorario;
  bool? createdHorario;
  String? deletedHorario;
  final asignacionesHorario = [asignacionHorarioA];

  AsignacionUbicacion? savedUbicacion;
  bool? createdUbicacion;
  String? deletedUbicacion;
  final asignacionesUbicacion = <AsignacionUbicacion>[];

  final empleados = [empleadoRefA];

  @override
  Future<ApiPage<Catorcena>> catorcenasPage(int page) async {
    if (failure != null) throw failure!;
    return ApiPage(count: catorcenas.length, results: [...catorcenas]);
  }

  @override
  Future<List<Catorcena>> allCatorcenas() async {
    if (failure != null) throw failure!;
    return [...catorcenas];
  }

  @override
  Future<Catorcena> saveCatorcena(
    Catorcena catorcena, {
    required bool creating,
  }) async {
    if (failure != null) throw failure!;
    saved = catorcena;
    created = creating;
    final result = creating ? catorcena.copyWith(id: 'new') : catorcena;
    if (creating) {
      catorcenas.add(result);
    } else {
      catorcenas[catorcenas.indexWhere((item) => item.id == catorcena.id)] =
          result;
    }
    return result;
  }

  @override
  Future<void> deleteCatorcena(String id) async {
    if (failure != null) throw failure!;
    deleted = id;
    catorcenas.removeWhere((item) => item.id == id);
  }

  @override
  Future<List<TipoHorarioRef>> tiposHorario() async {
    if (failure != null) throw failure!;
    return [tipoHorarioA];
  }

  @override
  Future<List<AreaRef>> areas() async {
    if (failure != null) throw failure!;
    return [areaRefA];
  }

  @override
  Future<List<EmpleadoRef>> allEmpleados() async {
    if (failure != null) throw failure!;
    return [...empleados];
  }

  @override
  Future<EmpleadoRef> empleado(String id) async {
    if (failure != null) throw failure!;
    return empleados.firstWhere((item) => item.id == id);
  }

  @override
  Future<ApiPage<AsignacionHorario>> asignacionesHorarioPage(int page) async {
    if (failure != null) throw failure!;
    return ApiPage(
      count: asignacionesHorario.length,
      results: [...asignacionesHorario],
    );
  }

  @override
  Future<AsignacionHorario> saveAsignacionHorario(
    AsignacionHorario asignacion, {
    required bool creating,
  }) async {
    if (failure != null) throw failure!;
    savedHorario = asignacion;
    createdHorario = creating;
    final result = creating ? asignacion.copyWith(id: 'new') : asignacion;
    if (creating) {
      asignacionesHorario.add(result);
    } else {
      asignacionesHorario[asignacionesHorario.indexWhere(
        (item) => item.id == asignacion.id,
      )] = result;
    }
    return result;
  }

  @override
  Future<void> deleteAsignacionHorario(String id) async {
    if (failure != null) throw failure!;
    deletedHorario = id;
    asignacionesHorario.removeWhere((item) => item.id == id);
  }

  @override
  Future<ApiPage<AsignacionUbicacion>> asignacionesUbicacionPage(
    int page,
  ) async {
    if (failure != null) throw failure!;
    return ApiPage(
      count: asignacionesUbicacion.length,
      results: [...asignacionesUbicacion],
    );
  }

  @override
  Future<AsignacionUbicacion> saveAsignacionUbicacion(
    AsignacionUbicacion asignacion, {
    required bool creating,
  }) async {
    if (failure != null) throw failure!;
    savedUbicacion = asignacion;
    createdUbicacion = creating;
    final result = creating ? asignacion.copyWith(id: 'new') : asignacion;
    if (creating) {
      asignacionesUbicacion.add(result);
    } else {
      asignacionesUbicacion[asignacionesUbicacion.indexWhere(
        (item) => item.id == asignacion.id,
      )] = result;
    }
    return result;
  }

  @override
  Future<void> deleteAsignacionUbicacion(String id) async {
    if (failure != null) throw failure!;
    deletedUbicacion = id;
    asignacionesUbicacion.removeWhere((item) => item.id == id);
  }
}
