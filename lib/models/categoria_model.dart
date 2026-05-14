class Categoria {
  int idCategoria;
  String nombre;
  bool activo;

  Categoria({
    required this.idCategoria,
    required this.nombre,
    required this.activo,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
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