// lib/data/datasource/usuario_remote_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/usuario.dart';
import 'odoo_session.dart';

class UsuarioRemoteDataSource {
  final session = OdooSession();

  final String db = 'odoo';
  final String username = 'admin';
  final String password = 'admin';

  Future<Usuario?> obtenerUsuario(int userId) async {
    await session.login(db, username, password);

    final payload = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          session.db,
          session.uid,
          session.password,
          "res.users",
          "read",
          [[userId]],
          {"fields": ["id", "name", "email", "groups_id", "image_1920"]}
        ]
      },
      "id": 1
    };

    final response = await http.post(
      Uri.parse('${session.baseUrl}/jsonrpc'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    final data = jsonDecode(response.body)['result'];
    if (data.isEmpty) return null;

    final json = data[0];

    final tipo = (json['groups_id'] as List).contains(1)
        ? 'admin'
        : 'normal'; // 1 = admin

    return Usuario(
      id: json['id'].toString(),
      nombre: json['name'] ?? '',
      correo: json['email'] ?? '',
      tipo: tipo,
      fotoUrl: json['image_1920'],
    );
  }
}
