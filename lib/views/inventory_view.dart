import 'package:flutter/material.dart';
import '../models/producto_model.dart';
import '../models/categoria_model.dart';
import '../services/product_service.dart';
import '../services/categoria_service.dart';


class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  final ProductService _productService = ProductService();
  final CategoriaService _categoriaService = CategoriaService();
  
  List<Producto> _productos = [];
  bool _isLoading = true;
  
  int _currentPage = 1;
  int _pageSize = 10;
  String _searchQuery = "";
  int _totalPages = 1;
  int _totalCount = 0;

  int _selectedCategoriaId = 0;
  List<Categoria> _categoriasFiltro = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos(); 
  }

  Future<void> _cargarCategoriasFiltro() async {
    final res = await _categoriaService.getLista();
    if (res['success']) {
      setState(() {
  
        _categoriasFiltro = [Categoria(idCategoria: 0, nombre: "Todas las categorías", activo: true)];
        _categoriasFiltro.addAll(List<Categoria>.from(res['data']));
      });
    }
  }

  // Método para consumir el API
  Future<void> _cargarProductos() async {
    setState(() {
      _isLoading = true;
    });

    final response = await _productService.getProductosLista(
      pageNumber: _currentPage,
      pageSize: _pageSize,
      pSearch: _searchQuery,
      idCategoria: _selectedCategoriaId // Consumiendo el filtro de categoría
    );

    if (response['success']) {
      setState(() {
        _productos = response['data'];
        _totalPages = response['totalPages'] ?? 1; 
        _totalCount = response['totalCount'] ?? 0;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }
    }
  }

  void _onSearch(String value) {
    setState(() {
      _searchQuery = value;
      _currentPage = 1; 
    });
    _cargarProductos();
  }

  void _confirmarEliminarProducto(Producto p) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Eliminar Producto"),
        content: Text("¿Estás seguro que deseas eliminar '${p.nombre}'? Esta acción no se puede deshacer."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text("Cancelar")
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx); // Cierra el modal
              
              // Llama al servicio que ya tenías creado
              final res = await _productService.eliminarProducto(p.idProducto);
              
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(res['message']),
                    backgroundColor: res['success'] ? Colors.green : Colors.red,
                  ),
                );
              }
              
              if (res['success']) {
                _cargarProductos(); // Refresca la tabla
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // 1. Cabecera (Botón Nuevo Producto)
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
          
          // --- 3. Buscador y Filtro por Categoría ---
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
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
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
                        _currentPage = 1; // Reiniciamos la página al filtrar
                      });
                      _cargarProductos();
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 3. Lista de Productos o Indicador de Carga
          Expanded( // El Expanded hace que la lista tome todo el espacio disponible
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _productos.isEmpty
                  ? const Center(child: Text("No se encontraron productos."))
                  : ListView.separated(
                      itemCount: _productos.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final Producto p = _productos[index];
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
                                        fontWeight: bajoStock
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _mostrarFormulario(context, productoEditar: p),
                                ),
                               IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _confirmarEliminarProducto(p), // Vinculado a la función de eliminar
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
              // Total de registros
              Text(
                "Total: $_totalCount registros",
                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
              
              // Selector de tamaño de página
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
                          _currentPage = 1; // Reiniciamos a la primera página si cambia el tamaño
                        });
                        _cargarProductos();
                      }
                    },
                  ),
                ],
              ),

              // Botones y estado de la página actual
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
                    "Página $_currentPage de $_totalPages",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),

                  ElevatedButton(
                    onPressed: _currentPage < _totalPages
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

 void _mostrarFormulario(BuildContext context, {Producto? productoEditar}) {
  final _formKey = GlobalKey<FormState>();
  
  // 1. Inicializamos los controladores con los datos del producto (si existe)
  final _nombreCtrl = TextEditingController(text: productoEditar?.nombre ?? '');
  final _descripcionCtrl = TextEditingController(text: productoEditar?.descripcion ?? '');
  final _imagenCtrl = TextEditingController(text: productoEditar?.imagen ?? '');
  final _yoloLabelCtrl = TextEditingController(text: productoEditar?.yoloLabel ?? '');
  final _precioCtrl = TextEditingController(text: productoEditar?.precio.toString() ?? '');
  final _stockCtrl = TextEditingController(text: productoEditar?.stock.toString() ?? '');

  final CategoriaService _catService = CategoriaService();

  List<Categoria> _categorias = [];
  Categoria? _categoriaSeleccionada;
  bool _isLoadingCategorias = true;
  bool _isSaving = false;
  
  // Mantenemos el estado activo del producto si estamos editando
  bool _activo = productoEditar?.activo ?? true; 

  // Variables para diferenciar UI entre Crear y Editar
  final bool isEditing = productoEditar != null;
  final String tituloModal = isEditing ? "Editar Producto" : "Nuevo Producto";
  final String textoBoton = isEditing ? "Actualizar Producto" : "Guardar Producto";

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setStateDialog) {
        
        // Función interna para cargar categorías
        void _cargarCategoriasInside() async {
          final res = await _catService.getLista();
          if (res['success']) {
            setStateDialog(() {
              _categorias = res['data'];
              _isLoadingCategorias = false;

              // 2. Si estamos editando, auto-seleccionamos la categoría del producto
              if (isEditing) {
                try {
                  // Buscamos la instancia exacta de la categoría en la lista descargada
                  // para que el DropdownButton no lance un error de referencia
                  _categoriaSeleccionada = _categorias.firstWhere(
                    (c) => c.idCategoria == productoEditar.idCategoria
                  );
                } catch (e) {
                  _categoriaSeleccionada = null; // Por si la categoría fue eliminada
                }
              }
            });
          }
        }

        // Cargar por primera vez si la lista está vacía
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
                    
                    // --- SECCIÓN CATEGORÍAS ---
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: _isLoadingCategorias
                              ? const LinearProgressIndicator()
                              : DropdownButtonFormField<Categoria>(
                                  value: _categoriaSeleccionada,
                                  decoration: const InputDecoration(labelText: "Categoría"),
                                  items: _categorias.map((cat) {
                                    return DropdownMenuItem(
                                      value: cat,
                                      child: Text(cat.nombre),
                                    );
                                  }).toList(),
                                  onChanged: (val) => setStateDialog(() => _categoriaSeleccionada = val),
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
                          tooltip: "Eliminar Categoría seleccionada",
                          onPressed: _categoriaSeleccionada == null 
                            ? null 
                            : () => _confirmarEliminarCategoria(context, _categoriaSeleccionada!, () {
                                setStateDialog(() {
                                  _categoriaSeleccionada = null;
                                  _isLoadingCategorias = true;
                                });
                                _cargarCategoriasInside();
                              }),
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
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5A1F), foregroundColor: Colors.white),
              onPressed: _isSaving ? null : () async {
                if (_formKey.currentState!.validate()) {
                  setStateDialog(() => _isSaving = true);
                  
                  // 3. Armamos el objeto Producto. Si es edición, usamos el ID existente; sino, 0.
                  final p = Producto(
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

                  // 4. Decidimos qué endpoint de la API consumir
                  final res = isEditing 
                      ? await _productService.actualizarProducto(p)
                      : await _productService.guardarProducto(p);

                  // 5. Mostramos SnackBar con el resultado
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(res['message']),
                        backgroundColor: res['success'] ? Colors.green : Colors.red,
                      ),
                    );
                  }

                  if (res['success']) {
                    if (context.mounted) Navigator.pop(context);
                    _cargarProductos(); // Refresca la tabla
                  } else {
                    setStateDialog(() => _isSaving = false);
                  }
                }
              },
              child: _isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Text(textoBoton),
            )
          ],
        );
      },
    ),
  );
}

void _nuevaCategoriaDialog(BuildContext context, VoidCallback onCreated) {
  final _catCtrl = TextEditingController();
  final _catService = CategoriaService();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Nueva Categoría"),
      content: TextField(controller: _catCtrl, decoration: const InputDecoration(labelText: "Nombre")),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar")),
        ElevatedButton(
          onPressed: () async {
            if (_catCtrl.text.isNotEmpty) {
              final res = await _catService.saveCategoria(
                Categoria(idCategoria: 0, nombre: _catCtrl.text, activo: true)
              );
              if (res['success'] && context.mounted) {
                Navigator.pop(context);
                onCreated();
              }
            }
          }, 
          child: const Text("Añadir")
        )
      ],
    ),
  );
}

void _confirmarEliminarCategoria(BuildContext context, Categoria cat, VoidCallback onDeleted) {
  final _catService = CategoriaService();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("¿Eliminar Categoría?"),
      content: Text("Se eliminará '${cat.nombre}'. Esto podría afectar a productos asociados."),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        TextButton(
          onPressed: () async {
            final res = await _catService.deleteCategoria(cat.idCategoria);
            if (res['success'] && context.mounted) {
              Navigator.pop(context);
              onDeleted();
            }
          }, 
          child: const Text("Eliminar", style: TextStyle(color: Colors.red))
        )
      ],
    ),
  );
}
}