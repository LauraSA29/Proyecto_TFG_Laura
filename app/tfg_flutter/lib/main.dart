import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/routes/routes.dart';
import 'presentation/viewmodels/tarea_viewmodel.dart';
import 'presentation/viewmodels/login_viewmodel.dart';
import 'data/repositories/tarea_repository_impl.dart';
import 'data/datasources/tarea_remote_datasource_impl.dart';
import 'domain/usecases/actualizar_estado_tarea.dart';
import 'domain/usecases/crear_tarea.dart';
import 'domain/usecases/eliminar_tarea.dart';
import 'domain/usecases/obtener_tareas.dart';
import 'domain/usecases/login_usuario.dart';
import '/data/repositories/usuario_repository_impl.dart';


void main() {
  final tareaRemote = TareaRemoteDataSourceImpl();
  final tareaRepository = TareaRepositoryImpl(tareaRemote);
  final usuarioRepository = UsuarioRepositoryImpl();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TareaViewModel(
            obtenerTareasUseCase: ObtenerTareasUseCase(tareaRepository),
            crearTareaUseCase: CrearTareaUseCase(tareaRepository),
            actualizarEstadoUseCase: ActualizarEstadoTareaUseCase(tareaRepository),
            eliminarTareaUseCase: EliminarTareaUseCase(tareaRepository),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(
            loginUsuarioUseCase: LoginUsuarioUseCase(usuarioRepository),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasknelia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.getRoutes(),
    );
  }
}
