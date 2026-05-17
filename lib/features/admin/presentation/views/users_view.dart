import 'package:flutter/material.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Usuarios y Recompensas",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          // Sección de Alertas de Seguridad
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.red),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    "ALERTA: 1 usuario detectado intentando salir con saldo insuficiente.",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Card(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Nombre")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("Estrellas")),
                  DataColumn(label: Text("Saldo Simulador")),
                  DataColumn(label: Text("Estado")),
                ],
                rows: [
                  DataRow(
                    cells: [
                      const DataCell(Text("Karelly Ore")),
                      const DataCell(Text("karelly@utp.edu.pe")),
                      const DataCell(Text("150 ⭐")),
                      const DataCell(Text("S/ 45.00")),
                      DataCell(
                        Chip(
                          label: const Text("Activo"),
                          backgroundColor: Colors.green[100],
                        ),
                      ),
                    ],
                  ),
                  // Más filas...
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
