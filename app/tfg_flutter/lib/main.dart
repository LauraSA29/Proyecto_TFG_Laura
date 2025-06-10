import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'data/datasources/tarea_remote_datasource.dart';
import 'data/datasources/usuario_remote_datasource.dart';
import 'data/datasources/home_remote_datasource.dart';
import 'data/repositories/tarea_repository_impl.dart';
import 'data/repositories/usuario_repository_impl.dart';

import 'domain/usecases/actualizar_estado_tarea.dart';
import 'domain/usecases/crear_tarea.dart';
import 'domain/usecases/eliminar_tarea.dart';
import 'domain/usecases/obtener_tareas.dart';
import 'domain/usecases/obtener_usuario.dart';

import 'presentation/viewmodels/tarea_viewmodel.dart';
import 'presentation/viewmodels/usuario_viewmodel.dart';
import 'presentation/viewmodels/login_viewmodel.dart';
import 'presentation/viewmodels/home_viewmodel.dart';
import 'presentation/viewmodels/chat_viewmodel.dart';
import 'presentation/routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 

  initializeDateFormatting('es', null); 

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //dataSources
    final tareaRemote = TareaRemoteDataSource();
    final usuarioRemote = UsuarioRemoteDataSource();
    final homeRemote = HomeRemoteDataSource();

    // repositories
    final tareaRepo = TareaRepositoryImpl(tareaRemote);
    final usuarioRepo = UsuarioRepositoryImpl(usuarioRemote);

    //useCases
    final obtenerTareasUC = ObtenerTareasUseCase(tareaRepo);
    final crearTareaUC = CrearTareaUseCase(tareaRepo);
    final actualizarEstadoUC = ActualizarEstadoTareaUseCase(tareaRepo);
    final eliminarTareaUC = EliminarTareaUseCase(tareaRepo);
    final obtenerUsuarioUC = ObtenerUsuarioUseCase(usuarioRepo);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => UsuarioViewModel(obtenerUsuarioUC)),
        ChangeNotifierProvider(create: (_) => TareaViewModel(
          obtenerTareasUseCase: obtenerTareasUC,
          crearTareaUseCase: crearTareaUC,
          actualizarEstadoUseCase: actualizarEstadoUC,
          eliminarTareaUseCase: eliminarTareaUC,
        )),

        ChangeNotifierProvider(create: (_) => HomeViewModel(homeRemote)),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tasknelia', //nombre app
        initialRoute: Rutas.login,
        routes: Rutas.getRoutes(),
      ),
    );
  }
}
