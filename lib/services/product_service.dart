import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/environment.dart'; 
import '../models/producto_model.dart'; 

class ProductService {
  final String _baseUrl = Environment.apiUrl;

  Future<Map<String, dynamic>> getProductosLista({
    int pageNumber = 1,
    int pageSize = 10,
    String pSearch = "",
    int idCategoria = 0,
  }) async {
    try {

      final uri = Uri.parse('$_baseUrl/producto/lista/activos').replace(
        queryParameters: {
          'pageNumber': pageNumber.toString(),
          'pageSize': pageSize.toString(),
          'pSearch': pSearch,
          'idCategoria': idCategoria.toString(),
        },
      );

      final response = await http.get(uri);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List<dynamic> platosJson = data['data'] ?? [];
        List<Producto> productos = platosJson.map((p) => Producto.fromJson(p)).toList();

        return {
          'success': true,
          'data': productos,
          'pageNumber': data['pageNumber'],
          'pageSize': data['pageSize'],
          'totalCount': data['totalCount'],
          'totalPages': data['totalPages'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error al cargar los productos'
        };
      }
    } catch (e) {
      print('Error en getProductosLista: $e');
      return {'success': false, 'message': 'Error de conexión HTTP'};
    }
  }

  // 2. POST: api/producto
  Future<Map<String, dynamic>> guardarProducto(Producto producto) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/producto'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(producto.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'Producto guardado'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Error al guardar'};
      }
    } catch (e) {
      print('Error en guardarProducto: $e');
      return {'success': false, 'message': 'Error de conexión HTTP'};
    }
  }

  Future<Map<String, dynamic>> actualizarProducto(Producto producto) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/producto'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(producto.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'Producto actualizado'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Error al actualizar'};
      }
    } catch (e) {
      print('Error en actualizarProducto: $e');
      return {'success': false, 'message': 'Error de conexión HTTP'};
    }
  }


  Future<Map<String, dynamic>> getPlatoById(int pId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/producto/$pId'),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': Producto.fromJson(data)
        };
      } else if (response.statusCode == 404) {
        return {'success': false, 'message': data['mensaje'] ?? 'No hay producto'};
      } else {
        return {'success': false, 'message': 'Error en el servidor'};
      }
    } catch (e) {
      print('Error en getPlatoById: $e');
      return {'success': false, 'message': 'Error de conexión HTTP'};
    }
  }

  Future<Map<String, dynamic>> eliminarProducto(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/producto?id=$id'),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {'success': true, 'message': data['message'] ?? 'Producto eliminado'};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Error al eliminar'};
      }
    } catch (e) {
      print('Error en eliminarProducto: $e');
      return {'success': false, 'message': 'Error de conexión HTTP'};
    }
  }
}