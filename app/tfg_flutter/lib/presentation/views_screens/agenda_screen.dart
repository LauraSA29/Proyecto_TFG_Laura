import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/domain/entities/tarea.dart';
import '/theme/colores.dart';
import '/presentation/viewmodels/tarea_viewmodel.dart';
import '/presentation/viewmodels/usuario_viewmodel.dart';
import 'editar_tarea_screen.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  String filtroActual = 'Todo';

  @override
  void initState() {
    super.initState();
    Provider.of<TareaViewModel>(context, listen: false).cargarTareas();
  }

  @override
  Widget build(BuildContext context) {
    final tareaVM = Provider.of<TareaViewModel>(context);
    final usuarioVM = Provider.of<UsuarioViewModel>(context);
    final isAdmin = usuarioVM.usuario?.tipo.toLowerCase() == 'admin';

    final tareas = tareaVM.tareas;
    final hoy = DateTime.now();
    final hoyTareas = tareas.where((t) =>
        t.fecha.year == hoy.year &&
        t.fecha.month == hoy.month &&
        t.fecha.day == hoy.day).toList();

    final futuras = tareas.where((t) =>
        t.fecha.isAfter(DateTime(hoy.year, hoy.month, hoy.day))).toList();

    return Scaffold(
      backgroundColor: AppColors.fondoClaro,
      body: Column(
        children: [
          _buildEncabezado(),
          const SizedBox(height: 10),
          const Text(
            "Agenda",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textoOscuro,
            ),
          ),
          const SizedBox(height: 10),
          _buildFiltroTipo(),
          Expanded(
            child: tareaVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      if (hoyTareas.isNotEmpty) ...[
                        _seccion("Hoy"),
                        ...hoyTareas.map((t) => TareaItem(tarea: t, isAdmin: isAdmin)),
                      ],
                      if (futuras.isNotEmpty) ...[
                        _seccion("Más adelante"),
                        ...futuras.map((t) => TareaItem(tarea: t, isAdmin: isAdmin)),
                      ],
                      if (hoyTareas.isEmpty && futuras.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 40),
                            child: Text(
                              "No hay tareas próximas.",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEncabezado() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.azulPrincipal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(80),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage('assets/profile.jpg'),
          ),
          const Text(
            "¡Bienvenido!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
    );
  }

  Widget _buildFiltroTipo() {
    return Container(
      color: AppColors.grisCampos.withOpacity(0.3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: ['Todo', 'Tareas', 'Reuniones', 'Pedidos'].map((tipo) {
          final isActive = tipo == filtroActual;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => filtroActual = tipo),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.grisCampos : Colors.transparent,
                  border: Border(
                    right: BorderSide(
                      color: Colors.white.withOpacity(0.4),
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  tipo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    color: AppColors.textoOscuro,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _seccion(String texto) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        texto,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: AppColors.textoOscuro,
        ),
      ),
    );
  }
}

class TareaItem extends StatelessWidget {
  final Tarea tarea;
  final bool isAdmin;

  const TareaItem({super.key, required this.tarea, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final estadoColor = tarea.estado.toLowerCase() == 'completada' ? Colors.green : Colors.red;
    final estadoTexto = tarea.estado.toLowerCase() == 'completada' ? 'Completada' : 'Pendiente';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grisCampos),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(Icons.circle, color: estadoColor, size: 10),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tarea.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(estadoTexto, style: TextStyle(color: estadoColor, fontSize: 13)),
              ],
            ),
          ),
          Column(
            children: [
              Text("${tarea.fecha.day} ${_mes(tarea.fecha.month)}",
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      tarea.estado.toLowerCase() == 'completada'
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      color: AppColors.azulPrincipal,
                    ),
                    onPressed: () {
                      final nuevoEstado = tarea.estado.toLowerCase() == 'completada'
                          ? 'pendiente'
                          : 'completada';
                      Provider.of<TareaViewModel>(context, listen: false)
                          .actualizarEstado(tarea.id, nuevoEstado);
                    },
                  ),
                  if (isAdmin) ...[
                    IconButton(
                      icon: const Icon(Icons.edit, color: AppColors.azulPrincipal),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditarTareaScreen(tarea: tarea),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: AppColors.grisCampos),
                      onPressed: () => _confirmarEliminar(context, tarea.id),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmarEliminar(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar tarea"),
        content: const Text("¿Estás segura de que quieres eliminar esta tarea?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await Provider.of<TareaViewModel>(context, listen: false).eliminarTarea(id);
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _mes(int mes) {
    const meses = [
      '', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'
    ];
    return meses[mes];
  }
}
