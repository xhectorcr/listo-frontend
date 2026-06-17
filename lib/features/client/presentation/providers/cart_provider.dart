import 'package:flutter/material.dart';
import '../../../../core/states/view_state.dart';
import '../../domain/usecases/get_cart_usecase.dart';

class CartProvider extends ChangeNotifier {
  final GetCartUseCase getCartUseCase;

  CartProvider({required this.getCartUseCase});

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<dynamic> _items = [];
  List<dynamic> get items => _items;

  double _total = 0.0;
  double get total => _total;

  Future<void> fetchCart(int userId, {bool isPolling = false}) async {
    if (!isPolling) {
      _state = ViewState.loading;
      _errorMessage = null;
      notifyListeners();
    }

    try {
      final result = await getCartUseCase(userId);
      _items = result['items'] ?? [];
      _total = (result['total'] ?? 0).toDouble();
      
      if (!isPolling) {
        _state = ViewState.success;
      }
      notifyListeners();
    } catch (e) {
      if (!isPolling) {
        _state = ViewState.error;
      }
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }
}
