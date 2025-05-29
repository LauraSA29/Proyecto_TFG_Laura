import '/domain/entities/tarea.dart';

class TareaModel {
  final String id;
  final String titulo;
  final String descripcion;
  final String estado;
  final String fecha;

  TareaModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.estado,
    required this.fecha,
  });

  factory TareaModel.fromJson(Map<String, dynamic> json) {
    return TareaModel(
      id: json['id'].toString(),
      titulo: json['titulo'],
      descripcion: json['descripcion'],
      estado: json['estado'],
      fecha: json['fecha_limite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descripcion': descripcion,
      'estado': estado,
      'fecha_limite': fecha,
    };
  }

  Tarea toEntity() => Tarea(
    id: id,
    titulo: titulo,
    descripcion: descripcion,
    estado: estado,
    fecha: DateTime.parse(fecha),
  );

  static TareaModel fromEntity(Tarea tarea) {
    return TareaModel(
      id: tarea.id,
      titulo: tarea.titulo,
      descripcion: tarea.descripcion,
      estado: tarea.estado,
      fecha: tarea.fecha.toIso8601String(),
    );
  }
}
