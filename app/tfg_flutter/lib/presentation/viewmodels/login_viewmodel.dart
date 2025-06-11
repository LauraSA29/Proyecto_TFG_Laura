// lib/presentation/viewmodels/login_viewmodel.dart
import 'package:flutter/material.dart';
import '/data/datasources/odoo_session.dart';

class LoginViewModel extends ChangeNotifier {
  final session = OdooSession();

  bool isLoading = false;
  String? error;
  int? userId;

  Future<int?> login(String db, String username, String password) async {
    
    isLoading = true;
    error = null;
    notifyListeners();

    int? userId;

    try {

      final result = await session.login(db, username, password);
      userId = result;

      if (userId == null) {
        error = "Datos incorrectos";
      }

    } catch (e) {

      error = "No existe ese correo o contraseña";

    } finally {

      isLoading = false;
      notifyListeners();
    }
    return userId;
  }
}
