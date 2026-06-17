import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:listo_app/features/client/data/models/metodo_pago_model.dart';
import 'package:listo_app/core/env/environment.dart';


class MetodoPagoService {
  final String _baseUrl = '${Environment.apiUrl}/metodoPago';

  // 1. GET: api/metodoPago/lista
  Future<List<MetodoPagoModel>> getLista([String search = '']) async {
    final uri = Uri.parse('$_baseUrl/lista').replace(
      queryParameters: {'pSearch': search},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((item) => MetodoPagoModel.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar la lista: ${response.statusCode}');
    }
  }

  // 2. GET: api/metodoPago/{pId}
  // Retorna el modelo o null si no se encuentra
  Future<MetodoPagoModel?> getMetodoByUsuario(int pId) async {
    final uri = Uri.parse('$_baseUrl/$pId');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      return MetodoPagoModel.fromJson(jsonResponse);
    } 
    // Tu controlador .NET devuelve 404 (NotFound) si es nulo
    else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Error del servidor: ${response.statusCode}');
    }
  }

  // 3. POST: api/metodoPago
  // Ahora recibe directamente el objeto fuertemente tipado
  Future<bool> saveItem(MetodoPagoModel metodoPago) async {
    final uri = Uri.parse(_baseUrl);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(metodoPago.toJson()), // Usamos el método toJson que creamos
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Error al guardar el método de pago');
    }
  }

  // 4. DELETE: api/metodoPago/{idUsuario}
  Future<bool> deleteItem(int idUsuario) async {
    final uri = Uri.parse('$_baseUrl/$idUsuario');
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return true;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Error al eliminar el método de pago');
    }
  }
}