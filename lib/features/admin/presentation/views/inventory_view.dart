import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/entities/category.dart';
import '../../../products/presentation/providers/product_provider.dart';
import '../../../products/presentation/providers/category_provider.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  int _currentPage = 1;
  int _pageSize = 10;
  String _searchQuery = "";
  int _selectedCategoriaId = 0;
  List<Category> _categoriasFiltro = [];
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _cargarCategoriasFiltro();
      _cargarProductos();
      _isInit = false;
    }
  }

  Future<void> _cargarCategoriasFiltro() async {
    final catProvider = context.read<CategoryProvider>();
    await catProvider.fetchCategories();
    if (mounted && catProvider.errorMessage == null) {
      setState(() {
        _categoriasFiltro = [
          Category(
            idCategoria: 0,
            nombre: "Todas las categorías",
            activo: true,
          ),
        ];
        _categoriasFiltro.addAll(catProvider.categories);
      });
    }
  }

  Future<void> _cargarProductos() async {
    await context.read<ProductProvider>().fetchProducts(
      pageNumber: _currentPage,
      pageSize: _pageSize,
      search: _searchQuery,
      categoryId: _selectedCategoriaId,
    );
  }

  void _onSearch(String value) {
    setState(() {
      _searchQuery = value;
      _currentPage = 1;
    });
    _cargarProductos();
  }

  void _confirmarEliminarProduct(Product p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Eliminar Producto"),
        content: Text(
          "¿Estás seguro que deseas eliminar '${p.nombre}'? Esta acción no se puede deshacer.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await context.read<ProductProvider>().deleteProduct(p.idProducto);

              if (mounted) {
                final errMsg = context.read<ProductProvider>().errorMessage;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? "Producto eliminado" : (errMsg ?? "Error al eliminar")),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }

              if (success) {
                _cargarProductos();
              }
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final productos = productProvider.products;
    final totalCount = productProvider.totalCount;
    final totalPages = productProvider.totalPages;
    final isLoading = productProvider.isLoading;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Gestión de Inventario",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _mostrarFormulario(context),
                icon: const Icon(Icons.add),
                label: const Text("Nuevo Producto"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5A1F),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  onSubmitted: _onSearch,
                  decoration: InputDecoration(
                    hintText: 'Buscar producto...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<int>(
                  value: _selectedCategoriaId,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                  ),
                  items: _categoriasFiltro.map((cat) {
                    return DropdownMenuItem(
                      value: cat.idCategoria,
                      child: Text(cat.nombre),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCategoriaId = val;
                        _currentPage = 1;
                      });
                      _cargarProductos();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : productos.isEmpty
                      ? const Center(child: Text("No se encontraron productos."))
                      : ListView.separated(
                          itemCount: productos.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final Product p = productos[index];
                            bool bajoStock = p.stock <= 5;

                            return ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.fastfood,
                                  color: Color(0xFFFF5A1F),
                                ),
                              ),
                              title: Text(
                                p.nombre,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "Etiqueta YOLO: ${p.yoloLabel} | Categoría: ${p.categoria ?? 'Sin asignar'}",
                              ),
                              trailing: SizedBox(
                                width: 300,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "S/ ${p.precio.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "Stock: ${p.stock}",
                                          style: TextStyle(
                                            color: bajoStock ? Colors.red : Colors.grey,
                                            fontWeight: bajoStock ? FontWeight.bold : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () => _mostrarFormulario(
                                        context,
                                        productoEditar: p,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _confirmarEliminarProduct(p),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: $totalCount registros",
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text("Mostrar: "),
                  DropdownButton<int>(
                    value: _pageSize,
                    items: [5, 10, 20, 50].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _pageSize = newValue;
                          _currentPage = 1;
                        });
                        _cargarProductos();
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _currentPage > 1
                        ? () {
                            setState(() => _currentPage--);
                            _cargarProductos();
                          }
                        : null,
                    child: const Icon(Icons.chevron_left),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "Página $_currentPage de $totalPages",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _currentPage < totalPages
                        ? () {
                            setState(() => _currentPage++);
                            _cargarProductos();
                          }
                        : null,
                    child: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _mostrarFormulario(BuildContext context, {Product? productoEditar}) {
    final _formKey = GlobalKey<FormState>();

    final _nombreCtrl = TextEditingController(text: productoEditar?.nombre ?? '');
    final _descripcionCtrl = TextEditingController(text: productoEditar?.descripcion ?? '');
    final _imagenCtrl = TextEditingController(text: productoEditar?.imagen ?? '');
    final _yoloLabelCtrl = TextEditingController(text: productoEditar?.yoloLabel ?? '');
    final _precioCtrl = TextEditingController(text: productoEditar?.precio.toString() ?? '');
    final _stockCtrl = TextEditingController(text: productoEditar?.stock.toString() ?? '');

    List<Category> _categorias = [];
    Category? _categoriaSeleccionada;
    bool _isLoadingCategorias = true;
    bool _isSaving = false;
    bool _activo = productoEditar?.activo ?? true;

    final bool isEditing = productoEditar != null;
    final String tituloModal = isEditing ? "Editar Producto" : "Nuevo Producto";
    final String textoBoton = isEditing ? "Actualizar Producto" : "Guardar Producto";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          void _cargarCategoriasInside() async {
            final catProvider = context.read<CategoryProvider>();
            await catProvider.fetchCategories();
            if (mounted && catProvider.errorMessage == null) {
              setStateDialog(() {
                _categorias = catProvider.categories;
                _isLoadingCategorias = false;

                if (isEditing) {
                  try {
                    _categoriaSeleccionada = _categorias.firstWhere(
                      (c) => c.idCategoria == productoEditar.idCategoria,
                    );
                  } catch (e) {
                    _categoriaSeleccionada = null;
                  }
                }
              });
            }
          }

          if (_isLoadingCategorias) _cargarCategoriasInside();

          return AlertDialog(
            title: Text(tituloModal),
            content: SizedBox(
              width: 500,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nombreCtrl,
                        decoration: const InputDecoration(labelText: "Nombre del Producto"),
                        validator: (v) => v!.isEmpty ? "Campo requerido" : null,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _descripcionCtrl,
                        decoration: const InputDecoration(labelText: "Descripción (Opcional)"),
                        maxLines: 3,
                        minLines: 1,
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _imagenCtrl,
                        decoration: const InputDecoration(
                          labelText: "URL de la Imagen (Opcional)",
                          prefixIcon: Icon(Icons.image),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: _isLoadingCategorias
                                ? const LinearProgressIndicator()
                                : DropdownButtonFormField<Category>(
                                    value: _categoriaSeleccionada,
                                    decoration: const InputDecoration(labelText: "Categoría"),
                                    items: _categorias.map((cat) {
                                      return DropdownMenuItem<Category>(
                                        value: cat,
                                        child: Text(cat.nombre),
                                      );
                                    }).toList(),
                                    onChanged: (val) => setStateDialog(
                                      () => _categoriaSeleccionada = val,
                                    ),
                                    validator: (v) => v == null ? "Selecciona una categoría" : null,
                                  ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle, color: Colors.green),
                            tooltip: "Nueva Categoría",
                            onPressed: () => _nuevaCategoriaDialog(context, () {
                              setStateDialog(() => _isLoadingCategorias = true);
                              _cargarCategoriasInside();
                            }),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: "Eliminar Categoría",
                            onPressed: _categoriaSeleccionada == null
                                ? null
                                : () => _confirmarEliminarCategory(
                                      context,
                                      _categoriaSeleccionada!,
                                      () {
                                        setStateDialog(() {
                                          _categoriaSeleccionada = null;
                                          _isLoadingCategorias = true;
                                        });
                                        _cargarCategoriasInside();
                                      },
                                    ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: _yoloLabelCtrl,
                        decoration: const InputDecoration(labelText: "Etiqueta YOLO (Única)"),
                        validator: (v) => v!.isEmpty ? "Campo requerido" : null,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _precioCtrl,
                              decoration: const InputDecoration(labelText: "Precio (S/.)"),
                              keyboardType: TextInputType.number,
                              validator: (v) => v!.isEmpty ? "Requerido" : null,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextFormField(
                              controller: _stockCtrl,
                              decoration: const InputDecoration(labelText: "Stock"),
                              keyboardType: TextInputType.number,
                              validator: (v) => v!.isEmpty ? "Requerido" : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5A1F),
                  foregroundColor: Colors.white,
                ),
                onPressed: _isSaving
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setStateDialog(() => _isSaving = true);

                          final p = Product(
                            idProducto: isEditing ? productoEditar.idProducto : 0,
                            nombre: _nombreCtrl.text,
                            activo: _activo,
                            yoloLabel: _yoloLabelCtrl.text,
                            precio: double.parse(_precioCtrl.text),
                            stock: int.parse(_stockCtrl.text),
                            idCategoria: _categoriaSeleccionada!.idCategoria,
                            descripcion: _descripcionCtrl.text,
                            imagen: _imagenCtrl.text.isEmpty ? null : _imagenCtrl.text,
                          );

                          final prodProvider = context.read<ProductProvider>();
                          final success = isEditing
                              ? await prodProvider.updateProduct(p)
                              : await prodProvider.saveProduct(p);

                          if (context.mounted) {
                            final errMsg = prodProvider.errorMessage;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(success ? "Operación exitosa" : (errMsg ?? "Error")),
                                backgroundColor: success ? Colors.green : Colors.red,
                              ),
                            );
                          }

                          if (success) {
                            if (context.mounted) Navigator.pop(context);
                            _cargarProductos();
                          } else {
                            setStateDialog(() => _isSaving = false);
                          }
                        }
                      },
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(textoBoton),
              ),
            ],
          );
        },
      ),
    );
  }

  void _nuevaCategoriaDialog(BuildContext context, VoidCallback onCreated) {
    final _catCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nueva Categoría"),
        content: TextField(
          controller: _catCtrl,
          decoration: const InputDecoration(labelText: "Nombre"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cerrar"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_catCtrl.text.isNotEmpty) {
                final success = await context.read<CategoryProvider>().saveCategory(
                      Category(
                        idCategoria: 0,
                        nombre: _catCtrl.text,
                        activo: true,
                      ),
                    );
                if (success && context.mounted) {
                  Navigator.pop(context);
                  onCreated();
                }
              }
            },
            child: const Text("Añadir"),
          ),
        ],
      ),
    );
  }

  void _confirmarEliminarCategory(
    BuildContext context,
    Category cat,
    VoidCallback onDeleted,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Eliminar Categoría?"),
        content: Text(
          "Se eliminará '${cat.nombre}'. Esto podría afectar a productos asociados.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              final success = await context.read<CategoryProvider>().deleteCategory(cat.idCategoria);
              if (success && context.mounted) {
                Navigator.pop(context);
                onDeleted();
              }
            },
            child: const Text("Eliminar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
