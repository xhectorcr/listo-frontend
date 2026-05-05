import 'package:flutter/material.dart';
import 'dart:io'; // Para detectar la plataforma
import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional import to trigger browser permission prompt on web
import '../src/web_camera_permission_stub.dart'
  if (dart.library.html) '../src/web_camera_permission_web.dart';

class LiveMonitorView extends StatefulWidget {
  const LiveMonitorView({super.key});

  @override
  State<LiveMonitorView> createState() => _LiveMonitorViewState();
}

class _LiveMonitorViewState extends State<LiveMonitorView> {
  final int adminUsuarioId = 1;

  // Función para obtener la IP correcta automáticamente
  String getStreamUrl() {
    // Si es Android y es un emulador, usamos 10.0.2.2
    // Si es Windows (ejecutando flutter run -d windows), usamos localhost
    String host = "127.0.0.1";

    try {
      if (Platform.isAndroid) {
        host = "10.0.2.2"; // IP para que el emulador vea la PC
      }
    } catch (e) {
      // En Web o si falla la detección de plataforma, se mantiene 127.0.0.1
    }

    return 'http://$host:8000/video/$adminUsuarioId';
  }

  @override
  Widget build(BuildContext context) {
    final String streamUrl = getStreamUrl();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Container(
                  height: 500,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.redAccent.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          streamUrl,
                          fit: BoxFit.contain,
                          gaplessPlayback: true, // Evita parpadeo negro
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Error de conexión:\n$streamUrl",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () => setState(() {}),
                                        child: const Text("Reintentar"),
                                      ),
                                      if (kIsWeb)
                                        ElevatedButton(
                                          onPressed: () async {
                                            final granted = await requestBrowserCameraPermission();
                                            final snack = ScaffoldMessenger.of(context);
                                            if (granted) {
                                              snack.showSnackBar(const SnackBar(content: Text('Permiso de cámara concedido')));
                                            } else {
                                              snack.showSnackBar(const SnackBar(content: Text('Permiso de cámara denegado')));
                                            }
                                            setState(() {});
                                          },
                                          child: const Text('Solicitar permiso de cámara'),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const Positioned(top: 15, left: 15, child: _LiveTag()),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Conectado a: $streamUrl",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // El resto de tu UI (carritos activos) se mantiene igual...
          _buildCartList(),
        ],
      ),
    );
  }

  Widget _buildCartList() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: const Column(
          children: [
            Text(
              "Sesiones Activas",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Divider(),
            ListTile(
              title: Text("Karelly Ore"),
              subtitle: Text("3 items"),
              trailing: Text("S/ 45.50"),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveTag extends StatelessWidget {
  const _LiveTag();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Row(
        children: [
          Icon(Icons.circle, color: Colors.white, size: 10),
          SizedBox(width: 5),
          Text(
            "LIVE",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
