// lib/domain/entities/Usuario.dart
class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final String tipo; // admin o normal
  final String? fotoUrl; //foton

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.tipo,
    this.fotoUrl,
  });

  bool get esAdmin => tipo.toLowerCase() == 'admin';
}
