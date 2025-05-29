import 'package:flutter/material.dart';

class ChatViewModel with ChangeNotifier {
  List<String> _mensajes = [];
  bool _isSending = false;

  List<String> get mensajes => _mensajes;
  bool get isSending => _isSending;

  Future<void> enviarMensaje(String mensaje) async {
    _isSending = true;
    notifyListeners();

    // TODO: Lógica para enviar mensaje
    await Future.delayed(Duration(milliseconds: 500)); // Simulación
    _mensajes.add(mensaje);

    _isSending = false;
    notifyListeners();
  }
}