import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '/theme/colores.dart';
import '/presentation/viewmodels/usuario_viewmodel.dart';
import '/presentation/widget/header_widget.dart';  // Importa el widget reutilizable

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
    final isAdmin = usuarioVM.esAdmin;

    final fotoUrl = usuario?.fotoUrl;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(
                nombre: usuario?.nombre ?? "Usuario",
                fotoUrl: fotoUrl,
                usuarioVM: usuarioVM,
              ),
              const SizedBox(height: 10),

              if (isAdmin) ...[
                _buildBoton("Tareas", '/crear-tarea'),
                _buildBoton("Pedidos", null), //no estan disponibles
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

  Widget _buildBoton(String texto, String? ruta) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 38),
    child: ElevatedButton(
      onPressed: ruta != null ? () => Navigator.pushNamed(context, ruta) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colores.fondoCampos,
        foregroundColor: Colores.textoOscuro,
        minimumSize: const Size(double.infinity, 50),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: Colors.grey.shade300,
            width: 1.2,
          ),
        ),
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


//calendario español, desparecido el marcado
  Widget _buildCalendario() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colores.fondoCampos,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
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
              color: Colores.azulPrincipal,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colores.textoOscuro.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            defaultTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colores.textoOscuro,
            ),
            leftChevronIcon: Icon(Icons.chevron_left, color: Colores.azulPrincipal),
            rightChevronIcon: Icon(Icons.chevron_right, color: Colores.azulPrincipal),
          ),
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colores.textoOscuro,
            ),
          ),
        ),
      ),
    );
  }
}
