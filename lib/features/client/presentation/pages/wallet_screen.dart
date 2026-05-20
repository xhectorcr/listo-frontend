import 'package:flutter/material.dart';
import 'package:listo_app/core/local_storage/storage_service.dart';
import 'package:listo_app/features/client/presentation/models/metodo_pago_model.dart';
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
  
  final storage = StorageService();
  final idString = await storage.getId();

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
              const Text('Añadir Tarjeta', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(controller: _usuarioController, decoration: const InputDecoration(labelText: 'Titular', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Requerido' : null),
              const SizedBox(height: 10),
              TextFormField(controller: _marcaController, decoration: const InputDecoration(labelText: 'Marca (Visa/MC)', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Requerido' : null),
              const SizedBox(height: 10),
              TextFormField(controller: _numeroTarjetaController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Número de tarjeta', border: OutlineInputBorder()), validator: (v) => v!.length < 16 ? 'Mínimo 16 dígitos' : null),
              const SizedBox(height: 10),
              TextFormField(controller: _cvvController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'CVV', border: OutlineInputBorder()), validator: (v) => v!.length < 3 ? 'Inválido' : null),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _agregarMetodoPago, child: const Text('Guardar Tarjeta')),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarDialogoEliminar() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('¿Eliminar tarjeta?'),
          content: const Text('Perderás el acceso a tu saldo actual. Esta acción no se puede deshacer.'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: _eliminarMetodoPago,
              child: const Text('Sí, eliminar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mi Billetera',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

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

          const SizedBox(height: 40),

          const Text(
            'Movimientos y Acciones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
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
    );
  }

  // --- WIDGETS PRIVADOS ---

  Widget _buildActiveWalletCard(MetodoPagoModel billetera) {
    final saldoFormateado = billetera.saldo.toStringAsFixed(2);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.credit_card, color: Colors.white54, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    billetera.marcaTarjeta.isNotEmpty ? billetera.marcaTarjeta : 'LISTO! Card',
                    style: const TextStyle(color: Colors.white54, fontSize: 16),
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
          const SizedBox(height: 20),
          const Text('Saldo disponible', style: TextStyle(color: Colors.white54, fontSize: 14)),
          const SizedBox(height: 5),
          Text(
            'S/ $saldoFormateado',
            style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TITULAR', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  Text(billetera.usuario, style: const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('CARD', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  Text('•••• ${billetera.ultimosDigitos}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWalletCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_balance_wallet_outlined, size: 50, color: Colors.grey),
          const SizedBox(height: 15),
          const Text('Aún no tienes una billetera', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Agrega un método de pago para empezar a disfrutar de los beneficios.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 14),
          ),
          const SizedBox(height: 20),
          // NUEVO: Botón para abrir el modal
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: _mostrarModalAgregar,
            icon: const Icon(Icons.add),
            label: const Text('Añadir Tarjeta'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          const Text('No pudimos cargar tu billetera', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(error, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _actionCard(IconData icon, String title, String subtitle, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 15),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}