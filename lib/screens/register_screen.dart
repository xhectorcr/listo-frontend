import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;

  final Color primaryColor = const Color(0xFFFF5A1F);

  Future<void> _registrar() async {
    FocusScope.of(context).unfocus();

    if (_dniController.text.trim().isEmpty ||
        _nombreController.text.trim().isEmpty ||
        _correoController.text.trim().isEmpty ||
        _telefonoController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      _showSnackBar('Completa todos los campos', Colors.orange);
      return;
    }

    if (_dniController.text.trim().length != 8) {
      _showSnackBar('El DNI debe tener 8 dígitos', Colors.orange);
      return;
    }

    setState(() => _isLoading = true);

    final response = await _authService.registrarCliente(
      _nombreController.text.trim(),
      _correoController.text.trim(),
      _passwordController.text,
      _telefonoController.text.trim(),
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (response['success'] == true) {
      _showSnackBar(
        response['message'] ?? 'Cuenta creada correctamente',
        Colors.green,
      );

      await Future.delayed(const Duration(milliseconds: 700));

      if (!mounted) return;

      Navigator.pop(context);
    } else {
      _showSnackBar(
        response['message'] ?? 'No se pudo completar el registro',
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
    _dniController.dispose();
    _nombreController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool mobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),

              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 48,
                ),
                child: Center(
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
                // BACK
                Align(
                  alignment: Alignment.centerLeft,

                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                ),

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

                const SizedBox(height: 26),

                // TITLE
                const Text(
                  'Crear cuenta',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111111),
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Completa tus datos',
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 34),

                // NAME
                _input(
                  controller: _nombreController,
                  hint: 'Nombre completo',
                  icon: Icons.person_outline_rounded,
                  textCapitalization: TextCapitalization.words,
                ),

                const SizedBox(height: 18),

                // DNI
                _input(
                  controller: _dniController,
                  hint: 'DNI',
                  icon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 18),

                // EMAIL
                _input(
                  controller: _correoController,
                  hint: 'Correo electrónico',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 18),

                // PHONE
                _input(
                  controller: _telefonoController,
                  hint: 'Teléfono',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 18),

                // PASSWORD
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) {
                    if (!_isLoading) _registrar();
                  },

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

                const SizedBox(height: 30),

                // BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 58,

                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _registrar,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,

                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Crear cuenta',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // LOGIN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Text(
                      '¿Ya tienes cuenta?',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      child: Text(
                        'Iniciar sesión',
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
          },
        ),
      ),
    );
  }

  Widget _input({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      textInputAction: TextInputAction.next,

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
