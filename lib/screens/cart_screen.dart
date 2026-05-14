import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Carrito',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 20),
            const Text(
              'Carrito Vacío',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Aún no hay productos procesados en tu compra actual.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.grey.shade300, // Color gris indicando botón inactivo
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {}, // Vacío porque no hace nada si no hay items
            child: const Text(
              'PAGAR',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> cargarCarrito() async {
  // OJO: Si usas el emulador de Android de Android Studio, la IP local cambia a 10.0.2.2
  // Si pruebas en Chrome Web o Windows, usa 127.0.0.1
  final url = Uri.parse('http://127.0.0.1:8000/api/carrito');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final datos = json.decode(response.body);
      print("Los productos son: ${datos['items']}");
      print("El total es: S/ ${datos['total']}");
      // Aquí usarías setState para actualizar la pantalla con los productos
    }
  } catch (e) {
    print("Error conectando al servidor: $e");
  }
}
