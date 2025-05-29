import 'package:flutter/material.dart';
import '/domain/entities/usuario.dart';
import '/domain/usecases/login_usuario.dart';

class LoginViewModel with ChangeNotifier {
  final LoginUsuarioUseCase loginUsuarioUseCase;

  Usuario? _usuario;
  bool _isLoading = false;
  String? _error;

  LoginViewModel({required this.loginUsuarioUseCase});

  Usuario? get usuario => _usuario;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String correo, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await loginUsuarioUseCase(correo, password);
      if (result == null) {
        _error = 'Credenciales incorrectas';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _usuario = result;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al iniciar sesión';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _usuario = null;
    notifyListeners();
  }
}
