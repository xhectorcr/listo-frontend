import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final TextEditingController emailController = TextEditingController();

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFFF5A1F),
                shape: BoxShape.circle,
              ),
              child: const Text(
                'L!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'LISTO! GO',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Cómo funciona",
              style: TextStyle(color: Colors.black87),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              "Catálogo",
              style: TextStyle(color: Colors.black87),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5A1F),
              ),
              onPressed: () {},
              child: const Text(
                "Crear Cuenta",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildCatalogSection(),
            _buildRegisterSection(context),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // 1. SECCIÓN: HERO Y PASOS
  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: const Color(0xFFF8F9FA),
      child: Column(
        children: [
          const Text(
            "El futuro de las compras está aquí",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          const Text(
            "Sin filas. Sin cajeros. Solo toma lo que necesitas y ¡Listo!",
            style: TextStyle(fontSize: 20, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          // GRILLA DE PASOS
          Wrap(
            spacing: 40,
            runSpacing: 40,
            alignment: WrapAlignment.center,
            children: [
              _stepCard(
                Icons.download,
                "1. Descarga la App",
                "Crea tu cuenta y asocia un método de pago.",
              ),
              _stepCard(
                Icons.qr_code_scanner,
                "2. Escanea al Entrar",
                "Usa el código QR de tu app en los torniquetes.",
              ),
              _stepCard(
                Icons.shopping_bag,
                "3. Toma lo que quieras",
                "Nuestras cámaras detectan todo automáticamente.",
              ),
              _stepCard(
                Icons.directions_walk,
                "4. ¡Sal de la tienda!",
                "El cobro se realiza directo a tu billetera virtual.",
              ),
            ],
          ),
          const SizedBox(height: 80),

          // --- AQUÍ ESTÁ EL CARTEL NARANJA DE LAS GASEOSAS ---
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            constraints: const BoxConstraints(maxWidth: 950),
            decoration: BoxDecoration(
              color: const Color(0xFFFF5A1F), // NARANJA
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF5A1F).withOpacity(0.3),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Row(
                children: [
                  // Imagen de la oferta
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: 300,
                      child: Image.asset(
                        'assets/cocainca.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.white24,
                            child: const Icon(
                              Icons.local_drink,
                              size: 80,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Texto de la oferta
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "¡OFERTA IMPERDIBLE!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "2x1 en Gaseosas Coca-Cola e Inca Kola",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Solo por tiempo limitado en nuestra sede Ica. ¡Toma dos y paga una al pasar por el sensor!",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 15,
                              ),
                            ),
                            onPressed: () {},
                            child: const Text("VER MÁS OFERTAS"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepCard(IconData icon, String title, String desc) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: const Color(0xFFFF5A1F)),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            desc,
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 2. SECCIÓN: CATÁLOGO
  Widget _buildCatalogSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        children: [
          const Text(
            "Productos Estrella",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _productCard("Coca Cola 500ml", "S/ 3.50", Icons.local_drink),
              _productCard("Galletas Oreo", "S/ 1.20", Icons.cookie),
              _productCard("Papas Lays", "S/ 2.50", Icons.fastfood),
              _productCard("Agua San Luis", "S/ 2.00", Icons.water_drop),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productCard(String name, String price, IconData placeholderIcon) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Icon(placeholderIcon, size: 60, color: Colors.grey.shade400),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(
                  price,
                  style: const TextStyle(
                    color: Color(0xFFFF5A1F),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 3. SECCIÓN: REGISTRO
  Widget _buildRegisterSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      color: const Color(0xFF2C2C2C),
      child: Center(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              const Text(
                "Crea tu cuenta antes de ir",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              const TextField(
                decoration: InputDecoration(
                  labelText: "Nombre completo",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              // Añadimos el controller aquí
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Correo electrónico",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5A1F),
                  ),
                  onPressed: () async {
                    String emailCliente = emailController.text;

                    // Validación simple para no enviar campos vacíos
                    if (emailCliente.isEmpty) {
                      print("Por favor, ingresa un correo");
                      return;
                    }

                    try {
                      // Importante: jsonEncode espera un objeto o un string directo
                      final response = await http.post(
                        Uri.parse(
                          'http://localhost:5115/api/Descuento/enviar-cupon',
                        ),
                        headers: {"Content-Type": "application/json"},
                        body: jsonEncode(emailCliente),
                      );

                      if (response.statusCode == 200) {
                        _showSuccessDialog(context);
                      } else {
                        print("Error en el servidor: ${response.body}");
                      }
                    } catch (e) {
                      print("No se pudo conectar con el backend: $e");
                    }
                  },
                  child: const Text(
                    "Registrarme",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Color(0xFFFF5A1F),
              size: 60,
            ),
            SizedBox(height: 15),
            Text(
              "¡Registro Exitoso!",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          "Bienvenido a la revolución de Listo! GO. Ya puedes empezar a comprar sin filas.",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5A1F),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "¡ENTENDIDO!",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // 4. SECCIÓN: FOOTER
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      color: Colors.black,
      child: const Column(
        children: [
          Text(
            "LISTO! GO © 2026",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Soporte", style: TextStyle(color: Colors.white54)),
              SizedBox(width: 20),
              Text("Términos", style: TextStyle(color: Colors.white54)),
              SizedBox(width: 20),
              Text("Privacidad", style: TextStyle(color: Colors.white54)),
            ],
          ),
        ],
      ),
    );
  }
}
