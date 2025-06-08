import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme/colores.dart';
import '/domain/entities/tarea.dart';
import '/presentation/viewmodels/tarea_viewmodel.dart';

class EditarTareaScreen extends StatefulWidget {
  final Tarea tarea;

  const EditarTareaScreen({super.key, required this.tarea});

  @override
  State<EditarTareaScreen> createState() => _EditarTareaScreenState();
}

class _EditarTareaScreenState extends State<EditarTareaScreen> {
  late TextEditingController _tituloController;
  late TextEditingController _descripcionController;
  late DateTime _fechaSeleccionada;

  bool _enviando = false;
  String? errorTitulo;
  String? errorDescripcion;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.tarea.titulo);
    _descripcionController = TextEditingController(text: widget.tarea.descripcion);
    _fechaSeleccionada = widget.tarea.fecha;
  }

  void _editarTarea() async {
    final titulo = _tituloController.text.trim();
    final descripcion = _descripcionController.text.trim();
    final fecha = _fechaSeleccionada;

    final tareaVM = Provider.of<TareaViewModel>(context, listen: false);

    setState(() {
      errorTitulo = null;
      errorDescripcion = null;
    });

    bool hayErrores = false;

    if (titulo.isEmpty) {
      setState(() => errorTitulo = 'El título es obligatorio');
      hayErrores = true;
    } else if (titulo.length < 3) {
      setState(() => errorTitulo = 'Mínimo 3 caracteres');
      hayErrores = true;
    }

    if (descripcion.isEmpty) {
      setState(() => errorDescripcion = 'La descripción es obligatoria');
      hayErrores = true;
    }

    if (fecha == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una fecha')),
      );
      hayErrores = true;
    }

    final existeDuplicada = tareaVM.tareas.any((t) =>
        t.id != widget.tarea.id &&
        t.titulo.toLowerCase() == titulo.toLowerCase() &&
        t.fecha.year == fecha.year &&
        t.fecha.month == fecha.month &&
        t.fecha.day == fecha.day);

    if (existeDuplicada) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya existe otra tarea con ese título y fecha')),
      );
      hayErrores = true;
    }

    if (hayErrores) return;

    final noHayCambios = titulo == widget.tarea.titulo.trim() &&
                         descripcion == widget.tarea.descripcion.trim() &&
                         fecha == widget.tarea.fecha;

    if (noHayCambios) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se han hecho cambios')),
      );
      return;
    }

    setState(() => _enviando = true);

    final tareaEditada = Tarea(
      id: widget.tarea.id,
      titulo: titulo,
      descripcion: descripcion,
      estado: widget.tarea.estado,
      fecha: fecha,
      asignado: widget.tarea.asignado,
      proyectoId: widget.tarea.proyectoId,
      userIds: widget.tarea.userIds,
    );

    await tareaVM.actualizarTarea(tareaEditada);
    setState(() => _enviando = false);
    Navigator.pop(context);
  }

  void _seleccionarFecha() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );

    if (picked != null) {
      setState(() => _fechaSeleccionada = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoClaro,
      appBar: AppBar(
        title: const Text("Editar Tarea"),
        backgroundColor: AppColors.azulPrincipal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(
                labelText: "Título",
                errorText: errorTitulo,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _descripcionController,
              decoration: InputDecoration(
                labelText: "Descripción",
                errorText: errorDescripcion,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Fecha: ${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}",
                  style: const TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: _seleccionarFecha,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.azulPrincipal,
                  ),
                  child: const Text("Cambiar Fecha"),
                ),
              ],
            ),
            const SizedBox(height: 24),

            _enviando
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: const Icon(Icons.check),
                    label: const Text("Guardar Cambios"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.azulPrincipal,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: _editarTarea,
                  ),
          ],
        ),
      ),
    );
  }
}
