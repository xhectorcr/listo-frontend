import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import '../../../../core/local_storage/storage_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final StorageService _storageService = StorageService();

  bool _obscurePassword = true;

  final Color primaryColor = const Color(0xFFFF5A1F);

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (_correoController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _showSnackBar('Completa tu correo y contraseña', Colors.orange);
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.login(
      _correoController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      await _storageService.saveAuthData(
       authProvider.user!.id,       // 1. ID
       authProvider.user!.token,    // 2. Token
       authProvider.user!.usuario,  // 3. Usuario
      authProvider.user!.rol,      // 4. Rol
      );

      final String roleStr = (authProvider.user!.rol).toLowerCase();

      if (roleStr.contains('admin') || roleStr.contains('administrador')) {
        context.go('/admin');
      } else {
        context.go('/home');
      }
    } else {
      _showSnackBar(
        authProvider.errorMessage ?? 'Credenciales incorrectas',
        Colors.red,
      );
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool mobile = MediaQuery.of(context).size.width < 700;
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Container(
            width: double.infinity,

            constraints: const BoxConstraints(maxWidth: 430),

            padding: EdgeInsets.all(mobile ? 28 : 36),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                // LOGO
                Container(
                  width: 75,
                  height: 75,

                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(22),
                  ),

                  child: const Center(
                    child: Text(
                      'L!',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // TITLE
                const Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111111),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Ingresa para continuar',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 36),

                // EMAIL
                _input(
                  controller: _correoController,
                  hint: 'Correo electrónico',
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 18),

                // PASSWORD
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,

                  decoration: InputDecoration(
                    hintText: 'Contraseña',

                    prefixIcon: const Icon(Icons.lock_outline_rounded),

                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },

                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
                    ),

                    filled: true,
                    fillColor: const Color(0xFFF7F7F7),

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),

                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),

                      borderSide: BorderSide(color: primaryColor, width: 2),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Align(
                  alignment: Alignment.centerRight,

                  child: TextButton(
                    onPressed: () {},

                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: isLoading ? null : _login,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,

                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Ingresar',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 28),

                // REGISTER
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      '¿No tienes cuenta?',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),

                    TextButton(
                      onPressed: () {
                        context.push('/register');
                      },

                      child: Text(
                        'Crear cuenta',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,

      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: Icon(icon),

        filled: true,
        fillColor: const Color(0xFFF7F7F7),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),

          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
    );
  }
}
