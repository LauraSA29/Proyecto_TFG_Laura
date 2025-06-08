// lib/presentation/viewmodels/chat_viewmodel.dart
import 'package:flutter/material.dart';

class ChatViewModel with ChangeNotifier {
  List<String> _mensajes = [];
  bool _isSending = false;

  List<String> get mensajes => _mensajes;
  bool get isSending => _isSending;

  Future<void> enviarMensaje(String mensaje) async {
    _isSending = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 500)); //Pruebas, dejar
    _mensajes.add(mensaje);

    _isSending = false;
    notifyListeners();
  }
}