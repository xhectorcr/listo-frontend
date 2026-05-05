import 'package:flutter/material.dart';
import 'web/admin_login_screen.dart'; // Solo importa la parte móvil

void main() {
  runApp(const AdminApp());
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LISTO! GO',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF5A1F),
        fontFamily: 'Roboto',
      ),
      home: const AdminLoginScreen(), // Arranca la app de clientes
    );
  }
}
