import 'package:flutter/material.dart';
import 'package:flutter_trabajo/Screens/screens.dart';

class AppRoutes {
  static const initialRoute = '/login';
  static Map<String, Widget Function(BuildContext)> routes = {
    '/login': (BuildContext context) => const LoginPage(),
    '/register': (BuildContext context) => const RegistrationPage(),
    '/home': (BuildContext context) => const HomePage(),
    '/productos': (BuildContext context) => const ProductosPage(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const ErrorScreen(),
    );
  }

}
