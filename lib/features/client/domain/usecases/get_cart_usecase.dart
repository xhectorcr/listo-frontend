import '../repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<Map<String, dynamic>> call(int userId) {
    return repository.getCart(userId);
  }
}
