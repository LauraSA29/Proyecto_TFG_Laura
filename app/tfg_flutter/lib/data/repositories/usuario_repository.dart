import '/domain/entities/Usuario.dart';

abstract class UsuarioRepository {
  Future<Usuario?> login(String correo, String password);
}
