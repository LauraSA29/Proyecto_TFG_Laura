import 'package:flutter/material.dart';
import '../views_screens/login_screen.dart';
import '../views_screens/home_screen.dart';
import '../views_screens/agenda_screen.dart';
import '../views_screens/chat_screen.dart';
import '../views_screens/crear_tarea_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String chat = '/chat';
  static const String agenda = '/agenda';
  static const String crearTarea = '/crear-tarea';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      chat: (context) => const ChatScreen(),
      agenda: (context) => const AgendaScreen(),
      crearTarea: (context) => const CrearTareaScreen(),
    };
  }
}