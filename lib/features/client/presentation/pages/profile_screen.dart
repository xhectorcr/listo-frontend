import 'package:flutter/material.dart';
import '../../../../core/local_storage/storage_service.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_text_styles.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_container.dart';
import '../../../landing/presentation/pages/landing_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final StorageService _storageService = StorageService();

  String _userName = 'Cargando...';
  String _userRole = 'Cargando...';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final name = await _storageService.getUserName();
    final role = await _storageService.getRole();

    setState(() {
      _userName = name ?? 'Usuario Invitado';
      _userRole = role ?? 'Sin Rol';
    });
  }

  Future<void> _logout() async {
    // Limpiamos la bóveda segura
    await _storageService.clearAuthData();

    if (!mounted) return;

    // Regresamos a la Landing pública y destruimos el historial de navegación
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AppContainer(
          maxWidth: 800,
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            child: Column(
              children: [
            // Header del Perfil envuelto en un Stack para poner la "X"
            Stack(
              children: [
                // El fondo naranja curvo
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 80, bottom: 40),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                      bottomRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Avatar Dinámico (Toma la primera letra del nombre)
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.surface,
                        child: Text(
                          _userName.isNotEmpty
                              ? _userName[0].toUpperCase()
                              : 'L',
                          style: AppTextStyles.displayMedium.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Nombre de usuario
                      Text(
                        _userName,
                        style: AppTextStyles.headlineSmall.copyWith(
                          color: AppColors.textInverse,
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Rol tipo "Badge"
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _userRole.toUpperCase(),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.textInverse,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textInverse,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            // Opciones del perfil (Tarjetas)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildProfileOption(
                    icon: Icons.payment_outlined,
                    title: 'Métodos de Pago',
                    subtitle: 'Tarjetas y efectivo',
                    onTap: () {},
                  ),
                  _buildProfileOption(
                    icon: Icons.help_outline,
                    title: 'Soporte',
                    subtitle: 'Preguntas frecuentes y ayuda',
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Botón de Cerrar Sesión
                  AppButton(
                    text: 'Cerrar Sesión',
                    icon: Icons.logout,
                    type: AppButtonType.outline,
                    onPressed: _logout,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
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

  // Widget reutilizable para las opciones del menú
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: AppTextStyles.titleMedium),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodyMedium,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textDisabled,
        ),
        onTap: onTap,
      ),
    );
  }
}
