import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/env/environment.dart';

abstract class CartRemoteDataSource {
  Future<Map<String, dynamic>> getCart(int userId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  // Using the API URL from Environment configuration
  final String _baseUrl = Environment.apiUrl;

  @override
  Future<Map<String, dynamic>> getCart(int userId) async {
    final url = Uri.parse('$_baseUrl/carrito/$userId');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al cargar el carrito');
    }
  }
}
