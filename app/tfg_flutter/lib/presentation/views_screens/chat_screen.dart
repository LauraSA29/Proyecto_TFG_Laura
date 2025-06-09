
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme/colores.dart';
import '/presentation/viewmodels/usuario_viewmodel.dart';
import '/presentation/widget/header_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

//ESto es para simular los mensajes jaja
  final List<Map<String, String>> messages = const [
    {
      "nombre": "Claudia",
      "msg": "Recuerda que la reunión es mañana a las 9:30",
      "hora": "hace 3m",
      "img": "assets/img/claudia.png", //revisar por qué no funcioan las fotos
    },
    {
      "nombre": "Alba",
      "msg": "¿Puedes mirar el documento de ayer? :)",
      "hora": "hace 5m",
      "img": "assets/img/alba.png",
    },
    {
      "nombre": "Alberto",
      "msg": "Hay que arreglar el servidor antes del viernes.",
      "hora": "hace 2h",
      "img": "assets/img/alberto.png",
    },
    {
      "nombre": "Dani",
      "msg": "¿Te parece bien este diseño? 😊", //emojiii
      "hora": "hace 3h",
      "img": "assets/img/dani.png",
    },
    {
      "nombre": "Karen",
      "msg": "Voy a llegar un poco tarde hoy :(",
      "hora": "hace 5h",
      "img": "assets/img/karen.png",
    },
    {
      "nombre": "Daniel",
      "msg": "Estoy de reunión, luego te escribo.",
      "hora": "hace 7h",
      "img": "assets/img/daniel.png",
    },
    {
      "nombre": "Mariana",
      "msg": "Tengo que recoger el paquete.",
      "hora": "Ayer",
      "img": "assets/img/mariana.png",
    },
    {
      "nombre": "Adrián",
      "msg": "Hay un problema con la impresora.",
      "hora": "hace 2d",
      "img": "assets/img/adrian.png",
    },
    {
      "nombre": "Cristina",
      "msg": "Estoy haciendo cafe <3",
      "hora": "hace 2d",
      "img": "assets/img/cris.png",
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
                      backgroundImage: AssetImage(message["img"]!),
                    ),
                  ),
                  title: Text(
                    message["nombre"]!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colores.textoOscuro,
                    ),
                  ),
                  subtitle: Text(message["msg"]!),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message["hora"]!,
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
