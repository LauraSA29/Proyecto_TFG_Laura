import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/domain/entities/tarea.dart';
import '/presentation/viewmodels/tarea_viewmodel.dart';
import '/presentation/viewmodels/usuario_viewmodel.dart';
import '/presentation/widget/header_widget.dart';
import '/theme/colores.dart';

class EditarTareaScreen extends StatefulWidget { //esto se puede reutilizar, crear y editar, solo cambiar ciertas cosillas
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

  List<String> _usuarios = [];
  String? _usuarioSeleccionado;
  bool _cargandoUsuarios = true;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.tarea.titulo);
    _descripcionController = TextEditingController(text: widget.tarea.descripcion);
    _fechaSeleccionada = widget.tarea.fecha;
    _usuarioSeleccionado = widget.tarea.asignado;
    _cargarUsuarios();
  }

  Future<void> _cargarUsuarios() async {
    try {
      final tareaVM = Provider.of<TareaViewModel>(context, listen: false);
      final usuarios = await tareaVM.obtenerUsuarios();
      setState(() {
        _usuarios = usuarios;
        _cargandoUsuarios = false;
      });
    } catch (e) {
      setState(() {
        _usuarios = [];
        _cargandoUsuarios = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar los usuarios')),
      );
    }
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

  void _editarTarea() async {
    final titulo = _tituloController.text.trim();
    final descripcion = _descripcionController.text.trim();
    final fecha = _fechaSeleccionada;
    final asignado = _usuarioSeleccionado;

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
                         fecha == widget.tarea.fecha &&
                         asignado == widget.tarea.asignado;

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
      asignado: asignado,
      proyectoId: widget.tarea.proyectoId,
      userIds: widget.tarea.userIds,
    );

    await tareaVM.actualizarTarea(tareaEditada);
    setState(() => _enviando = false);
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    final usuarioVM = Provider.of<UsuarioViewModel>(context);
    final usuario = usuarioVM.usuario;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/img/Fondo.png',
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  HeaderWidget(
                    nombre: usuario?.nombre ?? "Usuario",
                    fotoUrl: usuario?.fotoUrl,
                    usuarioVM: usuarioVM,
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 38.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Editar tarea:",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colores.textoOscuro,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 38),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _texto(
                          controller: _tituloController,
                          label: "Título",
                          errorText: errorTitulo,
                        ),
                        const SizedBox(height: 20),
                        _cargandoUsuarios
                            ? const Center(child: CircularProgressIndicator())
                            : DropdownButtonFormField<String>(
                                value: _usuarioSeleccionado,
                                items: _usuarios.map((usuario) {
                                  return DropdownMenuItem(
                                    value: usuario,
                                    child: Text(usuario),
                                  );
                                }).toList(),
                                decoration: _deco("Asignar tarea a"),
                                onChanged: (valor) {
                                  setState(() => _usuarioSeleccionado = valor);
                                },
                              ),
                        const SizedBox(height: 30),
                        _fecha(),
                        const SizedBox(height: 20),
                        _texto(
                          controller: _descripcionController,
                          label: "Descripción de la tarea",
                          errorText: errorDescripcion,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 40),
                        _enviando
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _editarTarea,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colores.azulPrincipal,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  "Guardar cambios",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 32, 124, 230),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _texto({
    required TextEditingController controller,
    required String label,
    String? errorText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: _deco(label).copyWith(errorText: errorText),
    );
  }

  Widget _fecha() {
    return Row(
      children: [
        Expanded(
          child: Text(
            "Fecha: ${_fechaSeleccionada.day}/${_fechaSeleccionada.month}/${_fechaSeleccionada.year}",
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          onPressed: _seleccionarFecha,
          icon: const Icon(Icons.calendar_today),
          color: Colores.azulPrincipal,
          tooltip: 'Haz clic para cambiar la fecha',
        ),
      ],
    );
  }

  InputDecoration _deco(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colores.fondoCampos,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
