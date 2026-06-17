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
        
        return _historyItem(
          formattedDate,
          '$cantidad Items - S/ ${total.toStringAsFixed(2)}',
          'S/ ${total.toStringAsFixed(2)}',
        );
      },
      ),
    );
  }

  Widget _historyItem(String date, String details, String total) {
    return Row(
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
    );
  }
}
