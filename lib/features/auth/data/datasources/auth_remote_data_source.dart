import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/env/environment.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String correo, String password);
  Future<bool> registrarCliente(String nombre, String dni, String correo, String password, String telefono);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final String _baseUrl = Environment.apiUrl;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String correo, String password) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/usuario/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'correo': correo, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return UserModel.fromJson(data['data']);
    } else {
      throw Exception(data['message'] ?? 'Error desconocido al iniciar sesión');
    }
  }

  @override
  Future<bool> registrarCliente(String nombre, String dni, String correo, String password, String telefono) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/usuario/registrarCliente'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'dni': dni,
        'correo': correo,
        'password': password,
        'telefono': telefono,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return true;
    } else {
      throw Exception(data['message'] ?? 'Error al registrar cliente');
    }
  }
}
