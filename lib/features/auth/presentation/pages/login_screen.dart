import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';
import '../../../../core/states/view_state.dart';
import '../providers/auth_provider.dart';
import '../../../../core/local_storage/storage_service.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';

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
      final String roleStr = (authProvider.user!.rol).toLowerCase();

      if (roleStr.contains('admin') || roleStr.contains('administrador')) {
        authProvider.logout();
        _showSnackBar('Esta aplicación es exclusiva para clientes. Las cuentas de administrador no tienen acceso.', Colors.red);
        return;
      }

      await _storageService.saveAuthData(
       authProvider.user!.id,       // 1. ID
       authProvider.user!.token,    // 2. Token
       authProvider.user!.usuario,  // 3. Usuario
      authProvider.user!.rol,      // 4. Rol
      );

      context.go('/home');
    } else {
      final String msg = authProvider.errorMessage ?? 'Credenciales incorrectas';
      if (msg.toLowerCase().contains('suspendida')) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Cuenta Suspendida', style: TextStyle(fontWeight: FontWeight.bold)),
            content: Text(msg),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Aceptar'),
              ),
            ],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
        );
      } else {
        _showSnackBar(msg, Colors.red);
      }
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
    final isLoading = context.watch<AuthProvider>().state == ViewState.loading;

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
                  color: Colors.black.withValues(alpha: 0.04),
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
                CustomTextField(
                  controller: _correoController,
                  hintText: 'Correo electrónico',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 18),

                // PASSWORD
                CustomTextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  hintText: 'Contraseña',
                  prefixIcon: Icons.lock_outline_rounded,
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
                PrimaryButton(
                  onPressed: _login,
                  text: 'Ingresar',
                  isLoading: isLoading,
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
}
