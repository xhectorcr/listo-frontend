import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/historial_remote_data_source.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_container.dart';

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
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(
        title: 'Historial',
        centerTitle: true,
      ),
      body: AppContainer(
        maxWidth: 1000,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(_error!, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
                _loadHistorial();
              },
              text: 'Reintentar',
              type: AppButtonType.primary,
              isFullWidth: false,
            )
          ],
        ),
      );
    }

    if (_historial.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history_toggle_off, color: AppColors.textDisabled, size: 64),
            const SizedBox(height: AppSpacing.md),
            Text('No tienes compras recientes', style: AppTextStyles.titleMedium.copyWith(color: AppColors.textDisabled)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadHistorial,
      color: AppColors.primary,
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
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  details,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
            Text(
              total,
              style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary),
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
              const SizedBox(height: AppSpacing.md),
              Text('Detalles de Compra', style: AppTextStyles.titleLarge),
              Text(date, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.md),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    final prod = productos[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(backgroundColor: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.shopping_bag, color: AppColors.primary)),
                      title: Text(prod['nombre'] ?? 'Producto', style: AppTextStyles.bodyLarge),
                      subtitle: Text('Cantidad: ${prod['cantidad']}', style: AppTextStyles.bodyMedium),
                      trailing: Text('S/ ${(prod['subtotal'] ?? 0).toDouble().toStringAsFixed(2)}', style: AppTextStyles.titleMedium),
                    );
                  },
                ),
              ),
              const Divider(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Pagado:', style: AppTextStyles.titleMedium),
                  Text(total, style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        );
      }
    );
  }
}
