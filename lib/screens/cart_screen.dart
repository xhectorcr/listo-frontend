import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartScreen extends StatefulWidget {
  final int usuarioId;
  const CartScreen({super.key, this.usuarioId = 1}); // Por defecto 1 para pruebas

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> items = [];
  double total = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarCarrito();
  }

  Future<void> cargarCarrito() async {
    // 10.0.2.2 para Android Emulator, 127.0.0.1 para Web/Windows
    final url = Uri.parse('http://127.0.0.1:5115/api/carrito/${widget.usuarioId}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final datos = json.decode(response.body);
        setState(() {
          items = datos['items'] ?? [];
          // El backend puede enviar double o int, aseguramos conversión a double
          total = (datos['total'] ?? 0).toDouble();
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error conectando al servidor .NET: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() => isLoading = true);
              cargarCarrito();
            },
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(
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
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.inventory_2)),
                      title: Text(item['nombre'] ?? 'Producto'),
                      subtitle: Text('Cantidad: ${item['cantidad']}'),
                      trailing: Text(
                        'S/ ${item['subtotal'].toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: items.isEmpty ? Colors.grey.shade300 : Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: items.isEmpty ? null : () {},
            child: Text(
              items.isEmpty ? 'PAGAR' : 'PAGAR S/ ${total.toStringAsFixed(2)}',
              style: const TextStyle(
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
