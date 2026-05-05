
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/environment.dart'; 

class AuthService {
  final String _baseUrl = Environment.apiUrl; 


  Future<Map<String, dynamic>> login(String correo, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/usuario/login'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'correo': correo, 
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'],
          'token': data['data']['token'],
          'rol': data['data']['rol'],
          'usuario': data['data']['usuario'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error desconocido en el servidor'
        };
      }
    } catch (e) {
      print('Error de conexión HTTP: $e');
      return {
        'success': false,
        'message': 'Error de conexión. Verifica que el servidor esté encendido.'
      };
    }
  }

  Future<Map<String, dynamic>> registrar(String nombre, String correo, String telefono, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/usuario/registrar'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'correo': correo, 
          'telefono': telefono,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error desconocido al registrar usuario'
        };
      }
    } catch (e) {
      print('Error de conexión HTTP al registrar: $e');
      return {
        'success': false,
        'message': 'Error de conexión. Verifica que el servidor esté encendido.'
      };
    }
  }
}