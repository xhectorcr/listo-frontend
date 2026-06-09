import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/env/environment.dart';
import '../../../../core/local_storage/storage_service.dart';

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
          setState(() {
            _pin = data['data'].toString();
          });
        } else {
          setState(() {
            _pin = "Error";
          });
        }
      } else {
        print("Error API status code: ${response.statusCode} - body: ${response.body}");
        setState(() {
          _pin = "Error API";
        });
      }
    } catch (e) {
      print("Excepción al pedir el PIN: $e");
      setState(() {
        _pin = "Error de red";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Ingresa este código\npara entrar a la tienda',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              _pin,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                letterSpacing: 8,
                color: Color(0xFFFF5A1F),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Código único temporal',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
