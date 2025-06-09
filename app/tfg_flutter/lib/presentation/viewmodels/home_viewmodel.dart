// lib/presentation/viewmodels/home_viewmodel.dart
import 'package:flutter/material.dart';
import '/data/datasources/home_remote_datasource.dart';


class HomeViewModel with ChangeNotifier {

  bool _isLoading = false;
  int _totalTareas = 0;
  int _totalReuniones = 0;
  int _totalPedidos = 0; //solo tarea usada

  bool get isLoading => _isLoading;
  int get totalTareas => _totalTareas;
  int get totalReuniones => _totalReuniones;
  int get totalPedidos => _totalPedidos;

  final HomeRemoteDataSource remote;

  HomeViewModel(this.remote);

  Future<void> cargarDatos() async {
    _isLoading = true;
    notifyListeners();

    try {

      _totalTareas = await remote.obtenerTotalTareas();
      _totalReuniones = await remote.obtenerTotalReuniones();
      _totalPedidos = await remote.obtenerTotalPedidos();

    } catch (e) {

      print("error al cargar: $e"); //prueba por si no cargan
      
    }

    _isLoading = false;
    notifyListeners();
  }
}
