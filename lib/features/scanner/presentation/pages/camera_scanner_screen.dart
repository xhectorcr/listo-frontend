import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web_socket_channel/web_socket_channel.dart';

class CameraScannerScreen extends StatefulWidget {
  final int usuarioId;
  const CameraScannerScreen({super.key, required this.usuarioId});

  @override
  State<CameraScannerScreen> createState() => _CameraScannerScreenState();
}

class _CameraScannerScreenState extends State<CameraScannerScreen> with WidgetsBindingObserver {
  WebSocketChannel? _channel;
  Image? _processedImage;
  String _status = 'Inicializando...';
  final List<String> _logs = [];
  List<String> _detectedProducts = [];
  bool _webPermissionAsked = false;
  bool _webPermissionDialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // On web, wait for explicit user action to trigger browser permission prompt
    if (kIsWeb) {
      setState(() => _status = 'Esperando permiso del navegador');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_webPermissionDialogShown) _showWebPermissionDialog();
      });
    }
    _initWebSocket();
  }

  // Nota: la captura se realiza en el módulo Python. Este cliente solo renderiza el stream remoto.
  Future<void> _requestWebPermissionAndInit() async {
    if (!kIsWeb) return;
    setState(() {
      _status = 'Solicitando permiso al navegador...';
    });
    _webPermissionAsked = true;
    // No inicializamos cámara local; solo actualizamos estado visual
    setState(() {
      _status = 'Listo para recibir stream';
    });
  }

  Future<void> _showWebPermissionDialog() async {
    _webPermissionDialogShown = true;
    if (!mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Permiso de cámara'),
        content: const Text('La aplicación necesita acceder a la cámara. ¿Deseas permitirlo?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() => _status = 'Permiso de cámara denegado por usuario');
            },
            child: const Text('Denegar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _requestWebPermissionAndInit();
            },
            child: const Text('Permitir'),
          ),
        ],
      ),
    );
  }

  void _initWebSocket() {
    // 10.0.2.2 es el localhost del emulador Android. Para Windows/Web usar 127.0.0.1
    final wsUrl = Uri.parse('ws://127.0.0.1:8000/ws/video');
    _channel = WebSocketChannel.connect(wsUrl);
    _channel!.stream.listen((message) {
      try {
        // Si el servidor envía binarios (JPEG) el mensaje vendrá como List<int>/Uint8List
        if (message is List<int>) {
          setState(() {
            _processedImage = Image.memory(
              Uint8List.fromList(message),
              gaplessPlayback: true,
            );
          });
          _log('Frame binario recibido');
          return;
        }

        // Si el servidor envía JSON textual con detecciones, lo parseamos
        final data = jsonDecode(message);
        if (data is Map && data['detections'] != null) {
          final detections = List<String>.from(data['detections'].map((d) => d.toString()));
          setState(() => _detectedProducts = detections);
          _log('Detections recibidas: ${detections.join(', ')}');
        }
      } catch (e) {
        _log('Error procesando mensaje WS: $e');
      }
    }, onError: (error) {
      // _log ya imprime localmente en debug (lo eliminaremos de producción)
      _log('Error WebSocket: $error');
      setState(() => _status = 'Error de conexión: ${wsUrl.toString()}');
    });
  }

  // Nota: no capturamos ni enviamos frames desde Flutter. El procesamiento es servidor-side.

  void _log(String msg) {
    final ts = DateTime.now().toIso8601String();
    _logs.insert(0, '[$ts] $msg');
    if (_logs.length > 50) _logs.removeLast();
    // Además logear en consola de depuración en desarrollo
    debugPrint(msg);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    try {
      _channel?.sink.close();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escáner de Productos YOLO')),
      body: Stack(
        children: [
          // Mostrar stream remoto (frame procesado desde Python)
          Positioned.fill(
            child: _processedImage != null
                ? SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: _processedImage,
                    ),
                  )
                : Center(
                    child: kIsWeb && !_webPermissionAsked
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.videocam_off, size: 64, color: Colors.grey),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: _requestWebPermissionAndInit,
                                child: const Text('Permitir cámara'),
                              ),
                              const SizedBox(height: 8),
                              Text(_status),
                            ],
                          )
                        : const CircularProgressIndicator(),
                  ),
          ),
            
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Text(
              _status == 'Cámara inicializada' ? "Escaneando productos..." : _status,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                backgroundColor: Colors.black54,
              ),
            ),
          ),

          // Panel de información y logs
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: 220,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Logs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 120,
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _logs.take(10).map((l) => Text(l, style: const TextStyle(color: Colors.white, fontSize: 11))).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('Productos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  if (_detectedProducts.isEmpty)
                    const Text('Ninguno', style: TextStyle(color: Colors.white))
                  else
                    ..._detectedProducts.take(5).map((p) => Text('- $p', style: const TextStyle(color: Colors.white))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
