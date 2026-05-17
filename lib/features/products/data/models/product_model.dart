import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.idProducto,
    required super.nombre,
    required super.activo,
    super.descripcion,
    super.imagen,
    required super.yoloLabel,
    required super.stock,
    required super.precio,
    required super.idCategoria,
    super.categoria,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      idProducto: json['idProducto'] ?? 0,
      nombre: json['nombre'] ?? '',
      activo: json['activo'] ?? false,
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      yoloLabel: json['yoloLabel'] ?? '',
      stock: json['stock'] ?? 0,
      precio: (json['precio'] ?? 0).toDouble(), 
      idCategoria: json['idCategoria'] ?? 0,
      categoria: json['categoria'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProducto': idProducto,
      'nombre': nombre,
      'activo': activo,
      'descripcion': descripcion,
      'imagen': imagen,
      'yoloLabel': yoloLabel,
      'stock': stock,
      'precio': precio,
      'idCategoria': idCategoria,
      'categoria': categoria,
    };
  }
}
