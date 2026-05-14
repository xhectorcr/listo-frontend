import 'package:flutter/material.dart';

class LiveMonitorView extends StatelessWidget {
  const LiveMonitorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mapa de Calor Simulado
          Expanded(
            flex: 2,
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/plano_tienda.png'), // Tu plano
                  fit: BoxFit.cover,
                  opacity: 0.3,
                ),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Text("Heatmap en tiempo real (Cámaras IA)"),
                  ),
                  // Aquí posicionarías puntos rojos/amarillos según coordenadas de la IA
                  Positioned(
                    top: 100,
                    left: 150,
                    child: _heatPoint(50, Colors.red),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Lista de carritos activos
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sesiones Activas",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  _activeUserItem("Karelly Ore", "S/ 45.50", "3 items"),
                  _activeUserItem("Usuario 2", "S/ 12.00", "1 item"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heatPoint(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget _activeUserItem(String name, String total, String items) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(name),
      subtitle: Text(items),
      trailing: Text(
        total,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }
}
