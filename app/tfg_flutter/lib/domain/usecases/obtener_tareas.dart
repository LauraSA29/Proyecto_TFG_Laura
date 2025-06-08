// lib/domain/usecases/obtener_tareas.dart
import '/domain/entities/tarea.dart';
import '/data/repositories/tarea_repository.dart';

class ObtenerTareasUseCase {
  final TareaRepository repository;

  ObtenerTareasUseCase(this.repository);

  Future<List<Tarea>> call() async {
    return await repository.obtenerTodas();
  }
}