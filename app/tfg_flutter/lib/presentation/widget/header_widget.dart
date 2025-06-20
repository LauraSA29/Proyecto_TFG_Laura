import 'dart:convert';
import 'package:flutter/material.dart';
import '/theme/colores.dart';
import '/presentation/viewmodels/usuario_viewmodel.dart';

//encabezado para poner en las screens, debido al error de git, esta la versión de salir hacia login
//reutilizable
class HeaderWidget extends StatelessWidget {
  final String nombre;
  final String? fotoUrl;
  final UsuarioViewModel usuarioVM;

  const HeaderWidget({
    Key? key,
    required this.nombre,
    this.fotoUrl,
    required this.usuarioVM,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipPath(
          clipper: HeaderClipper(),
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              color: Colores.azulPrincipal,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: const Border(
                bottom: BorderSide(
                  color: Colors.white70,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: const Alignment(0, -0.3),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 27,
                          backgroundImage: fotoUrl != null && fotoUrl!.isNotEmpty
                              ? MemoryImage(base64Decode(fotoUrl!))
                              : const AssetImage('assets/profile.jpg') as ImageProvider,
                        ),
                      ),
                      const SizedBox(width: 11),
                      Text(
                        "Hola, $nombre",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colores.textoOscuro,
                        ),
                      ),
                      const SizedBox(width: 1),
                      IconButton(
                        icon: const Icon(Icons.help_outline),
                        color: Colores.textoOscuro,
                        tooltip: 'Ver manual de usuario', //nuevo para el manual pero no va bien, pero se entiende que la idea era apra eso
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat_rounded),
                        color: Colores.textoOscuro,
                        tooltip: 'Tus chats',
                        onPressed: () {
                          Navigator.pushNamed(context, '/chat');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout),
                        color: Colores.textoOscuro,
                        onPressed: () async {
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/home'); //para ir a pantalla de inicio, debe arreglarse para que en home salga a login y en home se quite el usuario con usuarioVM.cerrarSesion()
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
