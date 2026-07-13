import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:listo_app/core/env/environment.dart';

import '../../../../core/local_storage/storage_service.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_textfield.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_container.dart';
import '../providers/auth_provider.dart';
import '../../../../core/states/view_state.dart';

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
  Future<void> _buscarDni(String dni) async {
    if (dni.length != 8) {
      _showSnackBar('El DNI debe tener 8 dígitos', Colors.orange);
      return;
    }

    setState(() {
      _isSearchingDni = true;
    });

    try {
      final storage = StorageService();
      final deviceId = await storage.getOrCreateDeviceId();

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
    final isLoading = context.watch<AuthProvider>().state == ViewState.loading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: AppContainer(
                    maxWidth: 500,
                    backgroundColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: AppCard(
                      margin: EdgeInsets.symmetric(horizontal: mobile ? 0 : 20),
                      padding: EdgeInsets.all(mobile ? 28 : 36),
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
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Center(
                              child: Text(
                                'L!',
                                style: AppTextStyles.headlineLarge.copyWith(
                                  color: AppColors.textInverse,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 26),

                          // TITLE
                          Text(
                            'Crear cuenta',
                            style: AppTextStyles.headlineMedium.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'Completa tus datos',
                            style: AppTextStyles.bodyLarge,
                          ),

                          const SizedBox(height: 34),

                          AppTextField(
                            controller: _nombreController,
                            label: 'Nombre completo',
                            prefixIcon: const Icon(Icons.person_outline_rounded),
                          ),

                          const SizedBox(height: 18),

                          AppTextField(
                            controller: _dniController,
                            label: 'DNI',
                            keyboardType: TextInputType.number,
                            maxLength: 8,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const Icon(Icons.badge_outlined),
                            onChanged: (value) {
                              if (value.trim().length == 8) {
                                _buscarDni(value.trim());
                              }
                            },
                            suffixIcon: _isSearchingDni
                                ? const Padding(
                                    padding: EdgeInsets.all(14.0),
                                    child: SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : IconButton(
                                    icon: Icon(Icons.search_rounded,
                                        color: AppColors.primary),
                                    onPressed: () {
                                      _buscarDni(_dniController.text.trim());
                                    },
                                  ),
                          ),

                          const SizedBox(height: 18),

                          AppTextField(
                            controller: _correoController,
                            label: 'Correo electrónico',
                            prefixIcon: const Icon(Icons.email_outlined),
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 18),

                          AppTextField(
                            controller: _telefonoController,
                            label: 'Teléfono',
                            prefixIcon: const Icon(Icons.phone_outlined),
                            keyboardType: TextInputType.phone,
                          ),

                          const SizedBox(height: 18),

                          AppTextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            label: 'Contraseña',
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
                          ),

                          const SizedBox(height: 30),

                          AppButton(
                            onPressed: _registrar,
                            text: 'Crear cuenta',
                            isLoading: isLoading,
                          ),

                          const SizedBox(height: 24),

                          // LOGIN
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '¿Ya tienes cuenta?',
                                style: AppTextStyles.bodyMedium,
                              ),
                              TextButton(
                                onPressed: () {
                                  context.pop();
                                },
                                child: Text(
                                  'Iniciar sesión',
                                  style: AppTextStyles.labelLarge.copyWith(
                                    color: AppColors.primary,
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
              ),
            );
          },
        ),
      ),
    );
  }
}
