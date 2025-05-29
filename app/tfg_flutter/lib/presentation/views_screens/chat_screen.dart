import 'package:flutter/material.dart';
import '/theme/colores.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  final List<Map<String, String>> messages = const [
    {
      "name": "Claudia Alves",
      "message": "Recuerda que la reunión es mañana a las 9:30",
      "time": "hace 3m",
      "image": "assets/images/user1.jpg"
    },
    {
      "name": "Alba",
      "message": "¿Puedes mirar el documento de ayer?",
      "time": "hace 5m",
      "image": "assets/images/user1.jpg"
    },
    {
      "name": "Alberto",
      "message": "Hay que arreglar el servidor antes del viernes.",
      "time": "hace 2h",
      "image": "assets/images/user1.jpg"
    },
    {
      "name": "Dani Martínez",
      "message": "¿Te parece bien este diseño?",
      "time": "hace 3h",
      "image": "assets/images/user2.jpg"
    },
    {
      "name": "Kimberly Nguyen",
      "message": "Voy a llegar un poco tarde hoy.",
      "time": "hace 5h",
      "image": "assets/images/user3.jpg"
    },
    {
      "name": "Daniel",
      "message": "Estoy de reunión, luego te escribo.",
      "time": "hace 7h",
      "image": "assets/images/user3.jpg"
    },
    {
      "name": "Mariana Napolitani",
      "message": "Tengo que recoger el paquete.",
      "time": "Ayer",
      "image": "assets/images/user4.jpg"
    },
    {
      "name": "Adrián",
      "message": "Hay un problema con la impresora.",
      "time": "hace 2d",
      "image": "assets/images/user4.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fondoClaro,
      body: Column(
        children: [
          // Encabezado curvo con estilo Tasknelia
          Stack(
            children: [
              ClipPath(
                clipper: HeaderClipper(),
                child: Container(
                  height: 110,
                  color: AppColors.azulPrincipal,
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage("assets/profile.jpg"),
                        ),
                        const Text(
                          "¡Bienvenido!",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: AppColors.textoOscuro,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.home_outlined),
                          color: AppColors.textoOscuro,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Lista de mensajes
          Expanded(
            child: ListView.separated(
              itemCount: messages.length,
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(message["image"]!),
                  ),
                  title: Text(
                    message["name"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(message["message"]!),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message["time"]!,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      const Icon(Icons.more_horiz, size: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Clipper para encabezado curvo
class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
