import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '/theme/colores.dart';
import '/presentation/viewmodels/usuario_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final usuarioVM = Provider.of<UsuarioViewModel>(context);
    final usuario = usuarioVM.usuario;
    final isAdmin = usuario?.tipo.toLowerCase() == 'admin';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(usuario?.nombre ?? "Usuario", usuarioVM),
              const SizedBox(height: 10),

              if (isAdmin) ...[
                _buildBoton("Tareas", '/crear-tarea'),
                _buildBoton("Pedidos", null),
                _buildBoton("Reuniones", null),
              ],

              _buildBoton("Agenda", '/agenda'),
              const SizedBox(height: 20),
              _buildCalendario(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String nombre, UsuarioViewModel usuarioVM) {
    return Stack(
      children: [
        ClipPath(
          clipper: HeaderClipper(),
          child: Container(
            height: 110,
            color: AppColors.azulPrincipal,
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: const Alignment(0, -0.3), // <- ¡Esto sube el contenido!
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage('assets/profile.jpg'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Hola, $nombre",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: AppColors.textoOscuro,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat_rounded),
                        color: AppColors.textoOscuro,
                        onPressed: () {
                          Navigator.pushNamed(context, '/chat');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        color: AppColors.textoOscuro,
                        onPressed: () async {
                          await usuarioVM.cerrarSesion();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBoton(String texto, String? ruta) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: ElevatedButton(
        onPressed: ruta != null ? () => Navigator.pushNamed(context, ruta) : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.fondoCampos,
          foregroundColor: AppColors.textoOscuro,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCalendario() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.fondoCampos,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: TableCalendar(
          locale: 'es_ES',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarStyle: CalendarStyle(
            todayDecoration: const BoxDecoration(
              color: AppColors.azulPrincipal,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.textoOscuro.withOpacity(0.8),
              shape: BoxShape.circle,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
          ),
        ),
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
