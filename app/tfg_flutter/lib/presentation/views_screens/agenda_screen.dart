import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '/domain/entities/tarea.dart';
import '/presentation/viewmodels/tarea_viewmodel.dart';
import '/presentation/viewmodels/usuario_viewmodel.dart';
import '/presentation/widget/header_widget.dart';
import '/theme/colores.dart';

//este estilo era diferente, colores papelera, lapiz icono, check para marcar (los tenia puestos en el manual de usuario)
class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TareaViewModel>(context, listen: false).cargarTareas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioVM = Provider.of<UsuarioViewModel>(context);
    final usuario = usuarioVM.usuario;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(
              nombre: usuario?.nombre ?? "Usuario",
              fotoUrl: usuario?.fotoUrl,
              usuarioVM: usuarioVM,
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 38.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Esta es tú agenda",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colores.textoOscuro,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Consumer<TareaViewModel>(
                builder: (context, tareaVM, _) {
                  if (tareaVM.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tareas = tareaVM.tareas;
                  if (tareas.isEmpty) {
                    return const Center(child: Text("No hay tareas.",
                      style: TextStyle(color: Colores.textoOscuro
                      )
                    ));
                  }

                  final hoy = DateTime.now();
                  final tareasHoy = tareas.where((t) =>
                      t.fecha.year == hoy.year &&
                      t.fecha.month == hoy.month &&
                      t.fecha.day == hoy.day).toList();

                  final futuras = tareas.where((t) =>
                      t.fecha.isAfter(DateTime(
                          hoy.year, hoy.month, hoy.day))).toList();

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 38.0),
                    child: ListView(
                      children: [
                        if (tareasHoy.isNotEmpty) ...[
                          const Text("Hoy", style: _seccionStyle),
                          const SizedBox(height: 8),
                          ...tareasHoy.map((t) => _buildTareaCard(t)),
                          const SizedBox(height: 20),
                        ],
                        if (futuras.isNotEmpty) ...[
                          const Text("Más adelante", style: _seccionStyle),
                          const SizedBox(height: 8),
                          ...futuras.map((t) => _buildTareaCard(t)),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _seccionStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colores.textoOscuro,
  );

  Widget _buildTareaCard(Tarea tarea) {
    final tareaVM = Provider.of<TareaViewModel>(context, listen: false);
    final esCompletada = tarea.estado.toLowerCase() == "completada";

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        child: Row(
          children: [
            //estado
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: esCompletada ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),

            //yítulo y estado
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tarea.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colores.textoOscuro,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tarea.estado,
                    style: TextStyle(
                      color: esCompletada ? Colors.green : Colors.red,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // fecha
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(
                DateFormat("d MMM", 'es_ES').format(tarea.fecha),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),

            // botones
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colores.azulPrincipal),
                  onPressed: () {
                    Navigator.pushNamed(context, '/editar', arguments: tarea);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.check, size: 20, color: Colores.azulPrincipal), //volver a poner la cajita
                  onPressed: () {
                    final nueva = tarea.copyWith(estado: 'Completada');
                    tareaVM.actualizarTarea(nueva);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete,
                      size: 20, color: Colores.textoOscuro),
                  onPressed: () {
                    tareaVM.eliminarTarea(tarea.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
