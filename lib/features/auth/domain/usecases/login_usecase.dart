import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String correo, String password) async {
    // Aquí puedes agregar validaciones de negocio antes de llamar al repositorio.
    // Por ejemplo, verificar que el correo no esté vacío.
    if (correo.isEmpty || password.isEmpty) {
      throw Exception('El correo y la contraseña son obligatorios');
    }

    return await repository.login(correo, password);
  }
}
