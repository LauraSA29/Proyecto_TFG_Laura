// lib/data/datasource/home_remote_datasource.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'odoo_session.dart';

class HomeRemoteDataSource {
  final session = OdooSession();

  final String db = 'odoo';
  final String username = 'admin';
  final String password = 'admin';

  Future<int> _getCount(String model) async {
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
          model,
          "search_count",
          [[]] // sin filtros
        ]
      },
      "id": 1
    };

    final response = await http.post(
      Uri.parse('${session.baseUrl}/jsonrpc'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    return jsonDecode(response.body)['result'] as int;
  }

  Future<int> obtenerTotalTareas() => _getCount('project.task');
  Future<int> obtenerTotalReuniones() => _getCount('calendar.event');
  Future<int> obtenerTotalPedidos() => _getCount('sale.order');
}
