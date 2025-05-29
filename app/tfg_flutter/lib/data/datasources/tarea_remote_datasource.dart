import '/data/models/tarea_model.dart';

abstract class TareaRemoteDataSource {
  Future<List<TareaModel>> obtenerTodas();
  Future<void> crearTarea(TareaModel tarea);
  Future<void> actualizarEstado(String id, String nuevoEstado);
  Future<void> eliminarTarea(String id);
}
