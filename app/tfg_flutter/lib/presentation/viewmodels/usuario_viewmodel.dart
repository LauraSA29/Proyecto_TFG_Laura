// lib/presentation/viewmodels/usuario_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/usuario.dart';
import '/domain/usecases/obtener_usuario.dart';

class UsuarioViewModel with ChangeNotifier {
  final ObtenerUsuarioUseCase obtenerUsuarioUseCase;

  UsuarioViewModel(this.obtenerUsuarioUseCase);

  Usuario? _usuario;

  Usuario? get usuario => _usuario;
  bool get estaLogueado => _usuario != null;
  bool get esAdmin => _usuario?.esAdmin ?? false;

  Future<void> cargarUsuarioDesdeOdoo(int userId) async {
    _usuario = await obtenerUsuarioUseCase(userId);

    if (_usuario != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('usuario_id', _usuario!.id);
      await prefs.setString('usuario_nombre', _usuario!.nombre);
      await prefs.setString('usuario_correo', _usuario!.correo);
      await prefs.setString('usuario_tipo', _usuario!.tipo);
      if (_usuario!.fotoUrl != null) {
        await prefs.setString('usuario_fotoUrl', _usuario!.fotoUrl!);
      }
    }

    notifyListeners();
  }

  Future<void> cerrarSesion() async {
    _usuario = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

//revisar
  Future<void> cargarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('usuario_id')) {
      _usuario = Usuario(
        id: prefs.getString('usuario_id') ?? '',
        nombre: prefs.getString('usuario_nombre') ?? '',
        correo: prefs.getString('usuario_correo') ?? '',
        tipo: prefs.getString('usuario_tipo') ?? '',
        fotoUrl: prefs.getString('usuario_fotoUrl'),
      );
      notifyListeners();
    }
  }
}
