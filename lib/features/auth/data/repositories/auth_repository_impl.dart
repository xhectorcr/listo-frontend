import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String correo, String password) async {
    try {
      // El DataSource devuelve un UserModel, que hereda de User.
      return await remoteDataSource.login(correo, password);
    } catch (e) {
      // Aquí se podrían mapear excepciones HTTP a excepciones de dominio si se desea.
      rethrow;
    }
  }

  @override
  Future<bool> registrarCliente(String nombre, String dni, String correo, String password, String telefono) async {
    try {
      return await remoteDataSource.registrarCliente(nombre, dni, correo, password, telefono);
    } catch (e) {
      rethrow;
    }
  }
}
