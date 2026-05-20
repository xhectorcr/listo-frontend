import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id, // <-- 1. Agregamos el id al constructor
    required super.usuario,
    required super.rol,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // 2. Lo extraemos del JSON. 
      // OJO: Asegúrate de que tu C# lo devuelva como "idUsuario" o "id", 
      // y pon el nombre exacto aquí abajo.
      id: json['idUsuario']?.toString() ?? '', 
      usuario: json['usuario'] ?? '',
      rol: json['rol'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUsuario': id, // <-- 3. Lo agregamos al toJson
      'usuario': usuario,
      'rol': rol,
      'token': token,
    };
  }
}