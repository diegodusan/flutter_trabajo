import 'package:flutter/material.dart';
import 'package:flutter_trabajo/Screens/login_page.dart';
import 'package:flutter_trabajo/Screens/modulo_categorias.dart';

import 'modulo_productos.dart';
import 'modulo_proovedores.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text('¡Bienvenido!'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '¡Bienvenido!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProveedoresPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                minimumSize: const Size(200, 100),
              ),
              child: const Text(
                'Módulo de Proveedores',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProductosPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                minimumSize: const Size(200, 100),
              ),
              child: const Text(
                'Módulo de Productos',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CategoriasPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                minimumSize: const Size(200, 100),
              ),
              child: const Text(
                'Modulo de Categorías',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
