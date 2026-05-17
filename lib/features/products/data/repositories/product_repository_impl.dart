import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> getProducts({
    int pageNumber = 1,
    int pageSize = 10,
    String search = "",
    int categoryId = 0,
  }) async {
    return await remoteDataSource.getProducts(pageNumber, pageSize, search, categoryId);
  }

  @override
  Future<Product?> getProductById(int id) async {
    return await remoteDataSource.getProductById(id);
  }

  @override
  Future<bool> saveProduct(Product product) async {
    final productModel = ProductModel(
      idProducto: product.idProducto,
      nombre: product.nombre,
      activo: product.activo,
      descripcion: product.descripcion,
      imagen: product.imagen,
      yoloLabel: product.yoloLabel,
      stock: product.stock,
      precio: product.precio,
      idCategoria: product.idCategoria,
      categoria: product.categoria,
    );
    return await remoteDataSource.saveProduct(productModel);
  }

  @override
  Future<bool> updateProduct(Product product) async {
    final productModel = ProductModel(
      idProducto: product.idProducto,
      nombre: product.nombre,
      activo: product.activo,
      descripcion: product.descripcion,
      imagen: product.imagen,
      yoloLabel: product.yoloLabel,
      stock: product.stock,
      precio: product.precio,
      idCategoria: product.idCategoria,
      categoria: product.categoria,
    );
    return await remoteDataSource.updateProduct(productModel);
  }

  @override
  Future<bool> deleteProduct(int id) async {
    return await remoteDataSource.deleteProduct(id);
  }
}
