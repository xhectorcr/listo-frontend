import 'package:flutter/material.dart';
import '../../data/services/usuario_service.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final UsuarioService _usuarioService = UsuarioService();
  late Future<List<dynamic>> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    // Disparamos la petición al backend al cargar la vista
    _usuariosFuture = _usuarioService.obtenerUsuarios();
  }

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
          // Sección de Alertas de Seguridad intacta
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

          // Aquí entra la magia dinámica con FutureBuilder
          Expanded(
            child: Card(
              child: FutureBuilder<List<dynamic>>(
                future: _usuariosFuture,
                builder: (context, snapshot) {
                  // 1. Estado de carga
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2. Estado de error o vacío
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No hay usuarios registrados.'),
                    );
                  }

                  // 3. Estado de éxito: Extraemos la lista
                  final usuarios = snapshot.data!;

                  // Envolvemos el DataTable en SingleChildScrollView por si hay muchas columnas y usuarios
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(
                            label: Text(
                              "Nombre",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Email",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Estrellas",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Saldo Simulador",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Estado",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        // Mapeamos cada usuario de la API a una fila real
                        rows: usuarios.map((user) {
                          return DataRow(
                            cells: [
                              DataCell(Text(user['nombre'] ?? 'Sin nombre')),
                              DataCell(Text(user['correo'] ?? 'Sin correo')),
                              // Asumiendo que tu API devuelve estos campos.
                              // Si no los tienes aún, dejamos un valor por defecto.
                              DataCell(Text("${user['estrellas'] ?? '0'} ⭐")),
                              DataCell(Text("S/ ${user['saldo'] ?? '0.00'}")),
                              DataCell(
                                Chip(
                                  // Puedes poner lógica aquí si el estado depende del backend (ej: user['activo'] == true)
                                  label: const Text("Activo"),
                                  backgroundColor: Colors.green[100],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
