import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/services/usuario_service.dart';

class ListaUsuariosPage extends StatefulWidget {
  final bool isEmbedded;
  const ListaUsuariosPage({super.key, this.isEmbedded = false});

  @override
  State<ListaUsuariosPage> createState() => _ListaUsuariosPageState();
}

class _ListaUsuariosPageState extends State<ListaUsuariosPage> {
  final UsuarioService _usuarioService = UsuarioService();
  late Future<List<dynamic>> _usuariosFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

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
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget pageBody = FutureBuilder<List<dynamic>>(
      future: _usuariosFuture,
      builder: (context, snapshot) {
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
                const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                const SizedBox(height: 16),
                const Text(
                  "Error al cargar los usuarios",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  "No hay usuarios registrados.",
                  style: TextStyle(fontSize: 18, color: Colors.grey[600], fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _refreshUsuarios,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Actualizar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5A1F),
                    foregroundColor: Colors.white,
                  ),
                )
              ],
            ),
          );
        }

        final allUsuarios = snapshot.data!;
        
        // Filtrar usuarios localmente según la consulta de búsqueda
        final filteredUsuarios = allUsuarios.where((user) {
          final String nombre = (user['nombre'] ?? '').toString().toLowerCase();
          final String correo = (user['correo'] ?? '').toString().toLowerCase();
          final String id = (user['idUsuario'] ?? user['id'] ?? user['id_usuario'] ?? '').toString().toLowerCase();
          final query = _searchQuery.toLowerCase();
          return nombre.contains(query) || correo.contains(query) || id.contains(query);
        }).toList();

        // Calcular estadísticas dinámicas
        int totalUsuarios = allUsuarios.length;
        double sumSaldo = 0;
        int sumEstrellas = 0;
        for (var user in allUsuarios) {
          final saldo = double.tryParse(user['saldo']?.toString() ?? '') ?? 0.0;
          final estrellas = int.tryParse(user['estrellas']?.toString() ?? '') ?? 0;
          sumSaldo += saldo;
          sumEstrellas += estrellas;
        }
        double saldoPromedio = totalUsuarios > 0 ? sumSaldo / totalUsuarios : 0.0;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado de la página
              _buildHeader(),
              
              // Tarjetas de estadísticas
              _buildStatsRow(totalUsuarios, saldoPromedio, sumEstrellas),
              const SizedBox(height: 20),

              // Barra de búsqueda interactiva
              _buildSearchBar(),
              const SizedBox(height: 20),

              // Lista o Cuadrícula de Usuarios (Responsive)
              Expanded(
                child: filteredUsuarios.isEmpty
                    ? Center(
                        child: Text(
                          "No se encontraron resultados para '$_searchQuery'",
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 900) {
                            // Pantalla ancha (Escritorio/Web): Cuadrícula
                            return GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3.5,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemCount: filteredUsuarios.length,
                              itemBuilder: (context, index) {
                                return _buildUserCard(filteredUsuarios[index]);
                              },
                            );
                          } else {
                            // Pantalla angosta (Móvil): Lista vertical
                            return ListView.builder(
                              itemCount: filteredUsuarios.length,
                              itemBuilder: (context, index) {
                                return _buildUserCard(filteredUsuarios[index]);
                              },
                            );
                          }
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );

    if (widget.isEmbedded) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: pageBody,
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Usuarios Registrados',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C2C2C),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshUsuarios,
          ),
        ],
      ),
      body: pageBody,
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
                Icon(Icons.supervised_user_circle, color: Color(0xFFFF5A1F), size: 32),
                SizedBox(width: 8),
                Text(
                  "Usuarios Registrados",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF2C2C2C)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "Monitorea a los usuarios, sus recompensas (estrellas) y saldos.",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
        if (widget.isEmbedded)
          ElevatedButton.icon(
            onPressed: _refreshUsuarios,
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text("Actualizar"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5A1F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 1,
            ),
          ),
      ],
    );
  }

  Widget _buildStatsRow(int total, double promedioSaldo, int totalEstrellas) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final bool useVerticalLayout = width < 600;

        final cards = [
          _buildStatCard(
            "Total Usuarios",
            "$total",
            Icons.people,
            Colors.blue.shade600,
          ),
          _buildStatCard(
            "Saldo Promedio",
            "S/ ${promedioSaldo.toStringAsFixed(2)}",
            Icons.account_balance_wallet,
            Colors.green.shade600,
          ),
          _buildStatCard(
            "Estrellas Totales",
            "$totalEstrellas ⭐",
            Icons.star,
            Colors.amber.shade700,
          ),
        ];

        if (useVerticalLayout) {
          return Column(
            children: cards.map((c) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: SizedBox(width: double.infinity, child: c),
            )).toList(),
          );
        }

        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            children: cards.map((c) => Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: c,
              ),
            )).toList(),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C2C2C)),
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

  Widget _buildSearchBar() {
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
          });
        },
        decoration: InputDecoration(
          hintText: "Buscar por nombre, correo o ID...",
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFFF5A1F)),
          border: InputBorder.none,
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
    );
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final String nombre = user['nombre'] ?? 'Sin nombre';
    final String correo = user['correo'] ?? 'Sin correo';
    final String id = (user['idUsuario'] ?? user['id'] ?? user['id_usuario'] ?? 'N/A').toString();
    final String estrellas = (user['estrellas'] ?? '0').toString();
    final String saldo = double.tryParse(user['saldo']?.toString() ?? '')?.toStringAsFixed(2) ?? '0.00';
    final bool activo = user['activo'] ?? true;
    final String inicial = nombre.isNotEmpty ? nombre[0].toUpperCase() : 'U';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => _showUserDetailDialog(user),
          hoverColor: const Color(0xFFFF5A1F).withOpacity(0.02),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF5A1F), Color(0xFFFF8A5C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF5A1F).withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      inicial,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              nombre,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2C2C2C)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: activo ? Colors.green.shade50 : Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: activo ? Colors.green.shade200 : Colors.red.shade200),
                            ),
                            child: Text(
                              activo ? "Activo" : "Inactivo",
                              style: TextStyle(
                                color: activo ? Colors.green.shade700 : Colors.red.shade700,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // ID y correo electrónico
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.fingerprint, size: 12, color: Colors.grey[600]),
                                const SizedBox(width: 3),
                                Text(
                                  "ID: $id",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Row(
                              children: [
                                Icon(Icons.mail_outline, size: 12, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    correo,
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star, size: 12, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  "$estrellas ⭐",
                                  style: TextStyle(
                                    color: Colors.amber.shade900,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.account_balance_wallet, size: 12, color: Colors.green),
                                const SizedBox(width: 4),
                                Text(
                                  "S/ $saldo",
                                  style: TextStyle(
                                    color: Colors.green.shade900,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showUserDetailDialog(Map<String, dynamic> user) {
    final String nombre = user['nombre'] ?? 'Sin nombre';
    final String correo = user['correo'] ?? 'Sin correo';
    final String id = (user['idUsuario'] ?? user['id'] ?? user['id_usuario'] ?? 'N/A').toString();
    final String estrellas = (user['estrellas'] ?? '0').toString();
    final String saldo = double.tryParse(user['saldo']?.toString() ?? '')?.toStringAsFixed(2) ?? '0.00';
    final bool activo = user['activo'] ?? true;
    final String rol = user['rol'] ?? 'Cliente';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.person, color: Color(0xFFFF5A1F)),
              const SizedBox(width: 8),
              const Text("Detalle de Usuario", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFFF5A1F), Color(0xFFFF8A5C)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        nombre.isNotEmpty ? nombre[0].toUpperCase() : 'U',
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    nombre,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2C2C2C)),
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Chip(
                    label: Text(
                      rol.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: const Color(0xFF2C2C2C),
                  ),
                ),
                const Divider(height: 24),
                
                // ID con opción de copiado
                _buildDetailRow(
                  label: "ID de Usuario",
                  value: id,
                  icon: Icons.fingerprint,
                  trailing: IconButton(
                    icon: const Icon(Icons.copy, size: 18, color: Colors.grey),
                    tooltip: "Copiar ID",
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("ID copiado al portapapeles"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                
                // Correo Electrónico
                _buildDetailRow(
                  label: "Correo Electrónico",
                  value: correo,
                  icon: Icons.email,
                ),
                const SizedBox(height: 12),
                
                // Saldo
                _buildDetailRow(
                  label: "Saldo Simulador",
                  value: "S/ $saldo",
                  icon: Icons.account_balance_wallet,
                  valueColor: Colors.green.shade800,
                ),
                const SizedBox(height: 12),
                
                // Estrellas
                _buildDetailRow(
                  label: "Recompensas Acumuladas",
                  value: "$estrellas Estrellas ⭐",
                  icon: Icons.star,
                  valueColor: Colors.amber.shade900,
                ),
                const SizedBox(height: 12),
                
                // Estado
                _buildDetailRow(
                  label: "Estado de la Cuenta",
                  value: activo ? "Activa / Habilitada" : "Inactiva / Bloqueada",
                  icon: Icons.security,
                  valueColor: activo ? Colors.green.shade700 : Colors.red.shade700,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cerrar", style: TextStyle(color: Color(0xFFFF5A1F), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required IconData icon,
    Widget? trailing,
    Color? valueColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? const Color(0xFF2C2C2C),
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    );
  }
}
