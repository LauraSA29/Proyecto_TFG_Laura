// lib/domain/usecases/actualizar_estado_tarea.dart
import '/data/repositories/tarea_repository.dart';

class ActualizarEstadoTareaUseCase {
  final TareaRepository repository;

  ActualizarEstadoTareaUseCase(this.repository);

  Future<void> call(String id, String nuevoEstado) async {
    await repository.actualizarEstado(id, nuevoEstado);
  }
}
