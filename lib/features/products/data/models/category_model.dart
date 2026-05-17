import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.idCategoria,
    required super.nombre,
    required super.activo,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      idCategoria: json['idCategoria'] ?? 0,
      nombre: json['nombre'] ?? '',
      activo: json['activo'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idCategoria': idCategoria,
      'nombre': nombre,
      'activo': activo,
    };
  }
}
