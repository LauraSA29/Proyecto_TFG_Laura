import 'dart:async';
import 'package:uuid/uuid.dart';

import 'tarea_remote_datasource.dart';
import '../models/tarea_model.dart';

class TareaRemoteDataSourceImpl implements TareaRemoteDataSource {
  final List<TareaModel> _mockData = [
    TareaModel(
      id: '1',
      titulo: 'Entregar informe',
      descripcion: 'Enviar informe de ventas mensual',
      estado: 'pendiente',
      fecha: DateTime.now().add(const Duration(days: 2)).toIso8601String(),
    ),
    TareaModel(
      id: '2',
      titulo: 'Reunión de equipo',
      descripcion: 'Reunión semanal de coordinación',
      estado: 'completada',
      fecha: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
    ),
  ];

  final _uuid = const Uuid();

  @override
  Future<List<TareaModel>> obtenerTodas() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockData;
  }

  @override
  Future<void> crearTarea(TareaModel tarea) async {
    final nueva = TareaModel(
      id: _uuid.v4(),
      titulo: tarea.titulo,
      descripcion: tarea.descripcion,
      estado: tarea.estado,
      fecha: tarea.fecha,
    );
    _mockData.add(nueva);
  }

  @override
  Future<void> actualizarEstado(String id, String nuevoEstado) async {
    final index = _mockData.indexWhere((t) => t.id == id);
    if (index != -1) {
      final tarea = _mockData[index];
      _mockData[index] = TareaModel(
        id: tarea.id,
        titulo: tarea.titulo,
        descripcion: tarea.descripcion,
        estado: nuevoEstado,
        fecha: tarea.fecha,
      );
    }
  }

  @override
  Future<void> eliminarTarea(String id) async {
    _mockData.removeWhere((t) => t.id == id);
  }
}
