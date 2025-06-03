import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/domain/entities/Usuario.dart';

class UsuarioViewModel with ChangeNotifier {
  Usuario? _usuario;

  Usuario? get usuario => _usuario;
  bool get estaLogueado => _usuario != null;
  bool get esAdmin => _usuario?.esAdmin ?? false;

  Future<void> iniciarSesion(Usuario usuario) async {
    _usuario = usuario;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario_id', usuario.id);
    await prefs.setString('usuario_nombre', usuario.nombre);
    await prefs.setString('usuario_correo', usuario.correo);
    await prefs.setString('usuario_tipo', usuario.tipo);
    notifyListeners();
  }

  Future<void> cerrarSesion() async {
    _usuario = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<void> cargarSesionGuardada() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('usuario_id')) {
      _usuario = Usuario(
        id: prefs.getString('usuario_id') ?? '',
        nombre: prefs.getString('usuario_nombre') ?? '',
        correo: prefs.getString('usuario_correo') ?? '',
        tipo: prefs.getString('usuario_tipo') ?? '',
      );
      notifyListeners();
    }
  }
}
