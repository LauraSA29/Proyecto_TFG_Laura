import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme/colores.dart';
import '/domain/entities/tarea.dart';
import '/presentation/viewmodels/tarea_viewmodel.dart';

class CrearTareaScreen extends StatefulWidget {
  const CrearTareaScreen({super.key});

  @override
  State<CrearTareaScreen> createState() => _CrearTareaScreenState();
}

class _CrearTareaScreenState extends State<CrearTareaScreen> {
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  DateTime? _fechaSeleccionada;

  bool _enviando = false;

  void _crearTarea() async {
    final titulo = _tituloController.text.trim();
    final descripcion = _descripcionController.text.trim();
    final fecha = _fechaSeleccionada;

    if (titulo.isEmpty || descripcion.isEmpty || fecha == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    setState(() => _enviando = true);

    final nuevaTarea = Tarea(
      id: '', // Se generará automáticamente en el repositorio
      titulo: titulo,
      descripcion: descripcion,
      estado: 'pendiente',
      fecha: fecha,
    );

    await Provider.of<TareaViewModel>(context, listen: false).crearTarea(nuevaTarea);

    setState(() => _enviando = false);

    Navigator.pop(context); // Volver atrás tras crear
  }

  void _seleccionarFecha() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _fechaSeleccionada = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Tarea"),
        backgroundColor: AppColors.azulPrincipal,
      ),
      backgroundColor: AppColors.fondoClaro,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _fechaSeleccionada == null
                        ? "Fecha no seleccionada"
                        : "${_fechaSeleccionada!.day}/${_fechaSeleccionada!.month}/${_fechaSeleccionada!.year}",
                  ),
                ),
                TextButton(
                  onPressed: _seleccionarFecha,
                  child: const Text("Seleccionar Fecha"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _enviando
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text("Crear Tarea"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.azulPrincipal,
                    ),
                    onPressed: _crearTarea,
                  )
          ],
        ),
      ),
    );
  }
}
