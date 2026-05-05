import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:qr_flutter/qr_flutter.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  String _qrData = "Cargando...";
  Timer? _timer;
  int _segundosRestantes = 15;

  @override
  void initState() {
    super.initState();
    _generarNuevoToken();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_segundosRestantes > 0) {
            _segundosRestantes--;
          } else {
            _generarNuevoToken();
            _segundosRestantes = 15;
          }
        });
      }
    });
  }

  void _generarNuevoToken() {
    final tokenAleatorio = Random().nextInt(999999).toString().padLeft(6, '0');
    _qrData = "LISTO-USER-$tokenAleatorio";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Escanea este QR\npara entrar a la tienda',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
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
            child: QrImageView(
              data: _qrData,
              version: QrVersions.auto,
              size: 250.0,
              foregroundColor: const Color(0xFFFF5A1F),
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
              'Actualizando en: $_segundosRestantes seg',
              style: TextStyle(
                color: _segundosRestantes <= 5
                    ? Colors.red
                    : Colors.grey.shade700,
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
