import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;

class AdminScannerView extends StatefulWidget {
  const AdminScannerView({Key? key}) : super(key: key);

  @override
  State<AdminScannerView> createState() => _AdminScannerViewState();
}

class _AdminScannerViewState extends State<AdminScannerView> {
  MobileScannerController cameraController = MobileScannerController();
  bool isProcessing = false;

  Future<void> _validarQRBackend(String qrData) async {
    if (isProcessing) return;
    setState(() => isProcessing = true);

    try {
      final payload = jsonDecode(qrData);

      final response = await http.post(
        Uri.parse('https://tu-backend-api.com/api/compra/validar-qr'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _mostrarAlerta(
          "Éxito",
          "Compra aprobada. El QR es válido y en vivo.",
          Colors.green,
        );
      } else {
        _mostrarAlerta(
          "Error",
          responseData['message'] ?? "QR inválido o expirado.",
          Colors.red,
        );
      }
    } catch (e) {
      _mostrarAlerta(
        "Error de lectura",
        "El formato del QR no es el correcto.",
        Colors.orange,
      );
    } finally {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => isProcessing = false);
      });
    }
  }

  void _mostrarAlerta(String titulo, String mensaje, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escáner de Administrador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => cameraController
                .switchCamera(), // Útil si la laptop tiene 2 cámaras
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null && !isProcessing) {
                  _validarQRBackend(barcode.rawValue!);
                }
              }
            },
          ),
          // Un overlay visual para guiar el escaneo
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 4),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          if (isProcessing) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
