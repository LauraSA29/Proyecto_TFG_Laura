import '/domain/entities/tarea.dart';

// datos tarea para la conversión entre JSON y dominio
class TareaModel {
  final String id;
  final String titulo;
  final String descripcion;
  final String estado;
  final String fecha;
  final int proyectoId;
  final List<int> userIds;
  final String? asignado;

  TareaModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.estado,
    required this.fecha,
    required this.proyectoId,
    required this.userIds,
    this.asignado,
  });

  // instancia a partir de un mapa JSON
  factory TareaModel.fromJson(Map<String, dynamic> json) {
    return TareaModel(
      id: json['id'].toString(),
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      estado: json['estado'],
      fecha: json['fecha_limite'],
      proyectoId: json['proyecto_id'],
      userIds: List<int>.from(json['user_ids'] ?? []),
      asignado: json['asignado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'estado': estado, // modelo a un mapa.
      'fecha_limite': fecha,
      'proyecto_id': proyectoId,
      'user_ids': userIds,
      'asignado': asignado,
    };
  }

// modelo a dominio 
  Tarea toEntity() => Tarea(
        id: id,
        titulo: titulo,
        descripcion: descripcion,
        estado: estado,
        fecha: DateTime.parse(fecha),
        proyectoId: proyectoId,
        userIds: userIds,
        asignado: asignado,
      );

  static TareaModel fromEntity(Tarea tarea) {
    return TareaModel(
      id: tarea.id,
      titulo: tarea.titulo,
      descripcion: tarea.descripcion,
      estado: tarea.estado,
      fecha: tarea.fecha.toIso8601String(), // instancia a partir de dominio
      proyectoId: tarea.proyectoId,
      userIds: tarea.userIds,
      asignado: tarea.asignado,
    );
  }
}
