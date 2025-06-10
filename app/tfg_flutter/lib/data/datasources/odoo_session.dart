// lib/data/datasources/odoo_session.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

// mantener el estado de la sesión con Odoo
class OdooSession {
  static final OdooSession _instance = OdooSession._interna();
  factory OdooSession() => _instance;
  OdooSession._interna();

  final String baseUrl = 'http://localhost:8080'; // Ahora pasa por NGINX con CORS POR FIN    'http://localhost:8069' esto estaba antes
  final String db = 'odoo';
  final String username = 'admin';
  final String password = 'admin';

  int? uid;

  Future<int?> login(String db, String username, String password) async {
    final url = Uri.parse('$baseUrl/jsonrpc');
    final payload = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "common",
        "method": "login",
        "args": [db, username, password]
      },
      "id": 1
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw Exception("Error en la red al hacer login en Odoo"); //error red
    }

    final data = jsonDecode(response.body);
    final uid = data['result'];

    if (uid == null) throw Exception("Datos escritos incorrectos o error en Odoo");

    this.uid = uid;
    return uid;
  }
}
