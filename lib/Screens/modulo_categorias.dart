import 'package:flutter/material.dart';
import 'package:flutter_trabajo/Models/categorias.dart';
import 'package:flutter_trabajo/Services/firebase_service.dart';

import 'home.dart';

class CategoriasPage extends StatefulWidget {
  const CategoriasPage({Key? key}) : super(key: key);

  @override
  _CategoriasPageState createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  late List<Categoria> categorias;

  @override
  void initState() {
    super.initState();
    categorias = [];

    // Llama a la función para cargar las categorías
    _cargarCategorias();
  }

  Future<void> _cargarCategorias() async {
    // Llama a la función para obtener las categorías utilizando la clase CategoriaDAO
    final categoriaDAO = CategoriaDAO();
    final categorias = await categoriaDAO.getCategorias();

    setState(() {
      this.categorias = categorias;
    });
  }

  // Función para mostrar un Dialog con los detalles de la categoría
  void _mostrarDetallesCategoria(Categoria categoria) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detalles de la Categoría'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nombre: ${categoria.nombre}'),
              Text('Descripción: ${categoria.descripcion}'),
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

  void _eliminarCategoria(Categoria categoria) async {
    final categoriaDAO = CategoriaDAO();
    await categoriaDAO.eliminarCategoria(categoria.id);

    // Cierra el Dialog
    Navigator.of(context).pop();

    // Recarga la página
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const CategoriasPage(),
      ),
    );
  }

  void _mostrarEliminarCategoriaDialog(Categoria categoria) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Categoría'),
          content: Text('¿Estás seguro de que deseas eliminar la categoría "${categoria.nombre}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _eliminarCategoria(categoria); // Llama a la función para eliminar la categoría
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarRegistrarCategoriaDialog() {
    TextEditingController nombreController = TextEditingController();
    TextEditingController descripcionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar Categoría'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
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
                // Obtén los datos de la nueva categoría
                final nuevoNombre = nombreController.text;
                final nuevaDescripcion = descripcionController.text;

                // Registra la nueva categoría en la base de datos
                final categoriaDAO = CategoriaDAO();
                await categoriaDAO.agregarCategoria(Categoria(
                  id: "None",
                  nombre: nuevoNombre,
                  descripcion: nuevaDescripcion,
                ));

                // Cierra el Dialog
                Navigator.of(context).pop();

                // Recarga la página
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriasPage(),
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

  void _mostrarModificarCategoriaDialog(Categoria categoria) {
    TextEditingController nombreController = TextEditingController(text: categoria.nombre);
    TextEditingController descripcionController = TextEditingController(text: categoria.descripcion);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modificar Categoría'),
          content: Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
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
                final nuevaDescripcion = descripcionController.text;

                // Actualiza la categoría en la base de datos
                final categoriaDAO = CategoriaDAO();
                await categoriaDAO.modificarCategoria(categoria.id, Categoria(
                  id: categoria.id,
                  nombre: nuevoNombre,
                  descripcion: nuevaDescripcion,
                ));

                // Cierra el Dialog
                Navigator.of(context).pop();

                // Recarga la página
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriasPage(),
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
        title: const Text('Categorías'),
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
              'Categorías',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Descripción')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: categorias
                  .map(
                    (categoria) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(categoria.nombre)),
                    DataCell(Text(categoria.descripcion)),
                    DataCell(
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              _mostrarDetallesCategoria(categoria); // Muestra los detalles de la categoría
                            },
                            child: const Text('Ver categoría'),
                          ),
                          TextButton(
                            onPressed: () {
                              _mostrarModificarCategoriaDialog(categoria);
                            },
                            child: const Text('Editar categoría'),
                          ),
                          TextButton(
                            onPressed: () {
                              _mostrarEliminarCategoriaDialog(categoria);
                            },
                            child: const Text('Eliminar categoría'),
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
          _mostrarRegistrarCategoriaDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
