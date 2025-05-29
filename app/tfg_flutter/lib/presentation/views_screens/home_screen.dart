import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '/theme/colores.dart';

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
    return Scaffold(
      backgroundColor: AppColors.fondoClaro,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Encabezado con curva, avatar, texto y chat
              Stack(
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
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundImage: AssetImage('assets/profile.jpg'),
                            ),
                            const Text(
                              "¡Bienvenido!",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: AppColors.textoOscuro,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.chat_rounded),
                              color: AppColors.textoOscuro,
                              onPressed: () {
                                Navigator.pushNamed(context, '/chat');
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Botones de opciones
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/crear-tarea');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.fondoCampos,
                    foregroundColor: AppColors.textoOscuro,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Tareas"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.fondoCampos,
                    foregroundColor: AppColors.textoOscuro,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Pedidos"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.fondoCampos,
                    foregroundColor: AppColors.textoOscuro,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Reuniones"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/agenda');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.fondoCampos,
                    foregroundColor: AppColors.textoOscuro,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text("Agenda"),
                ),
              ),

              const SizedBox(height: 20),

              // Calendario
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TableCalendar(
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
            ],
          ),
        ),
      ),
    );
  }
}

// ClipPath personalizado
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
