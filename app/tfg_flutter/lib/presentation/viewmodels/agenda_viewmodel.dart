import 'package:flutter/material.dart';

class AgendaViewModel with ChangeNotifier {
  // Variables de estado
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // Métodos para manipular el estado
  Future<void> cargarAgenda() async {
    _isLoading = true;
    notifyListeners();

    // TODO: Lógica para cargar la agenda

    _isLoading = false;
    notifyListeners();
  }
}