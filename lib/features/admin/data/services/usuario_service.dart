import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/env/environment.dart';

class UsuarioService {
  static const String baseUrl =
      '${Environment.apiUrl}/usuario/lista/activos?pageNumber=1&pageSize=50';

  Future<List<dynamic>> obtenerUsuarios() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        return decodedData['data'] ?? [];
      }
      return [];
    } catch (e) {
      print('Error de conexión: $e');
      return [];
    }
  }
}
