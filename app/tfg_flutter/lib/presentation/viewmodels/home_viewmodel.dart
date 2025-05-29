import 'package:flutter/material.dart';

class HomeViewModel with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> cargarDatos() async {
    _isLoading = true;
    notifyListeners();

    // TODO: Lógica para cargar datos de la pantalla principal
    await Future.delayed(Duration(seconds: 1)); // Simulación

    _isLoading = false;
    notifyListeners();
  }
}