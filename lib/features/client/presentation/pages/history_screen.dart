import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/historial_remote_data_source.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistorialRemoteDataSource _historialDataSource = HistorialRemoteDataSourceImpl();
  List<dynamic> _historial = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadHistorial();
  }

  Future<void> _loadHistorial() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = int.parse(authProvider.user?.id ?? '0');
      
      if (userId == 0) throw Exception("Usuario no válido");

      final historial = await _historialDataSource.getHistorial(userId);
      setState(() {
        _historial = historial;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Error al cargar historial: $e";
        _isLoading = false;
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
          'Historial',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFFF6B00)));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadHistorial();
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF6B00)),
              child: const Text('Reintentar', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      );
    }

    if (_historial.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_toggle_off, color: Colors.grey, size: 64),
            SizedBox(height: 16),
            Text('No tienes compras recientes', style: TextStyle(color: Colors.grey, fontSize: 18)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistorial,
      color: const Color(0xFFFF6B00),
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _historial.length,
        separatorBuilder: (context, index) => const Divider(height: 30),
        itemBuilder: (context, index) {
        final item = _historial[index];
        final fecha = DateTime.parse(item['fecha'].toString());
        final formattedDate = DateFormat('dd-MMM-yyyy').format(fecha);
        final cantidad = item['cantidadItems'];
        final total = item['total'];
        
        List<dynamic> productos = [];
        if (item['detalles'] != null && item['detalles'].toString().isNotEmpty) {
          try {
            productos = jsonDecode(item['detalles'].toString());
          } catch(e) {
            // Error parsing JSON
          }
        }
        
        return _historyItem(
          formattedDate,
          '$cantidad Items - S/ ${total.toStringAsFixed(2)}',
          'S/ ${total.toStringAsFixed(2)}',
          productos
        );
      },
      ),
    );
  }

  Widget _historyItem(String date, String details, String total, List<dynamic> productos) {
    return InkWell(
      onTap: () {
        if (productos.isNotEmpty) {
           _mostrarDetalles(context, date, total, productos);
        } else {
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No hay detalles para esta compra')));
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  details,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            Text(
              total,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF6B00)),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDetalles(BuildContext context, String date, String total, List<dynamic> productos) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 20),
              const Text('Detalles de Compra', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(date, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final prod = productos[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const CircleAvatar(backgroundColor: Color(0xFFFFF3E0), child: Icon(Icons.shopping_bag, color: Color(0xFFFF6B00))),
                      title: Text(prod['nombre'] ?? 'Producto'),
                      subtitle: Text('Cantidad: ${prod['cantidad']}'),
                      trailing: Text('S/ ${(prod['subtotal'] ?? 0).toDouble().toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    );
                  },
                ),
              ),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pagado:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(total, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF6B00))),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      }
    );
  }
}
