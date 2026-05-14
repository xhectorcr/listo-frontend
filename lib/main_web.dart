import 'package:flutter/material.dart';
import 'package:listo_app/web/landing_page.dart';

void main() {
  runApp(const ListoWeb());
}

class ListoWeb extends StatelessWidget {
  const ListoWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LISTO! GO - Descubre la App',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF5A1F),
        fontFamily: 'Roboto',
      ),
      home: const LandingPage(), // Solo carga la cara pública
    );
  }
}
