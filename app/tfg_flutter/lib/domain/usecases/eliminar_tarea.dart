// lib/domain/usecases/eliminar_tarea.dart
import '/data/repositories/tarea_repository.dart';

class EliminarTareaUseCase {
  final TareaRepository repository;

  EliminarTareaUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.eliminarTarea(id);
  }
}
