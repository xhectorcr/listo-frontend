import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui_web' as ui;
import 'package:web/web.dart' as web;

class LiveMonitorView extends StatefulWidget {
  const LiveMonitorView({super.key});

  @override
  State<LiveMonitorView> createState() => _LiveMonitorViewState();
}

class _LiveMonitorViewState extends State<LiveMonitorView> {
  final int adminUsuarioId = 1;
  final String _viewId = 'mjpeg-yolo-stream';

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      ui.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
        final img = web.HTMLImageElement()
          ..src = 'https://yolocam.onrender.com/video/$adminUsuarioId'
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.objectFit = 'contain'
          ..style.background = 'black';
        return img;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                        child: kIsWeb
                            ? HtmlElementView(viewType: _viewId)
                            : const Center(
                                child: Text(
                                  'Solo disponible en web',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                      ),
                      const Positioned(top: 15, left: 15, child: _LiveTag()),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Conectado a: https://yolocam.onrender.com/video/$adminUsuarioId",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
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
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
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
