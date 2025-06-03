import 'package:flutter/material.dart';
import '/domain/entities/Usuario.dart';
import '/domain/usecases/login_usuario.dart';

class LoginViewModel with ChangeNotifier {
  final LoginUsuarioUseCase loginUsuarioUseCase;

  LoginViewModel({required this.loginUsuarioUseCase});

  bool isLoading = false;
  String? error;

  Future<Usuario?> login(String correo, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final usuario = await loginUsuarioUseCase(correo, password);
      error = null;
      return usuario;
    } catch (e) {
      error = 'Correo o contraseña incorrectos';
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
