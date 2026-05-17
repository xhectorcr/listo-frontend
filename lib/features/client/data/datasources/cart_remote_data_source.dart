import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/env/environment.dart';

abstract class CartRemoteDataSource {
  Future<Map<String, dynamic>> getCart(int userId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  // Using the hardcoded localhost port as in original cart_screen, or Environment.
  // We'll use Environment and fallback if needed, but original had 5115.
  final String _baseUrl = 'http://127.0.0.1:5115/api';

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
