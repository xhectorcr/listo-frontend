
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

<<<<<<< HEAD
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
=======

  Future<Map<String, dynamic>> registrarCliente(String nombre, String correo, String password, String telefono) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/usuario/registrarCliente'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'correo': correo,
          'password': password,
          'telefono': telefono,
>>>>>>> hector
        }),
      );

      final data = jsonDecode(response.body);
<<<<<<< HEAD

=======
      
>>>>>>> hector
      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
<<<<<<< HEAD
          'message': data['message'] ?? 'Error desconocido al registrar usuario'
        };
      }
    } catch (e) {
      print('Error de conexión HTTP al registrar: $e');
=======
          'message': data['message'] ?? 'Error desconocido al intentar registrar el cliente'
        };
      }
    } catch (e) {
      print('Error de conexión HTTP en registrarCliente: $e');
>>>>>>> hector
      return {
        'success': false,
        'message': 'Error de conexión. Verifica que el servidor esté encendido.'
      };
    }
  }
}