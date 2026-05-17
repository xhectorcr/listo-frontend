import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Category>> getCategories({String search = ""}) async {
    return await remoteDataSource.getCategories(search);
  }

  @override
  Future<bool> saveCategory(Category category) async {
    final categoryModel = CategoryModel(
      idCategoria: category.idCategoria,
      nombre: category.nombre,
      activo: category.activo,
    );
    return await remoteDataSource.saveCategory(categoryModel);
  }

  @override
  Future<bool> deleteCategory(int id) async {
    return await remoteDataSource.deleteCategory(id);
  }
}
