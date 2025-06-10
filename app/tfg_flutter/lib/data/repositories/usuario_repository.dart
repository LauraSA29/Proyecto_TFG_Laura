// lib/data/repositories/usuario_repository.dart
import '/domain/entities/usuario.dart';

abstract class UsuarioRepository {
  Future<Usuario?> getUsuario(int userId);
}
