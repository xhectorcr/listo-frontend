import 'package:flutter/material.dart';
import '../../data/services/usuario_service.dart';
import '../../data/services/cupon_service.dart';

class PremiosView extends StatefulWidget {
  const PremiosView({super.key});

  @override
  State<PremiosView> createState() => _PremiosViewState();
}

class _PremiosViewState extends State<PremiosView> {
  final UsuarioService _usuarioService = UsuarioService();
  final CuponService _cuponService = CuponService();
  
  late Future<List<dynamic>> _usuariosFuture;
  final TextEditingController _manualEmailController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = "";
  bool _isSendingManual = false;
  int _sentCouponsCount = 14; // Contador simulado de cupones enviados
  
  // Trackea qué usuarios están en proceso de envío
  final Map<String, bool> _sendingStatusMap = {};

  @override
  void initState() {
    super.initState();
    _refreshUsuarios();
  }

  void _refreshUsuarios() {
    setState(() {
      _usuariosFuture = _usuarioService.obtenerUsuarios();
    });
  }

  @override
  void dispose() {
    _manualEmailController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _enviarCuponManual() async {
    final email = _manualEmailController.text.trim();
    if (email.isEmpty) {
      _showSnackBar("Por favor ingresa un correo electrónico válido", isError: true);
      return;
    }

    setState(() => _isSendingManual = true);

    final resultado = await _cuponService.enviarCupon(email);

    if (mounted) {
      setState(() {
        _isSendingManual = false;
        if (resultado['success'] == true) {
          _manualEmailController.clear();
          _sentCouponsCount++;
        }
      });
      _showSnackBar(
        resultado['message'] ?? '',
        isError: resultado['success'] != true,
      );
    }
  }

  Future<void> _enviarCuponAUsuario(String userId, String email) async {
    setState(() => _sendingStatusMap[userId] = true);

    final resultado = await _cuponService.enviarCupon(email);

    if (mounted) {
      setState(() {
        _sendingStatusMap[userId] = false;
        if (resultado['success'] == true) {
          _sentCouponsCount++;
        }
      });
      _showSnackBar(
        resultado['message'] ?? '',
        isError: resultado['success'] != true,
      );
    }
  }

  void _showSnackBar(String mensaje, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                mensaje,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _usuariosFuture,
      builder: (context, snapshot) {
        int totalClientes = 0;
        if (snapshot.hasData) {
          totalClientes = snapshot.data!.length;
        }

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              _buildHeader(),
              const SizedBox(height: 24),

              // Fila de Estadísticas
              _buildStatsRow(totalClientes),
              const SizedBox(height: 24),

              // Envío Manual y Búsqueda (Responsive layout)
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 4, child: _buildManualSendCard()),
                        const SizedBox(width: 20),
                        Expanded(flex: 5, child: _buildSearchSection()),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildManualSendCard(),
                        const SizedBox(height: 20),
                        _buildSearchSection(),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),

              // Lista de Usuarios
              Expanded(
                child: _buildUsersList(snapshot),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.star, color: Color(0xFFFF5A1F), size: 32),
                SizedBox(width: 8),
                Text(
                  "Premios y Cupones",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Envía cupones promocionales a tus clientes fidelizados.",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: _refreshUsuarios,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text("Actualizar"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF5A1F),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow(int totalClientes) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Campaña Activa",
            "BIENVENIDA15",
            Icons.local_offer,
            Colors.blue.shade600,
            subtitle: "15% de descuento en la 1ra compra",
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            "Cupones Enviados",
            "$_sentCouponsCount",
            Icons.mail_outline,
            Colors.green.shade600,
            subtitle: "Enviados en total esta sesión",
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            "Clientes Registrados",
            "$totalClientes",
            Icons.people_outline,
            Colors.amber.shade700,
            subtitle: "Clientes hábiles para cupones",
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            radius: 24,
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualSendCard() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Enviar Cupón Manual",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _manualEmailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "ejemplo@correo.com",
                    labelText: "Correo Electrónico",
                    labelStyle: const TextStyle(color: Color(0xFFFF5A1F)),
                    prefixIcon: const Icon(Icons.email, color: Color(0xFFFF5A1F)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFFFF5A1F)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isSendingManual ? null : _enviarCuponManual,
                  icon: _isSendingManual
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send),
                  label: Text(_isSendingManual ? "Enviando..." : "Enviar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5A1F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Text(
            "Se enviará el cupón de bienvenida 'BIENVENIDA15' al correo ingresado.",
            style: TextStyle(color: Colors.grey[600], fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Buscar Clientes",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            decoration: InputDecoration(
              hintText: "Buscar por nombre, correo...",
              prefixIcon: const Icon(Icons.search, color: Color(0xFFFF5A1F)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFFFF5A1F)),
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = "";
                        });
                      },
                    )
                  : null,
            ),
          ),
          Text(
            "Filtra la lista de clientes para enviarles cupones rápidamente.",
            style: TextStyle(color: Colors.grey[600], fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList(AsyncSnapshot<List<dynamic>> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5A1F)),
        ),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 12),
            const Text(
              "Error al cargar la lista de clientes",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _refreshUsuarios,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5A1F),
                foregroundColor: Colors.white,
              ),
              child: const Text("Reintentar"),
            )
          ],
        ),
      );
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 12),
            Text(
              "No hay clientes registrados en el sistema.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    final allUsuarios = snapshot.data!;
    final filteredUsuarios = allUsuarios.where((user) {
      final String nombre = (user['nombre'] ?? '').toString().toLowerCase();
      final String correo = (user['correo'] ?? '').toString().toLowerCase();
      final query = _searchQuery.toLowerCase();
      return nombre.contains(query) || correo.contains(query);
    }).toList();

    if (filteredUsuarios.isEmpty) {
      return Center(
        child: Text(
          "No se encontraron clientes para '$_searchQuery'",
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      );
    }

    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.separated(
          itemCount: filteredUsuarios.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final user = filteredUsuarios[index];
            final String nombre = user['nombre'] ?? 'Sin nombre';
            final String correo = user['correo'] ?? 'Sin correo';
            final String id = (user['idUsuario'] ?? user['id'] ?? user['id_usuario'] ?? '').toString();
            final int estrellas = int.tryParse(user['estrellas']?.toString() ?? '') ?? 0;
            final String inicial = nombre.isNotEmpty ? nombre[0].toUpperCase() : 'C';
            final bool isSending = _sendingStatusMap[id] ?? false;

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFFF5A1F).withOpacity(0.1),
                child: Text(
                  inicial,
                  style: const TextStyle(
                    color: Color(0xFFFF5A1F),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Row(
                children: [
                  Text(
                    nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 10, color: Colors.amber),
                        const SizedBox(width: 3),
                        Text(
                          "$estrellas ⭐",
                          style: TextStyle(
                            color: Colors.amber.shade900,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              subtitle: Text(correo),
              trailing: SizedBox(
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: isSending
                      ? null
                      : () => _enviarCuponAUsuario(id, correo),
                  icon: isSending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Color(0xFFFF5A1F)),
                          ),
                        )
                      : const Icon(Icons.card_giftcard, size: 16),
                  label: Text(isSending ? "Enviando..." : "Enviar Cupón"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5A1F).withOpacity(0.1),
                    foregroundColor: const Color(0xFFFF5A1F),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
