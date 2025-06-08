// lib/domain/usecases/crear_tarea.dart
import '/domain/entities/tarea.dart';
import '/data/repositories/tarea_repository.dart';

class CrearTareaUseCase {
  final TareaRepository repository;

  CrearTareaUseCase(this.repository);

  Future<void> call(Tarea tarea) async {
    await repository.crearTarea(tarea);
  }
}
