// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_trabajo/Models/Proovedor.dart';
import 'package:flutter_trabajo/services/firebase_service.dart';
import 'home.dart';

class ProveedoresPage extends StatefulWidget {
  const ProveedoresPage({Key? key}) : super(key: key);

  @override
  _ProveedoresPageState createState() => _ProveedoresPageState();
}

class _ProveedoresPageState extends State<ProveedoresPage> {
  late List<Proveedor> proveedores;

  @override
  void initState() {
    super.initState();
    proveedores = [];

    // Llama a la función para cargar los proveedores
    _cargarProveedores();
  }

  Future<void> _cargarProveedores() async {
    // Llama a la función para obtener los proveedores utilizando la clase ProveedorDAO
    final proveedorDAO = ProveedorDAO();
    final proveedores = await proveedorDAO.getProveedores();

    setState(() {
      this.proveedores = proveedores;
    });
  }

  // Función para mostrar un Dialog con los detalles del proveedor
  void _mostrarDetallesProveedor(Proveedor proveedor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Detalles del Proveedor'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nombre: ${proveedor.nombre}'),
              Text('Descripción: ${proveedor.descripcion}'),
              Text('Locación: ${proveedor.locacion}'),
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

  void _eliminarProveedor(Proveedor proveedor) async {
    final proveedorDAO = ProveedorDAO();
    await proveedorDAO.eliminarProveedor(proveedor.id);

    // Cierra el Dialog
    Navigator.of(context).pop();

    // Recarga la página
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ProveedoresPage(),
      ),
    );
  }

  void _mostrarEliminarProveedorDialog(Proveedor proveedor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Proveedor'),
          content: Text('¿Estás seguro de que deseas eliminar al proveedor "${proveedor.nombre}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _eliminarProveedor(proveedor); // Llama a la función para eliminar el proveedor
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarRegistrarProveedorDialog() {
    TextEditingController nombreController = TextEditingController();
    TextEditingController descripcionController = TextEditingController();
    TextEditingController locacionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registrar Proveedor'),
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
                TextFormField(
                  controller: locacionController,
                  decoration: const InputDecoration(labelText: 'Locación'),
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
                // Obtén los datos del nuevo proveedor
                final nuevoNombre = nombreController.text;
                final nuevaDescripcion = descripcionController.text;
                final nuevaLocacion = locacionController.text;

                // Registra el nuevo proveedor en la base de datos
                final proveedorDAO = ProveedorDAO();
                await proveedorDAO.agregarProveedor(Proveedor(
                  id: "None",
                  nombre: nuevoNombre,
                  descripcion: nuevaDescripcion,
                  locacion: nuevaLocacion,
                ));

                // Cierra el Dialog
                Navigator.of(context).pop();

                // Recarga la página
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProveedoresPage(),
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

  void _mostrarModificarProveedorDialog(Proveedor proveedor) {
    TextEditingController nombreController = TextEditingController(text: proveedor.nombre);
    TextEditingController descripcionController = TextEditingController(text: proveedor.descripcion);
    TextEditingController locacionController = TextEditingController(text: proveedor.locacion);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modificar Proveedor'),
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
                TextFormField(
                  controller: locacionController,
                  decoration: const InputDecoration(labelText: 'Locación'),
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
                final nuevaLocacion = locacionController.text;

                // Actualiza el proveedor en la base de datos
                final proveedorDAO = ProveedorDAO();
                await proveedorDAO.modificarProveedor(proveedor.id, Proveedor(
                  id: proveedor.id,
                  nombre: nuevoNombre,
                  descripcion: nuevaDescripcion,
                  locacion: nuevaLocacion,
                ));

                // Cierra el Dialog
                Navigator.of(context).pop();

                // Recarga la página
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProveedoresPage(),
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
        title: const Text('Proveedores'),
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
              'Proveedores',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Descripción')),
                DataColumn(label: Text('Locación')),
                DataColumn(label: Text('Acciones')),
              ],
              rows: proveedores
                  .map(
                    (proveedor) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(proveedor.nombre)),
                    DataCell(Text(proveedor.descripcion)),
                    DataCell(Text(proveedor.locacion)),
                    DataCell(
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              _mostrarDetallesProveedor(proveedor); // Muestra los detalles del proveedor
                            },
                            child: const Text('Ver proveedor'),
                          ),
                          TextButton(
                            onPressed: () {
                              _mostrarModificarProveedorDialog(proveedor);
                            },
                            child: const Text('Editar proveedor'),
                          ),
                          TextButton(
                            onPressed: () {
                              _mostrarEliminarProveedorDialog(proveedor);
                            },
                            child: const Text('Eliminar proveedor'),
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
          _mostrarRegistrarProveedorDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
