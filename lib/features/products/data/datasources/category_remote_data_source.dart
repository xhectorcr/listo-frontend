import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/env/environment.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories(String search);
  Future<bool> saveCategory(CategoryModel category);
  Future<bool> deleteCategory(int id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final String _baseUrl = Environment.apiUrl;

  @override
  Future<List<CategoryModel>> getCategories(String search) async {
    final uri = Uri.parse('$_baseUrl/categoria/lista').replace(
      queryParameters: {'pSearch': search},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((c) => CategoryModel.fromJson(c)).toList();
    } else {
      throw Exception('Error al cargar las categorías. Código: ${response.statusCode}');
    }
  }

  @override
  Future<bool> saveCategory(CategoryModel category) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/categoria'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(category.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Error al guardar la categoría');
    }
  }

  @override
  Future<bool> deleteCategory(int id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/categoria/$id'),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Error al eliminar la categoría');
    }
  }
}
