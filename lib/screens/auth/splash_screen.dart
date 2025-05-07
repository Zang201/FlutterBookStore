import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookstore_app/providers/auth_provider.dart';
import 'package:bookstore_app/screens/home/home_screen.dart';
import 'package:bookstore_app/screens/auth/login_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // Đợi một chút để hiển thị splash và kiểm tra login
    Future.delayed(Duration(milliseconds: 500), () {
      if (authProvider.isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });

    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
