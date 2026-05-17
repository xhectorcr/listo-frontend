import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String correo, String password);
  Future<bool> registrarCliente(String nombre, String correo, String password, String telefono);
}
