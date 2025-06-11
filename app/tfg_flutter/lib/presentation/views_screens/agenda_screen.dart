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
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/img/Fondo.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
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
                        return const Center(
                          child: Text(
                            "No hay tareas.",
                            style: TextStyle(color: Colores.textoOscuro),
                          ),
                        );
                      }

                      final hoy = DateTime.now();
                      final tareasHoy = tareas.where((t) =>
                          t.fecha.year == hoy.year &&
                          t.fecha.month == hoy.month &&
                          t.fecha.day == hoy.day).toList();

                      final futuras = tareas.where((t) =>
                          t.fecha.isAfter(DateTime(hoy.year, hoy.month, hoy.day))).toList();

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 38.0),
                        child: ListView(
                          children: [
                            if (tareasHoy.isNotEmpty) ...[
                              const Text("Hoy", style: _seccionStyle),
                              const SizedBox(height: 8),
                              ...tareasHoy.map((t) => _buildTarea(t)),
                              const SizedBox(height: 20),
                            ],
                            if (futuras.isNotEmpty) ...[
                              const Text("Más adelante", style: _seccionStyle),
                              const SizedBox(height: 8),
                              ...futuras.map((t) => _buildTarea(t)),
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
        ],
      ),
    );
  }

  static const _seccionStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colores.textoOscuro,
  );

//le faltaban cosas, arreglado de manera rápida
  Widget _buildTarea(Tarea tarea) {
    final tareaVM = Provider.of<TareaViewModel>(context, listen: false);
    final esCompletada = tarea.estado.toLowerCase() == "completada" || tarea.estado.toLowerCase() == "done";

    // estado a español
    String estadoTraducido = tarea.estado.toLowerCase() == "done"
        ? "Completada"
        : tarea.estado.toLowerCase() == "new"
            ? "Pendiente"
            : tarea.estado.toLowerCase() == "in progress"
              ? "En progreso"
              : tarea.estado;

    // para quitar las etiquetas <p> que salian al leer la descripción
    final RegExp htmlTag = RegExp(r"<[^>]*>");
    final descripcion = tarea.descripcion.replaceAll(htmlTag, "").trim();

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colores.fondoCampos,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //estado
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: esCompletada ? const Color.fromARGB(255, 70, 170, 73) : const Color.fromARGB(255, 197, 51, 41),
                shape: BoxShape.circle,
              ),
            ),

            //yítulo y estado
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // título
                  Text(
                    tarea.titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colores.textoOscuro,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // estado
                  Text(
                    estadoTraducido,
                    style: TextStyle(
                      color: esCompletada ? const Color.fromARGB(255, 70, 170, 73) : const Color.fromARGB(255, 197, 51, 41),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // persona asignada
                  Text(
                    "Asignado a: ${tarea.asignado?.isNotEmpty == true ? tarea.asignado : 'Sin asignar'}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // descripción
                  Text(
                    descripcion,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colores.textoOscuro,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // fecha
                Text(
                  DateFormat("d MMM", 'es_ES').format(tarea.fecha),
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 48),


                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20, color: Colores.azulPrincipal),
                      onPressed: () {
                        Navigator.pushNamed(context, '/editar', arguments: tarea);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        esCompletada ? Icons.check_box : Icons.check_box_outline_blank,
                        size: 20,
                        color: Colores.azulPrincipal,
                      ),
                      onPressed: () {
                        final nuevoEstado = esCompletada ? 'New' : 'Done';
                        tareaVM.actualizarEstado(tarea.id, nuevoEstado);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Colores.textoOscuro),
                      onPressed: () {
                        tareaVM.eliminarTarea(tarea.id);
                      },
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
