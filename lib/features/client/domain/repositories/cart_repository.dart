abstract class CartRepository {
  Future<Map<String, dynamic>> getCart(int userId);
}
