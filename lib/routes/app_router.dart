import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:listo_app/features/admin/presentation/pages/lista_usuarios_page.dart'
    show ListaUsuariosPage;

import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/register_screen.dart';
import '../features/client/presentation/pages/home_screen.dart';
import '../features/admin/presentation/pages/admin_dashboard.dart';
import '../features/landing/presentation/pages/landing_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        // Mantenemos la lógica actual: si es web muestra la landing page, si no el login.
        if (kIsWeb) {
          return const LandingPage();
        }
        return const LoginScreen();
      },
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboard(),
    ),
    GoRoute(
      path: '/admin/usuarios',
      builder: (context, state) => const ListaUsuariosPage(),
    ),
  ],
);
