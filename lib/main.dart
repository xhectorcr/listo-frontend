import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'core/constants/app_colors.dart';
import 'core/injection/injection_container.dart' as di;
import 'package:provider/provider.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/products/presentation/providers/product_provider.dart';
import 'features/products/presentation/providers/category_provider.dart';
import 'features/client/presentation/providers/cart_provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<ProductProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<CategoryProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<CartProvider>()),
      ],
      child: const ClienteApp(),
    ),
  );
}

class ClienteApp extends StatelessWidget {
  const ClienteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'LISTO! GO',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        fontFamily: 'Roboto',
      ),
      routerConfig: appRouter,
    );
  }
}
