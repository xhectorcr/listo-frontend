import '../entities/product.dart';

abstract class ProductRepository {
  Future<Map<String, dynamic>> getProducts({
    int pageNumber = 1,
    int pageSize = 10,
    String search = "",
    int categoryId = 0,
  });
  
  Future<Product?> getProductById(int id);
  Future<bool> saveProduct(Product product);
  Future<bool> updateProduct(Product product);
  Future<bool> deleteProduct(int id);
}
