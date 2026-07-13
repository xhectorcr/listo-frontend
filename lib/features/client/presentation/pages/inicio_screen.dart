import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/env/environment.dart';
import '../../../../core/local_storage/storage_service.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_chip.dart';
import '../../../../widgets/app_container.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  String _pin = "Cargando...";

  @override
  void initState() {
    super.initState();
    _fetchDynamicPin();
  }

  Future<void> _fetchDynamicPin() async {
    try {
      final storage = StorageService();
      final String? userId = await storage.getId();

      if (userId == null) {
        if (!mounted) return;
        setState(() {
          _pin = "Error: Sin Sesión";
        });
        return;
      }

      final url = Uri.parse('${Environment.apiUrl}/usuario/generar-pin/$userId');
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          if (!mounted) return;
          setState(() {
            _pin = data['data'].toString();
          });
        } else {
          if (!mounted) return;
          setState(() {
            _pin = "Error";
          });
        }
      } else {
        debugPrint("Error API status code: ${response.statusCode} - body: ${response.body}");
        if (!mounted) return;
        setState(() {
          _pin = "Error API";
        });
      }
    } catch (e) {
      debugPrint("Excepción al pedir el PIN: $e");
      if (!mounted) return;
      setState(() {
        _pin = "Error de red";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      maxWidth: 800,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Ingresa este código\npara entrar a la tienda',
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
              child: Text(
                _pin,
                style: AppTextStyles.displayMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppChip(label: 'Código único temporal'),
          ],
        ),
      ),
    );
  }
}
