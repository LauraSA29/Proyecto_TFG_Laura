// lib/domain/entities/Tarea.dart
class Tarea {
  final String id;
  final String titulo;
  final String descripcion;
  final String estado;
  final DateTime fecha;
  final String? asignado; // usuarios
  final int proyectoId;
  final List<int> userIds;

  Tarea({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.estado,
    required this.fecha,
    this.asignado,
    required this.proyectoId,
    required this.userIds,
  });

//comentar despues
  Tarea copyWith({ //esto era para actualizar creando una copia
    String? id,
    String? titulo,
    String? descripcion,
    String? estado,
    DateTime? fecha, 
    String? asignado,
    int? proyectoId,
    List<int>? userIds,
  }) {
    return Tarea(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descripcion: descripcion ?? this.descripcion,
      estado: estado ?? this.estado,
      fecha: fecha ?? this.fecha,
      asignado: asignado ?? this.asignado,
      proyectoId: proyectoId ?? this.proyectoId,
      userIds: userIds ?? this.userIds,
    );
  }
  
}
