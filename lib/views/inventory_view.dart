import 'package:flutter/material.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  // Simulación de datos de la tabla Producto
  final List<Map<String, dynamic>> _productos = [
    {
      'id': 1,
      'nombre': 'Coca Cola 500ml',
      'precio': 3.50,
      'stock': 15,
      'yolo': 'bottle_cola',
      'categoria': 'Bebidas',
    },
    {
      'id': 2,
      'nombre': 'Galletas Oreo',
      'precio': 1.20,
      'stock': 5,
      'yolo': 'cookie_oreo',
      'categoria': 'Snacks',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Gestión de Inventario",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _mostrarFormulario(context),
                icon: const Icon(Icons.add),
                label: const Text("Nuevo Producto"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5A1F),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.separated(
                itemCount: _productos.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final p = _productos[index];
                  bool bajoStock = p['stock'] <= 5;
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.fastfood,
                        color: Color(0xFFFF5A1F),
                      ),
                    ),
                    title: Text(
                      p['nombre'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Etiqueta YOLO: ${p['yolo']} | Categoría: ${p['categoria']}",
                    ),
                    trailing: SizedBox(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "S/ ${p['precio']}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Stock: ${p['stock']}",
                                style: TextStyle(
                                  color: bajoStock ? Colors.red : Colors.grey,
                                  fontWeight: bajoStock
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {},
                          ),
                        ],
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

  void _mostrarFormulario(BuildContext context) {
    // Aquí implementarías el Dialog con los TextFields para cada campo de la BD
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Agregar Producto"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(decoration: InputDecoration(labelText: "Nombre")),
            TextField(decoration: InputDecoration(labelText: "Precio")),
            TextField(
              decoration: InputDecoration(labelText: "Etiqueta YOLO (Unique)"),
            ),
            TextField(decoration: InputDecoration(labelText: "Stock Inicial")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(onPressed: () {}, child: const Text("Guardar")),
        ],
      ),
    );
  }
}
