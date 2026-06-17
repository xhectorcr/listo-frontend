import 'package:flutter/material.dart';
import '../../../../core/states/view_state.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository categoryRepository;

  CategoryProvider({required this.categoryRepository});

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  Future<void> fetchCategories({String search = ""}) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await categoryRepository.getCategories(search: search);
      _categories = result;
      _state = ViewState.success;
      notifyListeners();
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<bool> saveCategory(Category category) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await categoryRepository.saveCategory(category);
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

  Future<bool> deleteCategory(int id) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await categoryRepository.deleteCategory(id);
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
