import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/states/view_state.dart';
import '../providers/cart_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../widgets/app_appbar.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_container.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: 'Carrito',
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
            onPressed: () {
              context.read<CartProvider>().fetchCart(_getUserId());
            },
          ),
        ],
      ),
      body: AppContainer(
        maxWidth: 1000,
        child: Consumer<CartProvider>(
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
                    const Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: AppColors.textDisabled,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Carrito Vacío',
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Pasa tus productos por el escáner y aparecerán aquí.',
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        leading: CircleAvatar(backgroundColor: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.inventory_2, color: AppColors.primary)),
                        title: Text(item['nombre'] ?? 'Producto', style: AppTextStyles.bodyLarge),
                        subtitle: Text('Cantidad: ${item['cantidad']}', style: AppTextStyles.bodyMedium),
                        trailing: Text(
                          'S/ ${item['subtotal'].toStringAsFixed(2)}',
                          style: AppTextStyles.titleMedium,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 1),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: AppTextStyles.titleLarge,
                            ),
                            Text(
                              'S/ ${cartProvider.total.toStringAsFixed(2)}',
                              style: AppTextStyles.titleLarge.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
