import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/tarea.dart';
import 'odoo_session.dart';

class TareaRemoteDataSource {
  final session = OdooSession();

  final String db = 'odoo';
  final String username = 'admin';
  final String password = 'admin';

  Future<List<Tarea>> obtenerTareas() async {
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
        "project.task",
        "search_read",
        [],
        {
          "fields": [
            "id",
            "name",
            "description",
            "stage_id",
            "date_deadline",
            "project_id",
            "user_ids"
          ],
        }
      ]
    },
    "id": 1
  };

  final response = await http.post(
    Uri.parse('${session.baseUrl}/jsonrpc'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(payload),
  );

  final decoded = jsonDecode(response.body);
  final result = decoded['result'];

  if (result == null || result == false || result is! List) {
    print('Respuesta inesperada al obtener tareas: $result');
    throw Exception('Error al obtener tareas de Odoo.');
  }

  final data = result as List;

  return data.map((json) {
    String descripcion = '';
    if (json['description'] is String) {
      descripcion = json['description'];
    }

    String estado = '';
    if (json['stage_id'] is List && json['stage_id'].length >= 2 && json['stage_id'][1] is String) {
      estado = json['stage_id'][1];
    }

    DateTime fecha;
    try {
      if (json['date_deadline'] is String && (json['date_deadline'] as String).isNotEmpty) {
        fecha = DateTime.parse(json['date_deadline']);
      } else {
        fecha = DateTime.now();
      }
    } catch (e) {
      print('Error al parsear date_deadline: $e');
      fecha = DateTime.now();
    }

    int proyectoId = 0;
    if (json['project_id'] is List && json['project_id'].isNotEmpty) {
      proyectoId = json['project_id'][0];
    }

    List<int> userIds = [];
    String? asignado;

    if (json['user_ids'] is List) {
      var userIdsRaw = json['user_ids'] as List;
      if (userIdsRaw.isNotEmpty) {
        if (userIdsRaw.first is List && userIdsRaw.first.length >= 2) {
          userIds = userIdsRaw.map<int>((u) => u[0] as int).toList();
          asignado = userIdsRaw.first[1];
        } else if (userIdsRaw.first is int) {
          userIds = userIdsRaw.cast<int>();
        }
      }
    }

    return Tarea(
      id: json['id'].toString(),
      titulo: json['name'] ?? '',
      descripcion: descripcion,
      estado: estado,
      fecha: fecha,
      proyectoId: proyectoId,
      userIds: userIds,
      asignado: asignado,
    );
  }).toList();
}



  Future<void> crearTarea(Tarea tarea) async {
    await session.login(db, username, password);

    int? userId;
    if (tarea.userIds.isNotEmpty) {
      userId = tarea.userIds.first;
    }

    if (userId == null && tarea.asignado != null && tarea.asignado!.isNotEmpty) {
      final userSearchPayload = {
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
            "search_read",
            [
              [["name", "=", tarea.asignado]]
            ],
            {"fields": ["id"], "limit": 1}
          ]
        },
        "id": 99
      };

      final userRes = await http.post(
        Uri.parse('${session.baseUrl}/jsonrpc'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userSearchPayload),
      );

      final userResult = jsonDecode(userRes.body)['result'];
      if (userResult != null && userResult.isNotEmpty) {
        userId = userResult[0]['id'];
      } else {
        print("Usuario no encontrado: ${tarea.asignado}");
      }
    }

    final createArgs = {
      "name": tarea.titulo,
      "description": tarea.descripcion,
      "date_deadline": tarea.fecha.toIso8601String().split('T').first,
      "project_id": tarea.proyectoId,
      if (userId != null) "user_ids": [
        [6, 0, [userId]]
      ],
    };

    final createPayload = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          session.db,
          session.uid,
          session.password,
          "project.task",
          "create",
          [createArgs]
        ]
      },
      "id": 100
    };

    final response = await http.post(
      Uri.parse('${session.baseUrl}/jsonrpc'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(createPayload),
    );

    final data = jsonDecode(response.body);

    if (data['error'] != null) {
      print('Error al crear tarea en Odoo: ${data['error']}');
      throw Exception('Error desde Odoo al crear tarea');
    }

    final newId = data['result'];
    print('Tarea creada con ID: $newId');
  }

  Future<void> eliminarTarea(String id) async {
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
          "project.task",
          "unlink",
          [[int.parse(id)]]
        ]
      },
      "id": 3
    };

    await http.post(
      Uri.parse('${session.baseUrl}/jsonrpc'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
  }

  Future<void> actualizarEstado(String id, String nuevoEstado) async {
    await session.login(db, username, password);

    final searchStagePayload = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          session.db,
          session.uid,
          session.password,
          "project.task.type",
          "search_read",
          [
            [["name", "=", nuevoEstado]]
          ],
          {"fields": ["id"]}
        ]
      },
      "id": 4
    };

    final stageRes = await http.post(
      Uri.parse('${session.baseUrl}/jsonrpc'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(searchStagePayload),
    );

    final result = jsonDecode(stageRes.body)['result'];
    if (result.isEmpty) return;

    final stageId = result[0]['id'];

    final updatePayload = {
      "jsonrpc": "2.0",
      "method": "call",
      "params": {
        "service": "object",
        "method": "execute_kw",
        "args": [
          session.db,
          session.uid,
          session.password,
          "project.task",
          "write",
          [
            [int.parse(id)],
            {"stage_id": stageId}
          ]
        ]
      },
      "id": 5
    };

    await http.post(
      Uri.parse('${session.baseUrl}/jsonrpc'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(updatePayload),
    );
  }

  Future<List<String>> obtenerUsuarios() async {
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
          "search_read",
          [],
          {"fields": ["name"]}
        ]
      },
      "id": 6
    };

    final response = await http.post(
      Uri.parse('${session.baseUrl}/jsonrpc'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    final result = jsonDecode(response.body)['result'];

    return result.map<String>((user) => user['name'].toString()).toList();
  }
}
