// lib/data/datasource/odoo_remote_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'odoo_session.dart';

class OdooRemoteDataSource {
  final session = OdooSession();

  // para autentiicación usuarios JSON-RPC.

  Future<int?> autentificar(String db, String username, String password) async {
    final url = Uri.parse('${session.baseUrl}/jsonrpc');
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
      body: json.encode(payload),
    );

    if (response.statusCode == 200) { //200 es OK
      final jsonResponse = json.decode(response.body);
      return jsonResponse['result'];
    } else {
      throw Exception("Error al intentar autentificarse en Odoo: ${response.body}");
    }
  }
}
