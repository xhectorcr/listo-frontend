import 'package:flutter/material.dart';
import 'package:listo_app/core/local_storage/storage_service.dart';
import 'package:listo_app/features/client/data/models/metodo_pago_model.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_textfield.dart';
import '../../../../widgets/app_dialog.dart';
import '../../../../widgets/app_container.dart';
import '../providers/pay_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late Future<MetodoPagoModel?> _billeteraFuture;
  int? _idUsuarioActual; // Guardamos el ID para usarlo en el POST y DELETE

 final _formKey = GlobalKey<FormState>();
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _numeroTarjetaController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _billeteraFuture = _cargarDatosBilletera();
  }

  Future<MetodoPagoModel?> _cargarDatosBilletera() async {
    final storage = StorageService();
    final idString = await storage.getId();

    if (idString == null || idString.isEmpty) return null;

    _idUsuarioActual = int.tryParse(idString);
    if (_idUsuarioActual == null) return null;

    final service = MetodoPagoService();
    return await service.getMetodoByUsuario(_idUsuarioActual!);
  }

  void _refrescarPantalla() {
    setState(() {
      _billeteraFuture = _cargarDatosBilletera();
    });
  }

  Future<void> _agregarMetodoPago() async {
  if (!_formKey.currentState!.validate()) return;

  String numeroTarjeta = _numeroTarjetaController.text;
  String ultimos = numeroTarjeta.length >= 4 
      ? numeroTarjeta.substring(numeroTarjeta.length - 4) 
      : numeroTarjeta;

  final nuevoMetodo = MetodoPagoModel(
    idMetodoPago: 0,
    idUsuario: _idUsuarioActual!,
    usuario: _usuarioController.text,
    saldo: 100.00,
    marcaTarjeta: _marcaController.text,
    tokenSimulado: 'tok_${DateTime.now().millisecondsSinceEpoch}',
    ultimosDigitos: ultimos, // Ahora esta variable sí existe
    estado: true,
  );

    try {
      await MetodoPagoService().saveItem(nuevoMetodo);
      if (mounted) {
        Navigator.pop(context);
        _refrescarPantalla();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tarjeta guardada con éxito')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _eliminarMetodoPago() async {
    if (_idUsuarioActual == null) return;

    try {
      await MetodoPagoService().deleteItem(_idUsuarioActual!);
      if (mounted) {
        Navigator.pop(context); // Cierra el diálogo de confirmación
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Método de pago eliminado'), backgroundColor: Colors.orange),
        );
        _refrescarPantalla(); // Actualiza el FutureBuilder a estado vacío
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _mostrarModalAgregar() {
    _usuarioController.clear();
    _marcaController.clear();
    _numeroTarjetaController.clear();
    _cvvController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 24, left: 24, right: 24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Añadir Tarjeta', style: AppTextStyles.titleLarge),
              const SizedBox(height: AppSpacing.md),
              AppTextField(controller: _usuarioController, label: 'Titular', validator: (v) => v!.isEmpty ? 'Requerido' : null),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(controller: _marcaController, label: 'Marca (Visa/MC)', validator: (v) => v!.isEmpty ? 'Requerido' : null),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(controller: _numeroTarjetaController, keyboardType: TextInputType.number, label: 'Número de tarjeta', validator: (v) => v!.length < 16 ? 'Mínimo 16 dígitos' : null),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(controller: _cvvController, keyboardType: TextInputType.number, label: 'CVV', validator: (v) => v!.length < 3 ? 'Inválido' : null),
              const SizedBox(height: AppSpacing.lg),
              AppButton(onPressed: _agregarMetodoPago, text: 'Guardar Tarjeta'),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoEliminar() {
    AppDialog.show(
      context: context,
      title: '¿Eliminar tarjeta?',
      content: 'Perderás el acceso a tu saldo actual. Esta acción no se puede deshacer.',
      confirmText: 'Sí, eliminar',
      cancelText: 'Cancelar',
      onConfirm: _eliminarMetodoPago,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      maxWidth: 1000,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            'Mi Billetera',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.md),

          FutureBuilder<MetodoPagoModel?>(
            future: _billeteraFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return _buildErrorCard(snapshot.error.toString());
              }

              final billetera = snapshot.data;
              if (billetera == null || !billetera.estado) {
                return _buildEmptyWalletCard();
              }

              return _buildActiveWalletCard(billetera);
            },
          ),

          const SizedBox(height: AppSpacing.xxl),

          Text(
            'Movimientos y Acciones',
            style: AppTextStyles.titleLarge,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _actionCard(Icons.add_circle_outline, 'Recargar', 'Añadir saldo', const Color(0xFFE0F7FA), const Color(0xFF00BCD4)),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _actionCard(Icons.star_outline, 'Recompensas', 'Ver mis estrellas', const Color(0xFFFFF3E0), const Color(0xFFFF5A1F)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  // --- WIDGETS PRIVADOS ---

  Widget _buildActiveWalletCard(MetodoPagoModel billetera) {
    final saldoFormateado = billetera.saldo.toStringAsFixed(2);

    return AppCard(
      padding: const EdgeInsets.all(24),
      backgroundColor: const Color(0xFF2C2C2C),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.credit_card, color: Colors.white54, size: 24),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    billetera.marcaTarjeta.isNotEmpty ? billetera.marcaTarjeta : 'LISTO! Card',
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textInverse.withOpacity(0.54)),
                  ),
                ],
              ),
              // NUEVO: Botón para eliminar
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.delete_outline, color: Colors.white54),
                onPressed: _mostrarDialogoEliminar,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Saldo disponible', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textInverse.withOpacity(0.54))),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'S/ $saldoFormateado',
            style: AppTextStyles.displaySmall.copyWith(color: AppColors.textInverse, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('TITULAR', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textInverse.withOpacity(0.54))),
                  Text(billetera.usuario, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textInverse)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('CARD', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textInverse.withOpacity(0.54))),
                  Text('•••• ${billetera.ultimosDigitos}', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textInverse)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWalletCard() {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      backgroundColor: AppColors.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_balance_wallet_outlined, size: 50, color: AppColors.textDisabled),
          const SizedBox(height: AppSpacing.md),
          Text('Aún no tienes una billetera', style: AppTextStyles.titleLarge),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Agrega un método de pago para empezar a disfrutar de los beneficios.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          // NUEVO: Botón para abrir el modal
          AppButton(
            text: 'Añadir Tarjeta',
            icon: Icons.add,
            onPressed: _mostrarModalAgregar,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      backgroundColor: Colors.red.shade50,
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 40),
          const SizedBox(height: AppSpacing.sm),
          Text('No pudimos cargar tu billetera', style: AppTextStyles.titleSmall.copyWith(color: AppColors.error)),
          const SizedBox(height: AppSpacing.xs),
          Text(error, textAlign: TextAlign.center, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
        ],
      ),
    );
  }

  Widget _actionCard(IconData icon, String title, String subtitle, Color bgColor, Color iconColor) {
    return AppCard(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(title, style: AppTextStyles.titleMedium),
          Text(subtitle, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}