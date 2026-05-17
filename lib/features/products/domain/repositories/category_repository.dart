import '../entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories({String search = ""});
  Future<bool> saveCategory(Category category);
  Future<bool> deleteCategory(int id);
}
