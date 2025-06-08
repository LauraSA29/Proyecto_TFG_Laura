// lib/data/datasources/odoo_session.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class OdooSession {
  static final OdooSession _instance = OdooSession._internal();
  factory OdooSession() => _instance;
  OdooSession._internal();

  final String baseUrl = 'http://localhost:8080'; // Ahora pasa por NGINX con CORS POR FIN //'http://localhost:8069' esto estaba antes;
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
      throw Exception("Error de red al hacer login en Odoo");
    }

    final data = jsonDecode(response.body);
    final uid = data['result'];

    if (uid == null) throw Exception("Credenciales inválidas o error en Odoo");

    this.uid = uid;
    return uid;
  }
}
