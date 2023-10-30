import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_trabajo/Models/producto.dart';

import '../Models/Proovedor.dart';
import '../Models/categorias.dart';


class ProductoDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Producto>> getProductos() async {
    List<Producto> productos = [];
    CollectionReference collectionReference = _db.collection("productos");

    QuerySnapshot querySnapshot = await collectionReference.get();

    querySnapshot.docs.forEach((producto) {
      Map<String, dynamic> data = producto.data() as Map<String, dynamic>;
      String productId = producto.id;

      // Crear una instancia de Producto con los datos obtenidos
      Producto nuevoProducto = Producto(
        id: productId,
        nombre: data['nombre'],
        precio: data['precio'].toDouble(),
        categoria: data['categoria'],
        descripcion: data['descripcion'],
      );

      productos.add(nuevoProducto);
    });

    return productos;
  }

  Future<void> agregarProducto(Producto producto) async {
    CollectionReference collectionReference = _db.collection("productos");
    await collectionReference.add({
      'nombre': producto.nombre,
      'precio': producto.precio,
      'categoria': producto.categoria,
      'descripcion': producto.descripcion,
    });
  }

  Future<void> modificarProducto(String productoId, Producto producto) async {
    CollectionReference collectionReference = _db.collection("productos");
    await collectionReference.doc(productoId).update({
      'nombre': producto.nombre,
      'precio': producto.precio,
      'categoria': producto.categoria,
      'descripcion': producto.descripcion,
    });
  }

  Future<void> eliminarProducto(String productoId) async {
    CollectionReference collectionReference = _db.collection("productos");
    await collectionReference.doc(productoId).delete();
  }

}

class ProveedorDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Proveedor>> getProveedores() async {
    List<Proveedor> proveedores = [];
    CollectionReference collectionReference = _db.collection("proveedores");

    QuerySnapshot querySnapshot = await collectionReference.get();

    querySnapshot.docs.forEach((proveedor) {
      Map<String, dynamic> data = proveedor.data() as Map<String, dynamic>;
      String proveedorId = proveedor.id;

      Proveedor nuevoProveedor = Proveedor(
        id: proveedorId,
        nombre: data['nombre'],
        descripcion: data['descripcion'],
        locacion: data['locacion'],
      );

      proveedores.add(nuevoProveedor);
    });

    return proveedores;
  }

  Future<void> agregarProveedor(Proveedor proveedor) async {
    CollectionReference collectionReference = _db.collection("proveedores");
    await collectionReference.add({
      'nombre': proveedor.nombre,
      'descripcion': proveedor.descripcion,
      'locacion': proveedor.locacion,
    });
  }

  Future<void> modificarProveedor(String proveedorId, Proveedor proveedor) async {
    CollectionReference collectionReference = _db.collection("proveedores");
    await collectionReference.doc(proveedorId).update({
      'nombre': proveedor.nombre,
      'descripcion': proveedor.descripcion,
      'locacion': proveedor.locacion,
    });
  }

  Future<void> eliminarProveedor(String proveedorId) async {
    CollectionReference collectionReference = _db.collection("proveedores");
    await collectionReference.doc(proveedorId).delete();
  }
}

class CategoriaDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Categoria>> getCategorias() async {
    List<Categoria> categorias = [];
    CollectionReference collectionReference = _db.collection("categorias");

    QuerySnapshot querySnapshot = await collectionReference.get();

    querySnapshot.docs.forEach((categoria) {
      Map<String, dynamic> data = categoria.data() as Map<String, dynamic>;
      String categoriaId = categoria.id;

      // Crear una instancia de Categoria con los datos obtenidos
      Categoria nuevaCategoria = Categoria(
        id: categoriaId,
        nombre: data['nombre'],
        descripcion: data['descripcion'],
      );

      categorias.add(nuevaCategoria);
    });

    return categorias;
  }

  Future<void> agregarCategoria(Categoria categoria) async {
    CollectionReference collectionReference = _db.collection("categorias");
    await collectionReference.add({
      'nombre': categoria.nombre,
      'descripcion': categoria.descripcion,
    });
  }

  Future<void> modificarCategoria(String categoriaId, Categoria categoria) async {
    CollectionReference collectionReference = _db.collection("categorias");
    await collectionReference.doc(categoriaId).update({
      'nombre': categoria.nombre,
      'descripcion': categoria.descripcion,
    });
  }

  Future<void> eliminarCategoria(String categoriaId) async {
    CollectionReference collectionReference = _db.collection("categorias");
    await collectionReference.doc(categoriaId).delete();
  }
}