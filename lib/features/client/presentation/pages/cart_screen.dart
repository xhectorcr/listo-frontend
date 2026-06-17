import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/states/view_state.dart';
import '../providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class CartScreen extends StatefulWidget {
  final int usuarioId;
  const CartScreen({
    super.key,
    this.usuarioId = 1,
  }); // Por defecto 1 para pruebas

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Timer? _timer;

  int _getUserId() {
    final user = context.read<AuthProvider>().user;
    if (user != null && user.id.isNotEmpty) {
      return int.tryParse(user.id) ?? widget.usuarioId;
    }
    return widget.usuarioId;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<CartProvider>().fetchCart(_getUserId());
      }
    });

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) {
        context.read<CartProvider>().fetchCart(_getUserId(), isPolling: true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
              context.read<CartProvider>().fetchCart(_getUserId());
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final isLoading = cartProvider.state == ViewState.loading;
          final items = cartProvider.items;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (items.isEmpty) {
            return Center(
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
            );
          }

          return ListView.builder(
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
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final items = cartProvider.items;
          final total = cartProvider.total;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: items.isEmpty
                      ? Colors.grey.shade300
                      : Colors.blue,
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
          );
        },
      ),
    );
  }
}
