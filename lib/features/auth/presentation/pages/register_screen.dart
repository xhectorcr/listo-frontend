import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:listo_app/core/env/environment.dart';

import '../providers/auth_provider.dart';

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

  bool _obscurePassword = true;
  bool _isSearchingDni = false;

  final Color primaryColor = const Color(0xFFFF5A1F);

  Future<String> _getOrCreateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    if (deviceId == null) {
      final random = Random.secure();
      final values = List<int>.generate(16, (i) => random.nextInt(256));
      deviceId = values.map((e) => e.toRadixString(16).padLeft(2, '0')).join();
      await prefs.setString('device_id', deviceId);
    }
    return deviceId;
  }

  Future<void> _buscarDni(String dni) async {
    if (dni.length != 8) {
      _showSnackBar('El DNI debe tener 8 dígitos', Colors.orange);
      return;
    }

    setState(() {
      _isSearchingDni = true;
    });

    try {
      final deviceId = await _getOrCreateDeviceId();

      final response = await http.get(
        Uri.parse('${Environment.apiUrl}/usuario/dni/$dni'),
        headers: {
          'X-Device-ID': deviceId,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        final String nombres = data['nombres'] ?? data['first_name'] ?? '';
        final String apPaterno = data['apellidoPaterno'] ?? data['first_last_name'] ?? '';
        final String apMaterno = data['apellidoMaterno'] ?? data['second_last_name'] ?? '';
        
        String nombreCompleto = '';
        if (apPaterno.isNotEmpty || apMaterno.isNotEmpty) {
          nombreCompleto = '$nombres $apPaterno $apMaterno'.trim();
        } else {
          nombreCompleto = data['nombreCompleto'] ?? data['full_name'] ?? nombres;
        }

        if (nombreCompleto.isNotEmpty) {
          setState(() {
            _nombreController.text = nombreCompleto;
          });
          _showSnackBar('Datos de RENIEC cargados exitosamente', Colors.green);
        } else {
          _showSnackBar('No se encontraron nombres para este DNI', Colors.orange);
        }
      } else if (response.statusCode == 429) {
        final Map<String, dynamic> data = json.decode(response.body);
        _showSnackBar(data['message'] ?? 'Límite de consultas excedido.', Colors.red);
      } else {
        _showSnackBar('No se encontró el DNI o el servicio no está disponible', Colors.orange);
      }
    } catch (e) {
      _showSnackBar('Error al conectar con el servicio de DNI', Colors.red);
    } finally {
      setState(() {
        _isSearchingDni = false;
      });
    }
  }

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

    final authProvider = context.read<AuthProvider>();
    
    final success = await authProvider.registrarCliente(
      _nombreController.text.trim(),
      _dniController.text.trim(),
      _correoController.text.trim(),
      _passwordController.text,
      _telefonoController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      _showSnackBar(
        'Cuenta creada correctamente',
        Colors.green,
      );

      await Future.delayed(const Duration(milliseconds: 700));

      if (!mounted) return;

      context.pop();
    } else {
      _showSnackBar(
        authProvider.errorMessage ?? 'No se pudo completar el registro',
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
    final isLoading = context.watch<AuthProvider>().isLoading;

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
                      context.pop();
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
                TextField(
                  controller: _dniController,
                  keyboardType: TextInputType.number,
                  maxLength: 8,
                  textInputAction: TextInputAction.next,
                  onChanged: (value) {
                    if (value.trim().length == 8) {
                      _buscarDni(value.trim());
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'DNI',
                    counterText: '', // Ocultar contador por estética
                    prefixIcon: const Icon(Icons.badge_outlined),
                    suffixIcon: _isSearchingDni
                        ? const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFFF5A1F),
                              ),
                            ),
                          )
                        : IconButton(
                            icon: const Icon(Icons.search_rounded, color: Color(0xFFFF5A1F)),
                            onPressed: () {
                              _buscarDni(_dniController.text.trim());
                            },
                          ),
                    filled: true,
                    fillColor: const Color(0xFFF7F7F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: Color(0xFFFF5A1F), width: 2),
                    ),
                  ),
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
                    if (!isLoading) _registrar();
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
                    onPressed: isLoading ? null : _registrar,

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
                        context.pop();
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
