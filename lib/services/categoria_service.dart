import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/environment.dart'; 
import '../models/categoria_model.dart'; 

class CategoriaService {
  final String _baseUrl = Environment.apiUrl;

  Future<Map<String, dynamic>> getLista({String pSearch = ""}) async {
    try {
      final uri = Uri.parse('$_baseUrl/categoria/lista').replace(
        queryParameters: {
          'pSearch': pSearch,
        },
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<Categoria> categorias = jsonList.map((c) => Categoria.fromJson(c)).toList();

        return {
          'success': true,
          'data': categorias,
        };
      } else {
        return {
          'success': false,
          'message': 'Error al cargar las categorías. Código: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error en getLista (Categorias): $e');
      return {'success': false, 'message': 'Error de conexión HTTP'};
    }
  }

  Future<Map<String, dynamic>> saveCategoria(Categoria categoria) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/categoria'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(categoria.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'Categoría guardada'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Error al guardar la categoría'};
      }
    } catch (e) {
      print('Error en saveCategoria: $e');
      return {'success': false, 'message': 'Error de conexión HTTP'};
    }
  }
  Future<Map<String, dynamic>> deleteCategoria(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/categoria/$id'),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'Categoría eliminada'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Error al eliminar la categoría'};
      }
    } catch (e) {
      print('Error en deleteCategoria: $e');
      return {'success': false, 'message': 'Error de conexión HTTP'};
    }
  }
}