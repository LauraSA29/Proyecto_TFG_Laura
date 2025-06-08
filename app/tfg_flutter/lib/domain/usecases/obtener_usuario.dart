// lib/domain/usecases/obtener_usuario.dart
import '../entities/usuario.dart';
import '/data/repositories/usuario_repository.dart';

class ObtenerUsuarioUseCase {
  final UsuarioRepository repository;

  ObtenerUsuarioUseCase(this.repository);

  Future<Usuario?> call(int userId) {
    return repository.getUsuario(userId);
  }
}
