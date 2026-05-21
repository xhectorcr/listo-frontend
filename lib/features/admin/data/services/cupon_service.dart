import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/env/environment.dart';

class CuponService {
  final String _baseUrl = '${Environment.apiUrl}/Descuento/enviar-cupon';

  Future<Map<String, dynamic>> enviarCupon(String email) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(email),
      );

      final decoded = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': decoded['mensaje'] ?? 'Cupón enviado con éxito.',
        };
      } else {
        return {
          'success': false,
          'message': decoded['error'] ?? 'Error al enviar el cupón.',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }
}
