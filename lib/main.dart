import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // Solo importa la parte móvil
import 'web/landing_page.dart';

void main() {
  runApp(const ClienteApp());
}

class ClienteApp extends StatelessWidget {
  const ClienteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LISTO! GO',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF5A1F),
        fontFamily: 'Roboto',
      ),
      home: const LoginScreen(), // Arranca la app de clientes
    );
  }
}
