// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_trabajo/Models/producto.dart';

import '../Services/firebase_service.dart';
import 'home.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({Key? key}) : super(key: key);

  @override
  ProductosPageState createState() => ProductosPageState();
}

class ProductosPageState extends State<ProductosPage> {
  late List<Producto> productos;

  @override
  void initState() {
    super.initState();
    productos = [];

    // Llama a la función para cargar los productos
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    // Llama a la función para obtener los productos utilizando la clase ProductoDAO
    final productoDAO = ProductoDAO();
    final productos = await productoDAO.getProductos();

    setState(() {
      this.productos = productos;
    });
  }

  // Función para mostrar un Dialog con los detalles del producto
  void _mostrarDetallesProducto(Producto producto) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detalles del Producto'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nombre: ${producto.nombre}'),
              Text('Precio: \$${producto.precio.toStringAsFixed(2)}'),
              Text('Categoría: ${producto.categoria}'),
              Text('Descripción: ${producto.descripcion}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarProducto(Producto producto) async {
    final productoDAO = ProductoDAO();
    await productoDAO.eliminarProducto(producto.id);

    // Cierra el Dialog
    Navigator.of(context).pop();

    // Recarga la página
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ProductosPage(),
      ),
    );
  }


  void _mostrarEliminarProductoDialog(Producto producto) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Producto'),
          content: Text('¿Estás seguro de que deseas eliminar el producto "${producto.nombre}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _eliminarProducto(producto); // Llama a la función para eliminar el producto
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarRegistrarProductoDialog() {
    TextEditingController nombreController = TextEditingController();
    TextEditingController precioController = TextEditingController();
    TextEditingController categoriaController = TextEditingController();
    TextEditingController descripcionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar Producto'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextFormField(
                  controller: precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                ),
                TextFormField(
                  controller: categoriaController,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Obtén los datos del nuevo producto
                final nuevoNombre = nombreController.text;
                final nuevoPrecio = double.parse(precioController.text);
                final nuevaCategoria = categoriaController.text;
                final nuevaDescripcion = descripcionController.text;

                // Registra el nuevo producto en la base de datos
                final productoDAO = ProductoDAO();
                await productoDAO.agregarProducto(Producto(
                  id: "None",
                  nombre: nuevoNombre,
                  precio: nuevoPrecio,
                  categoria: nuevaCategoria,
                  descripcion: nuevaDescripcion,
                ));

                // Cierra el Dialog
                Navigator.of(context).pop();

                // Recarga la página
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductosPage(),
                  ),
                );
              },
              child: const Text('Registrar'),
            ),
          ],
        );
      },
    );
  }







  void _mostrarModificarProductoDialog(Producto producto) {
    TextEditingController nombreController = TextEditingController(text: producto.nombre);
    TextEditingController precioController = TextEditingController(text: producto.precio.toString());
    TextEditingController categoriaController = TextEditingController(text: producto.categoria);
    TextEditingController descripcionController = TextEditingController(text: producto.descripcion);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modificar Producto'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextFormField(
                  controller: precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                ),
                TextFormField(
                  controller: categoriaController,
                  decoration: const InputDecoration(labelText: 'Categoría'),
                ),
                TextFormField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                // Obtén los datos modificados
                final nuevoNombre = nombreController.text;
                final nuevoPrecio = double.parse(precioController.text);
                final nuevaCategoria = categoriaController.text;
                final nuevaDescripcion = descripcionController.text;

                // Actualiza el producto en la base de datos
                final productoDAO = ProductoDAO();
                await productoDAO.modificarProducto(producto.id, Producto(
                  id: producto.id,
                  nombre: nuevoNombre,
                  precio: nuevoPrecio,
                  categoria: nuevaCategoria,
                  descripcion: nuevaDescripcion,
                ));

                // Cierra el Dialog
                Navigator.of(context).pop();

                // Recarga la página
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductosPage(),
                  ),
                );
              },
              child: const Text('Guardar cambios'),
            ),
          ],
        );
      },
    );
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Productos',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Precio')),
                DataColumn(label: Text('Categoría')),
                DataColumn(label: Text('Descripción')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: productos
                  .map(
                    (producto) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(producto.nombre)),
                    DataCell(Text(producto.precio.toString())),
                    DataCell(Text(producto.categoria)),
                    DataCell(Text(producto.descripcion)),
                    DataCell(
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              _mostrarDetallesProducto(producto); // Muestra los detalles del producto
                            },
                            child: const Text('Ver producto'),
                          ),
                          TextButton(
                            onPressed: () {
                              _mostrarModificarProductoDialog(producto);
                            },
                            child: const Text('Editar producto'),
                          ),
                          TextButton(
                            onPressed: () {
                              _mostrarEliminarProductoDialog(producto);
                            },
                            child: const Text('Eliminar producto'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
                  .toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarRegistrarProductoDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }



}
