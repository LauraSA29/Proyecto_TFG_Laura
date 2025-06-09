// lib/presentation/viewmodels/chat_viewmodel.dart
import 'package:flutter/material.dart';

class ChatViewModel with ChangeNotifier {

  final List<String> _mensajes = [];
  List<String> get mensajes => _mensajes;
}
