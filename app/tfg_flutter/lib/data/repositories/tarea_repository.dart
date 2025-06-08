// lib/data/repositories/tarea_repository.dart
import '/domain/entities/tarea.dart';

abstract class TareaRepository {
  Future<List<Tarea>> obtenerTodas();
  Future<void> crearTarea(Tarea tarea);
  Future<void> actualizarEstado(String id, String nuevoEstado);
  Future<void> eliminarTarea(String id);
  Future<List<String>> obtenerUsuarios();
}
