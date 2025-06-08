import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/theme/colores.dart';
import '/presentation/viewmodels/login_viewmodel.dart';
import '/presentation/viewmodels/usuario_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _correoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _db = "odoo";

  @override
  Widget build(BuildContext context) {
    final loginVM = Provider.of<LoginViewModel>(context);
    final usuarioVM = Provider.of<UsuarioViewModel>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(top: 470, left: 20, child: _buildCircle(18, opacity: 0.2)),
            Positioned(top: 520, right: 25, child: _buildCircle(12, opacity: 0.2)),
            Positioned(bottom: 40, left: 30, child: _buildCircle(20, opacity: 0.1)),
            Positioned(bottom: 10, right: 20, child: _buildCircle(24, opacity: 0.1)),

            SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 5),
                  _buildTextField('Correo', Icons.email, _correoController, false),
                  const SizedBox(height: 25),
                  _buildTextField('Contraseña', Icons.vpn_key, _passwordController, true),
                  const SizedBox(height: 35),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/recuperar');
                    },
                    child: const Center(
                      child: Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  if (loginVM.error != null)
                    Text(loginVM.error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),

                  loginVM.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            final correo = _correoController.text.trim();
                            final password = _passwordController.text.trim();

                            if (correo.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Completa todos los campos")),
                              );
                              return;
                            }

                            final userId = await loginVM.login(_db, correo, password);

                            if (userId != null) {
                              await usuarioVM.cargarUsuarioDesdeOdoo(userId);
                              Navigator.pushReplacementNamed(context, '/home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Credenciales inválidas")),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colores.azulPrincipal,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(28),
                            side: const BorderSide(color: Color.fromARGB(255, 207, 206, 206), width: 2),
                          ),
                          child: const Icon(Icons.double_arrow, size: 40, color: Colors.white),
                        ),

                  const SizedBox(height: 100),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/registro');
                    },
                    child: const Center(
                      child: Text(
                        '¿No tienes una cuenta? Crea una',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        ClipPath(
          clipper: CurvedClipper(),
          child: Container(
            height: size.height * 0.40,
            width: double.infinity,
            color: Colores.azulPrincipal,
          ),
        ),
        Positioned(
          top: size.height * 0.10 - 20,
          left: size.width / 2 - 90,
          child: _buildCircle(24),
        ),
        Positioned(
          top: size.height * 0.10 - 10,
          right: size.width / 2 - 70,
          child: _buildCircle(16),
        ),
        Positioned(
          top: size.height * 0.10 + 80,
          right: size.width / 2 - 100,
          child: _buildCircle(20),
        ),
        Positioned(
          top: size.height * 0.10,
          left: size.width / 2 - 60,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const CircleAvatar(
              radius: 56,
              backgroundImage: AssetImage('assets/images/profile.jpg'),
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.27,
          left: 0,
          right: 0,
          child: const Center(
            child: Text(
              '¡Bienvenido!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colores.textoOscuro,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller, bool obscure) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(fontFamily: 'Roboto'),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colores.fondoCampos,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(double size, {double opacity = 1}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
