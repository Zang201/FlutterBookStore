import 'package:bookstore_app/screens/admin/add_book_screen.dart';
import 'package:bookstore_app/screens/admin/admin_dashboard.dart';
import 'package:bookstore_app/screens/admin/manage_books_screen.dart';
import 'package:bookstore_app/screens/admin/manage_orders_screen.dart';
import 'package:bookstore_app/screens/admin/manage_users_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'providers/cart_provider.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookStore App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot_password_screen': (context) => const ForgotPasswordScreen(),
        '/admin/manage_books': (context) => const ManageBooksScreen(),
        '/admin/add_book': (context) => const AddBookScreen(),
        '/admin/dashboard': (context) => const AdminDashboardScreen(),
        '/admin/manage_users': (context) => const ManageUsersScreen(),
        '/admin/manage_orders': (context) => const ManageOrdersScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Nếu đang xác thực hoặc chưa tải xong trạng thái
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Nếu đã đăng nhập
        if (authProvider.user != null) {
          return const HomeScreen();
        }

        // Nếu chưa đăng nhập
        return const LoginScreen();
      },
    );
  }
}
