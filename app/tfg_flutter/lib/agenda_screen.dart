import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Lista simulada de tareas/eventos por día
  final Map<DateTime, List<String>> _tareasPorFecha = {
    DateTime.utc(2025, 5, 20): ['Reunión con cliente', 'Pedido 203 - Confirmar envío'],
    DateTime.utc(2025, 5, 21): ['Visita proveedor', 'Revisar inventario'],
  };

  @override
  Widget build(BuildContext context) {
    final tareasHoy = _tareasPorFecha[_selectedDay ?? _focusedDay] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agenda'),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: [
          TableCalendar(
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
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: tareasHoy.isEmpty
                ? const Center(
                    child: Text(
                      'No hay tareas programadas.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: tareasHoy.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text(tareasHoy[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
