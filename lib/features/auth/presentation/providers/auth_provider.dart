import 'package:flutter/material.dart';
import '../../../../core/states/view_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
  });

  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  User? _user;
  User? get user => _user;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String correo, String password) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await loginUseCase(correo, password);
      _user = user;
      _state = ViewState.success;
      notifyListeners();
      return true;
    } catch (e) {
      _state = ViewState.error;
      // Limpiamos el texto de la excepción para mostrar un mensaje amigable
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> registrarCliente(String nombre, String dni, String correo, String password, String telefono) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await registerUseCase(nombre, dni, correo, password, telefono);
      _state = ViewState.success;
      notifyListeners();
      return result;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
