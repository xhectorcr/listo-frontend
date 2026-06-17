import 'package:flutter/material.dart';
import '../../../../core/states/view_state.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/save_product_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';

class ProductProvider extends ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;
  final SaveProductUseCase saveProductUseCase;
  final UpdateProductUseCase updateProductUseCase;
  final DeleteProductUseCase deleteProductUseCase;

  ProductProvider({
    required this.getProductsUseCase,
    required this.saveProductUseCase,
    required this.updateProductUseCase,
    required this.deleteProductUseCase,
  });

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Product> _products = [];
  List<Product> get products => _products;

  int _totalCount = 0;
  int get totalCount => _totalCount;

  int _totalPages = 1;
  int get totalPages => _totalPages;

  Future<void> fetchProducts({
    int pageNumber = 1,
    int pageSize = 10,
    String search = "",
    int categoryId = 0,
  }) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await getProductsUseCase(
        pageNumber: pageNumber,
        pageSize: pageSize,
        search: search,
        categoryId: categoryId,
      );

      _products = result['data'] as List<Product>;
      _totalCount = result['totalCount'] as int;
      _totalPages = result['totalPages'] as int;
      _state = ViewState.success;
      notifyListeners();
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<bool> saveProduct(Product product) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await saveProductUseCase(product);
      _state = ViewState.success;
      notifyListeners();
      return success;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(Product product) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await updateProductUseCase(product);
      _state = ViewState.success;
      notifyListeners();
      return success;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await deleteProductUseCase(id);
      _state = ViewState.success;
      notifyListeners();
      return success;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
