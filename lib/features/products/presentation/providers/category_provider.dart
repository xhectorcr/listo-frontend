import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository categoryRepository;

  CategoryProvider({required this.categoryRepository});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  Future<void> fetchCategories({String search = ""}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await categoryRepository.getCategories(search: search);
      _categories = result;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<bool> saveCategory(Category category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await categoryRepository.saveCategory(category);
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await categoryRepository.deleteCategory(id);
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }
}
