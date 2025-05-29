import '/domain/entities/usuario.dart';
import '/data/repositories/usuario_repository.dart';

class LoginUsuarioUseCase {
  final UsuarioRepository repository;

  LoginUsuarioUseCase(this.repository);

  Future<Usuario?> call(String correo, String password) async {
    return await repository.login(correo, password);
  }
}
