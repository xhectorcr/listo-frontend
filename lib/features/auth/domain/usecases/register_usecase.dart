import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<bool> call(String nombre, String dni, String correo, String password, String telefono) async {
    if (nombre.isEmpty || dni.isEmpty || correo.isEmpty || password.isEmpty) {
      throw Exception('Completa todos los campos obligatorios');
    }
    
    return await repository.registrarCliente(nombre, dni, correo, password, telefono);
  }
}
