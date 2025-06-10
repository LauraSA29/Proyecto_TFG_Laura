// lib/data/repositories/usuario_repository_impl.dart
import '/domain/entities/usuario.dart';
import '/data/repositories/usuario_repository.dart';
import '/data/datasources/usuario_remote_datasource.dart';

// implementación usuario
class UsuarioRepositoryImpl implements UsuarioRepository {
  final UsuarioRemoteDataSource remoteDataSource;

  UsuarioRepositoryImpl(this.remoteDataSource);

  @override
  Future<Usuario?> getUsuario(int userId) {
    return remoteDataSource.obtenerUsuario(userId);
  }
}
