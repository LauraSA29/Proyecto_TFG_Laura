import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/domain/entities/tarea.dart';
import '/theme/colores.dart';
import '/presentation/viewmodels/tarea_viewmodel.dart';
import 'editar_tarea_screen.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  String filtroTipo = 'Tareas';
  String filtroEstado = 'Todas';
  bool ordenAscendente = true;
  String busqueda = '';


  @override
  void initState() {
    super.initState();
    final vm = Provider.of<TareaViewModel>(context, listen: false);
    vm.cargarTareas();
  }

  @override
  Widget build(BuildContext context) {
    final tareaVM = Provider.of<TareaViewModel>(context);
    final tareas = tareaVM.tareas;

    final hoy = DateTime.now();
    final hoyTareas = tareas.where((t) =>
        t.fecha.year == hoy.year &&
        t.fecha.month == hoy.month &&
        t.fecha.day == hoy.day).toList();

    final futuras = tareas.where((t) =>
        t.fecha.isAfter(DateTime(hoy.year, hoy.month, hoy.day))).toList();

    List<Tarea> tareasFiltradas = tareas;

    // Filtrar por tipo (por ahora solo 'Tareas' tiene contenido)
    if (filtroTipo != 'Todo' && filtroTipo != 'Tareas') {
      tareasFiltradas = []; // En el futuro filtrará Reuniones/Pedidos
    }

    // Filtrar por estado
    if (filtroEstado == 'Pendientes') {
      tareasFiltradas = tareasFiltradas.where((t) => t.estado.toLowerCase() == 'pendiente').toList();
    } else if (filtroEstado == 'Completadas') {
      tareasFiltradas = tareasFiltradas.where((t) => t.estado.toLowerCase() == 'completada').toList();
    }

    if (busqueda.isNotEmpty) {
      tareasFiltradas = tareasFiltradas.where((t) {
        return t.titulo.toLowerCase().contains(busqueda) ||
              t.descripcion.toLowerCase().contains(busqueda);
      }).toList();
    }

    tareasFiltradas.sort((a, b) {
        if (ordenAscendente) {
          return a.fecha.compareTo(b.fecha);
        } else {
          return b.fecha.compareTo(a.fecha);
        }
      }
    );


    return Scaffold(
      backgroundColor: AppColors.fondoClaro,
      body: Column(
        children: [
          // Encabezado curvo sencillo con esquina redonda
          Container(
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
                  onPressed: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          const Text(
            "Agenda",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textoOscuro,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar por título o descripción",
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  busqueda = value.trim().toLowerCase();
                });
              },
            ),
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Orden por fecha",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoOscuro,
                ),
              ),
              IconButton(
                icon: Icon(
                  ordenAscendente ? Icons.arrow_upward : Icons.arrow_downward,
                  color: AppColors.textoOscuro,
                ),
                tooltip: ordenAscendente ? "Más antiguas primero" : "Más recientes primero",
                onPressed: () => setState(() {
                  ordenAscendente = !ordenAscendente;
                }),
              ),
            ],
          ),


          const SizedBox(height: 10),

          // Filtros tipo tabla
          // Filtro por tipo
          Container(
            color: AppColors.grisCampos.withOpacity(0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Todo', 'Tareas', 'Reuniones', 'Pedidos'].map((tipo) {
                final isActive = tipo == filtroTipo;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => filtroTipo = tipo),
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
          ),

          // Filtro por estado
          Container(
            color: AppColors.grisCampos.withOpacity(0.15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Todas', 'Pendientes', 'Completadas'].map((estado) {
                final isActive = estado == filtroEstado;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => filtroEstado = estado),
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
                        estado,
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
          ),


          Expanded(
            child: tareaVM.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: [
                      if (hoyTareas.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Hoy",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textoOscuro,
                            ),
                          ),
                        ),
                        ...hoyTareas.map((t) => TareaItem(tarea: t)),
                      ],
                      if (futuras.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Más adelante",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textoOscuro,
                            ),
                          ),
                        ),
                        ...futuras.map((t) => TareaItem(tarea: t)),
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
}

// Widget para mostrar cada tarea
class TareaItem extends StatelessWidget {
  final Tarea tarea;

  const TareaItem({super.key, required this.tarea});

  @override
  Widget build(BuildContext context) {
    final estadoCompletada = tarea.estado.toLowerCase() == 'completada';
    final estadoColor = estadoCompletada ? Colors.green : Colors.red;
    final estadoTexto = estadoCompletada ? 'Completada' : 'Pendiente';

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
                Text(
                  tarea.titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  estadoTexto,
                  style: TextStyle(color: estadoColor, fontSize: 13),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                "${tarea.fecha.day} ${_mes(tarea.fecha.month)}",
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!estadoCompletada)
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      tooltip: 'Marcar como completada',
                      onPressed: () async {
                        await Provider.of<TareaViewModel>(context, listen: false)
                            .actualizarEstado(tarea.id, 'completada');
                      },
                    ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
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
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmarEliminar(context, tarea.id),
                  ),
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
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
