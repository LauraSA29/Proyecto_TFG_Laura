class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final String tipo; // "admin" o "normal"

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.tipo,
  });

  bool get esAdmin => tipo.toLowerCase() == 'admin';
}
