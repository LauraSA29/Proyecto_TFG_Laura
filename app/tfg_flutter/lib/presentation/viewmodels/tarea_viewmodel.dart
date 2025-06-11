// lib/presentation/viewmodels/tarea_viewmodel.dart
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
    print('cargando tareitas...'); //ver si se cargan
    _isLoading = true;
    notifyListeners();

    try {

      _tareas = await obtenerTareasUseCase();
      print("tareas cargadas: ${_tareas.length}");
      _error = null;

    } catch (e, stacktrace) {

      print('Error en cargarTareas(): $e');
      print(stacktrace);
      _error = 'Error al cargar tareas: $e';
      _tareas = [];

    }

    _isLoading = false;
    notifyListeners();
  }

//

  Future<void> crearTarea(Tarea tarea) async {
    await crearTareaUseCase(tarea);
    await cargarTareas();
  }

  Future<void> actualizarEstado(String id, String nuevoEstado) async {
    await actualizarEstadoUseCase(id, nuevoEstado);
    await cargarTareas();
  }

  Future<void> eliminarTarea(String id) async {
    await eliminarTareaUseCase(id);
    await cargarTareas();
  }

  Future<void> actualizarTarea(Tarea tarea) async { //arreglado
    await eliminarTarea(tarea.id);
    await crearTarea(tarea);
  }

  Future<List<String>> obtenerUsuarios() async {
  return await obtenerTareasUseCase.repository.obtenerUsuarios();
  }

}

