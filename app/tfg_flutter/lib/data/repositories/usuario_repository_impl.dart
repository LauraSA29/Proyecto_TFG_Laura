import '/domain/entities/Usuario.dart';
import 'usuario_repository.dart';

class UsuarioRepositoryImpl implements UsuarioRepository {
  final List<Map<String, String>> _usuariosMock = [
    {
      "correo": "admin@empresa.com",
      "password": "admin123",
      "nombre": "Administrador",
      "tipo": "admin",
      "id": "1",
    },
    {
      "correo": "empleado@empresa.com",
      "password": "empleado123",
      "nombre": "Trabajador",
      "tipo": "trabajador",
      "id": "2",
    },
  ];

  @override
  Future<Usuario?> login(String correo, String password) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simula red

    final encontrado = _usuariosMock.firstWhere(
      (u) => u["correo"] == correo && u["password"] == password,
      orElse: () => {},
    );

    if (encontrado.isEmpty) return null;

    return Usuario(
      id: encontrado["id"]!,
      nombre: encontrado["nombre"]!,
      correo: encontrado["correo"]!,
      tipo: encontrado["tipo"]!,
    );
  }
}
