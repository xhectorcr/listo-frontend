class Product {
  final int idProducto;
  final String nombre;
  final bool activo;
  final String? descripcion;
  final String? imagen;
  final String yoloLabel;
  final int stock;
  final double precio;
  final int idCategoria;
  final String? categoria;

  Product({
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
}
