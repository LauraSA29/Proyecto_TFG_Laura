import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mensajes"),
      ),
      body: const Center(
        child: Text(
          "Aquí irán los mensajes entre trabajadores",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
