import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SaveProductUseCase {
  final ProductRepository repository;

  SaveProductUseCase(this.repository);

  Future<bool> call(Product product) {
    return repository.saveProduct(product);
  }
}
