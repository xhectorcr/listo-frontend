import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/env/environment.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<Map<String, dynamic>> getProducts(int pageNumber, int pageSize, String search, int categoryId);
  Future<ProductModel> getProductById(int id);
  Future<bool> saveProduct(ProductModel product);
  Future<bool> updateProduct(ProductModel product);
  Future<bool> deleteProduct(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final String _baseUrl = Environment.apiUrl;

  @override
  Future<Map<String, dynamic>> getProducts(int pageNumber, int pageSize, String search, int categoryId) async {
    final uri = Uri.parse('$_baseUrl/producto/lista/activos').replace(
      queryParameters: {
        'pageNumber': pageNumber.toString(),
        'pageSize': pageSize.toString(),
        'pSearch': search,
        'idCategoria': categoryId.toString(),
      },
    );

    final response = await http.get(uri);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<dynamic> platosJson = data['data'] ?? [];
      List<ProductModel> productos = platosJson.map((p) => ProductModel.fromJson(p)).toList();

      return {
        'data': productos,
        'pageNumber': data['pageNumber'],
        'pageSize': data['pageSize'],
        'totalCount': data['totalCount'],
        'totalPages': data['totalPages'],
      };
    } else {
      throw Exception(data['message'] ?? 'Error al cargar los productos');
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/producto/$id'));
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ProductModel.fromJson(data);
    } else {
      throw Exception(data['mensaje'] ?? 'Error al obtener producto');
    }
  }

  @override
  Future<bool> saveProduct(ProductModel product) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/producto'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Error al guardar');
    }
  }

  @override
  Future<bool> updateProduct(ProductModel product) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/producto'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Error al actualizar');
    }
  }

  @override
  Future<bool> deleteProduct(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/producto?id=$id'));
    
    if (response.statusCode == 200) {
      return true;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Error al eliminar');
    }
  }
}
