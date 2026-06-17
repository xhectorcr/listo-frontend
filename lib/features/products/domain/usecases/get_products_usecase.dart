import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    int pageNumber = 1,
    int pageSize = 10,
    String search = "",
    int categoryId = 0,
  }) {
    return repository.getProducts(
      pageNumber: pageNumber,
      pageSize: pageSize,
      search: search,
      categoryId: categoryId,
    );
  }
}
