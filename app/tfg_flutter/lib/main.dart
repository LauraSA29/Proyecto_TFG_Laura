import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'chat_screen.dart';
import 'login_screen.dart';
import 'agenda_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Empresa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(), // ← esta es ahora la pantalla inicial
      routes: {
        '/home': (context) => const HomeScreen(),
        '/chat': (context) => const ChatScreen(),
        '/agenda': (context) => const AgendaScreen(), 
      },
    );
  }
}
