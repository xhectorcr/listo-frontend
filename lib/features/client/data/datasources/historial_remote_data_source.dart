import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/env/environment.dart';

abstract class HistorialRemoteDataSource {
  Future<List<dynamic>> getHistorial(int userId);
}

class HistorialRemoteDataSourceImpl implements HistorialRemoteDataSource {
  final String _baseUrl = Environment.apiUrl;

  @override
  Future<List<dynamic>> getHistorial(int userId) async {
    final url = Uri.parse('$_baseUrl/usuario/$userId/historial');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['success'] == true) {
        return jsonResponse['data'] as List<dynamic>;
      }
      return [];
    } else {
      throw Exception('Error al cargar el historial');
    }
  }
}
