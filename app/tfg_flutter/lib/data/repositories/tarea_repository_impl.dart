import '/domain/entities/tarea.dart';
import '/data/models/tarea_model.dart';
import '/data/repositories/tarea_repository.dart';
import '../datasources/tarea_remote_datasource.dart';

class TareaRepositoryImpl implements TareaRepository {
  final TareaRemoteDataSource remote;

  TareaRepositoryImpl(this.remote);

  @override
  Future<List<Tarea>> obtenerTodas() async {
    final models = await remote.obtenerTodas();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> crearTarea(Tarea tarea) async {
    await remote.crearTarea(TareaModel.fromEntity(tarea));
  }

  @override
  Future<void> actualizarEstado(String id, String nuevoEstado) async {
    await remote.actualizarEstado(id, nuevoEstado);
  }

  @override
  Future<void> eliminarTarea(String id) async {
    await remote.eliminarTarea(id);
  }
}
