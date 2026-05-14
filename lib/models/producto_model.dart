class Producto {
  int idProducto;
  String nombre;
  bool activo;
  String? descripcion;
  String? imagen;
  String yoloLabel;
  int stock;
  double precio;
  int idCategoria;
  String? categoria;

  Producto({
    required this.idProducto,
    required this.nombre,
    required this.activo,
    this.descripcion,
    this.imagen,
    required this.yoloLabel,
    required this.stock,
    required this.precio,
    required this.idCategoria,
    this.categoria,
  });


  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
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

  // De Objeto Dart a JSON (Para enviar al Backend)
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