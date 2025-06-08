
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme/colores.dart';
import '/presentation/viewmodels/usuario_viewmodel.dart';
import '/presentation/widget/header_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  final List<Map<String, String>> messages = const [
    {
      "name": "Claudia",
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
      "name": "Dani",
      "message": "¿Te parece bien este diseño?",
      "time": "hace 3h",
      "image": "assets/images/user2.jpg"
    },
    {
      "name": "Karen",
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
      "name": "Mariana",
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
    {
      "name": "Adrián",
      "message": "Hay un problema con la impresora.",
      "time": "hace 2d",
      "image": "assets/images/user4.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    final usuarioVM = Provider.of<UsuarioViewModel>(context);
    final usuario = usuarioVM.usuario;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [

          HeaderWidget(
            nombre: usuario?.nombre ?? "Usuario",
            fotoUrl: usuario?.fotoUrl,
            usuarioVM: usuarioVM,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: messages.length,
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      backgroundImage: AssetImage(message["image"]!),
                    ),
                  ),
                  title: Text(
                    message["name"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colores.textoOscuro,
                    ),
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
