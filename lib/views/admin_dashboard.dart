import 'package:flutter/material.dart';
import '../views/summary_view.dart';
import '../views/inventory_view.dart';
import '../views/live_monitor_view.dart';
import 'admin_login_screen.dart';
import '../services/storage_service.dart';
import 'admin_scanner_view.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedView = 0;
  bool _isExpanded = false;

  final StorageService _storageService = StorageService();
  String _userName = '';
  String _userRole = '';

  final List<Widget> _views = [
    const SummaryView(),
    const InventoryView(),
    const LiveMonitorView(),
    const Center(child: Text("Configuración de Recompensas")),
    const AdminScannerView(),
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final name = await _storageService.getUserName();
    final role = await _storageService.getRole();

    setState(() {
      _userName = name ?? 'Admin';
      _userRole = role ?? 'Sin Rol';
    });
  }

  Future<void> _handleLogout() async {
    await _storageService.clearAuthData();

    // Volvemos al login
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // SIDEBAR
          Container(
            color: const Color(0xFF2C2C2C),
            child: Column(
              children: [
                Expanded(
                  child: NavigationRail(
                    extended: _isExpanded,
                    backgroundColor: const Color(0xFF2C2C2C),
                    unselectedIconTheme: const IconThemeData(
                      color: Colors.white54,
                    ),
                    selectedIconTheme: const IconThemeData(
                      color: Color(0xFFFF5A1F),
                    ),
                    unselectedLabelTextStyle: const TextStyle(
                      color: Colors.white54,
                    ),
                    selectedLabelTextStyle: const TextStyle(
                      color: Color(0xFFFF5A1F),
                      fontWeight: FontWeight.bold,
                    ),
                    leading: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 16.0,
                            top: 10.0,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded;
                              });
                            },
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFF5A1F),
                          radius: _isExpanded ? 30 : 20,
                          child: Text(
                            _userName.isNotEmpty
                                ? _userName[0].toUpperCase()
                                : 'A',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: _isExpanded ? 24 : 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_isExpanded) ...[
                          Text(
                            _userName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _userRole,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ],
                    ),

                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.dashboard),
                        label: Text("Resumen"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.inventory_2),
                        label: Text("Inventario"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.videocam),
                        label: Text("Monitor en Vivo"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.star),
                        label: Text("Premios"),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.qr_code_scanner),
                        label: Text("Escanear QR"),
                      ),
                    ],
                    selectedIndex: _selectedView,
                    onDestinationSelected: (int index) {
                      setState(() => _selectedView = index);
                    },
                  ),
                ),
                InkWell(
                  onTap: _handleLogout,
                  child: Container(
                    width: _isExpanded ? 200 : 72,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.logout, color: Colors.redAccent),
                        if (_isExpanded) ...[
                          const SizedBox(width: 15),
                          const Text(
                            "Cerrar Sesión",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: _views[_selectedView],
            ),
          ),
        ],
      ),
    );
  }
}
