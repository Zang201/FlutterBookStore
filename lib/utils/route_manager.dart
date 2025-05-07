import 'package:flutter/material.dart';
import 'package:bookstore_app/screens/home/home_screen.dart';
import 'package:bookstore_app/screens/auth/login_screen.dart';

class RouteManager {
  static const String homeRoute = '/home';
  static const String loginRoute = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
