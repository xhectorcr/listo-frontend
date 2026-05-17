import 'package:flutter/material.dart';
import '../../domain/repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository cartRepository;

  CartProvider({required this.cartRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<dynamic> _items = [];
  List<dynamic> get items => _items;

  double _total = 0.0;
  double get total => _total;

  Future<void> fetchCart(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await cartRepository.getCart(userId);
      _items = result['items'] ?? [];
      _total = (result['total'] ?? 0).toDouble();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }
}
