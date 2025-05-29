import '/domain/entities/usuario.dart';

abstract class UsuarioRepository {
  Future<Usuario?> login(String correo, String password);
}
