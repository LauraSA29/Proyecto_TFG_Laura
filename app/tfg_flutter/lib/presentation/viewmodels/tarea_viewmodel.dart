import 'package:flutter/material.dart';
import '/domain/entities/tarea.dart';
import '/domain/usecases/obtener_tareas.dart';
import '/domain/usecases/crear_tarea.dart';
import '/domain/usecases/actualizar_estado_tarea.dart';
import '/domain/usecases/eliminar_tarea.dart';

class TareaViewModel with ChangeNotifier {
  final ObtenerTareasUseCase obtenerTareasUseCase;
  final CrearTareaUseCase crearTareaUseCase;
  final ActualizarEstadoTareaUseCase actualizarEstadoUseCase;
  final EliminarTareaUseCase eliminarTareaUseCase;

  TareaViewModel({
    required this.obtenerTareasUseCase,
    required this.crearTareaUseCase,
    required this.actualizarEstadoUseCase,
    required this.eliminarTareaUseCase,
  });

  List<Tarea> _tareas = [];
  bool _isLoading = false;
  String? _error;

  List<Tarea> get tareas => _tareas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarTareas() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tareas = await obtenerTareasUseCase();
      _error = null;
    } catch (e) {
      _error = 'Error al cargar tareas';
      _tareas = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> crearTarea(Tarea tarea) async {
    await crearTareaUseCase(tarea);
    await cargarTareas(); // Recarga tras crear
  }

  Future<void> actualizarEstado(String id, String nuevoEstado) async {
    await actualizarEstadoUseCase(id, nuevoEstado);
    await cargarTareas(); // Refresca tras cambiar estado
  }

  Future<void> eliminarTarea(String id) async {
    await eliminarTareaUseCase(id);
    await cargarTareas(); // Refresca tras eliminar
  }
}
