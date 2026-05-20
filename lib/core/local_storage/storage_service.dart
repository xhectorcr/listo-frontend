import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  
  static const String _idKey = 'auth_id'; // <-- 1. Nueva llave para el ID
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  static const String _roleKey = 'auth_role';

  // 2. Agregamos el parámetro 'id' al método
  Future<void> saveAuthData(String id, String token, String userName, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_idKey, id); // <-- Lo guardamos
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, userName);
    await prefs.setString(_roleKey, role);
  }

  // 3. Nuevo método para recuperar el ID cuando lo necesites
  Future<String?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_idKey);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }


  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_idKey); // <-- Lo borramos al salir
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_roleKey);
  }
}