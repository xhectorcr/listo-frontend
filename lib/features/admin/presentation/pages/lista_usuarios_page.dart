import 'package:flutter/material.dart';
import '../../data/services/usuario_service.dart'; // Asegúrate de que la ruta sea correcta

class ListaUsuariosPage extends StatefulWidget {
  const ListaUsuariosPage({super.key});

  @override
  State<ListaUsuariosPage> createState() => _ListaUsuariosPageState();
}

class _ListaUsuariosPageState extends State<ListaUsuariosPage> {
  final UsuarioService _usuarioService = UsuarioService();
  late Future<List<dynamic>> _usuariosFuture;

  @override
  void initState() {
    super.initState();
    // Llamamos a la API al abrir la pantalla
    _usuariosFuture = _usuarioService.obtenerUsuarios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios Registrados'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _usuariosFuture,
        builder: (context, snapshot) {
          // 1. Mientras espera la respuesta del servidor
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Si hubo un error o la lista vino vacía
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay usuarios activos.'));
          }

          // 3. Si todo salió bien, pintamos la lista
          final usuarios = snapshot.data!;

          return ListView.builder(
            itemCount: usuarios.length,
            itemBuilder: (context, index) {
              final user = usuarios[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                elevation: 2,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  // Las llaves deben coincidir con tu UsuarioDTO.
                  // Usualmente en JSON de C# llegan en formato camelCase (nombre, correo)
                  title: Text(
                    user['nombre'] ?? 'Sin nombre',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(user['correo'] ?? 'Sin correo'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
