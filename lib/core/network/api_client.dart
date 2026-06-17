import 'dart:convert';
import 'package:http/http.dart' as http;
import '../env/environment.dart';

class ApiClient {
  final http.Client _client;
  final String _baseUrl;

  ApiClient({http.Client? client, String? baseUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl ?? Environment.apiUrl;

  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // Aquí se pueden agregar tokens de autenticación en el futuro
      // 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? queryParameters}) async {
    final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: queryParameters);
    try {
      final response = await _client.get(uri, headers: _getHeaders());
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error en petición GET: $e');
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await _client.post(
        uri,
        headers: _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error en petición POST: $e');
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    try {
      final response = await _client.put(
        uri,
        headers: _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      );
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error en petición PUT: $e');
    }
  }

  Future<dynamic> delete(String endpoint, {Map<String, String>? queryParameters}) async {
    final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: queryParameters);
    try {
      final response = await _client.delete(uri, headers: _getHeaders());
      return _processResponse(response);
    } catch (e) {
      throw Exception('Error en petición DELETE: $e');
    }
  }

  dynamic _processResponse(http.Response response) {
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      // Manejar el formato de error específico del backend si existe
      final message = body is Map && body.containsKey('message') 
          ? body['message'] 
          : 'Error del servidor: ${response.statusCode}';
      throw Exception(message);
    }
  }
}
