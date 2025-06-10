// lib/data/repositories/tarea_repository_impl.dart
import '/domain/entities/tarea.dart';
import '/data/repositories/tarea_repository.dart';
import '/data/datasources/tarea_remote_datasource.dart';

//implementación de tareas
class TareaRepositoryImpl implements TareaRepository {
  final TareaRemoteDataSource remoteDataSource;

  TareaRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Tarea>> obtenerTodas() async {
    return await remoteDataSource.obtenerTareas();
  }

  @override
  Future<void> crearTarea(Tarea tarea) {
    return remoteDataSource.crearTarea(tarea);
  }

  @override
  Future<void> eliminarTarea(String id) {
    return remoteDataSource.eliminarTarea(id);
  }

  @override
  Future<void> actualizarEstado(String id, String nuevoEstado) {
    return remoteDataSource.actualizarEstado(id, nuevoEstado);
  }

  @override
  Future<List<String>> obtenerUsuarios() {
    return remoteDataSource.obtenerUsuarios();
  }
}
