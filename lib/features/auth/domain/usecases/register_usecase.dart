import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<bool> call(String nombre, String correo, String password, String telefono) async {
    if (nombre.isEmpty || correo.isEmpty || password.isEmpty) {
      throw Exception('Completa todos los campos obligatorios');
    }
    
    return await repository.registrarCliente(nombre, correo, password, telefono);
  }
}
