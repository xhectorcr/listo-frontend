import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.usuario,
    required super.rol,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      usuario: json['usuario'] ?? '',
      rol: json['rol'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario,
      'rol': rol,
      'token': token,
    };
  }
}
