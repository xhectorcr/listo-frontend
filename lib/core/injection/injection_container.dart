import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Auth Feature
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

// Products Feature
import '../../features/products/data/datasources/category_remote_data_source.dart';
import '../../features/products/data/datasources/product_remote_data_source.dart';
import '../../features/products/data/repositories/category_repository_impl.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/category_repository.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/domain/usecases/get_products_usecase.dart';
import '../../features/products/domain/usecases/save_product_usecase.dart';
import '../../features/products/domain/usecases/update_product_usecase.dart';
import '../../features/products/domain/usecases/delete_product_usecase.dart';
import '../../features/products/presentation/providers/category_provider.dart';
import '../../features/products/presentation/providers/product_provider.dart';

// Client Feature
import '../../features/client/data/datasources/cart_remote_data_source.dart';
import '../../features/client/data/repositories/cart_repository_impl.dart';
import '../../features/client/domain/repositories/cart_repository.dart';
import '../../features/client/domain/usecases/get_cart_usecase.dart';
import '../../features/client/presentation/providers/cart_provider.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  // ---------------------------------------------------------------------------
  // Core & Externe Dependencies
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => http.Client());

  // ---------------------------------------------------------------------------
  // Features: Auth
  // ---------------------------------------------------------------------------
  
  // Providers (Presentación) - Factory porque queremos una nueva instancia si hace falta, o Singleton si es global
  sl.registerFactory(() => AuthProvider(
    loginUseCase: sl(),
    registerUseCase: sl(),
  ));

  // Casos de Uso (Dominio)
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // Repositorios (Dominio/Data)
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources (Data)
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );

  // ---------------------------------------------------------------------------
  // Features: Products
  // ---------------------------------------------------------------------------
  
  sl.registerFactory(() => ProductProvider(
    getProductsUseCase: sl(),
    saveProductUseCase: sl(),
    updateProductUseCase: sl(),
    deleteProductUseCase: sl(),
  ));
  
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => SaveProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));

  sl.registerFactory(() => CategoryProvider(categoryRepository: sl()));

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(),
  );

  // ---------------------------------------------------------------------------
  // Features: Client (Cart)
  // ---------------------------------------------------------------------------
  
  // Casos de Uso
  sl.registerLazySingleton(() => GetCartUseCase(sl()));

  sl.registerFactory(() => CartProvider(getCartUseCase: sl()));

  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<CartRemoteDataSource>(
    () => CartRemoteDataSourceImpl(),
  );
}
