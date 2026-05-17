import 'package:flutter/material.dart';
import 'features/admin/presentation/pages/admin_login_screen.dart';
import 'core/injection/injection_container.dart' as di;
import 'package:provider/provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/products/presentation/providers/product_provider.dart';
import 'features/products/presentation/providers/category_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProductProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<CategoryProvider>()),
      ],
      child: const AdminApp(),
    ),
  );
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LISTO! GO Admin',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF5A1F),
        fontFamily: 'Roboto',
      ),
      home: const AdminLoginScreen(),
    );
  }
}
