import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/theme.dart';
import '../../widgets/auth_layout.dart';
import '../../widgets/input_field.dart';
import '../../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // Hàm đăng ký người dùng
  Future<void> _register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Kiểm tra email hợp lệ
    if (!_isValidEmail(email)) {
      _showMessage('Email không hợp lệ');
      return;
    }

    // Kiểm tra mật khẩu
    if (password.length < 6) {
      _showMessage('Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    // Kiểm tra mật khẩu xác nhận
    if (password != confirmPassword) {
      _showMessage('Mật khẩu không khớp');
      return;
    }

    setState(() => isLoading = true);

    try {
      // Đăng ký người dùng qua Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      if (user != null) {
        // Kiểm tra nếu là người dùng đầu tiên để gán quyền admin
        String role = 'user'; // Mặc định là user
        final usersCollection = FirebaseFirestore.instance.collection('users');
        var querySnapshot = await usersCollection.get();
        if (querySnapshot.docs.isEmpty) {
          role = 'admin'; // Nếu là người dùng đầu tiên, gán role là admin
        }

        // Lưu thông tin người dùng vào Firestore
        await usersCollection.doc(user.uid).set({
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        });

        setState(() => isLoading = false);

        // Thông báo đăng ký thành công
        _showMessage('Đăng ký thành công!');
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      setState(() => isLoading = false);
      // Thông báo lỗi
      _showMessage('Đăng ký thất bại. Vui lòng thử lại.');
    }
  }

  // Kiểm tra tính hợp lệ của email
  bool _isValidEmail(String email) {
    return RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$",
    ).hasMatch(email);
  }

  // Hiển thị thông báo
  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Đăng ký',
      subtitle: 'Tạo tài khoản để bắt đầu',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InputField(
              labelText: 'Email',
              controller: emailController,
              prefixIcon: Icons.email_outlined,
            ),
            const SizedBox(height: 16),
            InputField(
              labelText: 'Mật khẩu',
              obscureText: !isPasswordVisible,
              controller: passwordController,
              prefixIcon: Icons.lock_outline,
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.hint,
                ),
                onPressed:
                    () => setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    }),
              ),
            ),
            const SizedBox(height: 16),
            InputField(
              labelText: 'Xác nhận mật khẩu',
              obscureText: !isConfirmPasswordVisible,
              controller: confirmPasswordController,
              prefixIcon: Icons.lock_reset_outlined,
              suffixIcon: IconButton(
                icon: Icon(
                  isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AppColors.hint,
                ),
                onPressed:
                    () => setState(() {
                      isConfirmPasswordVisible = !isConfirmPasswordVisible;
                    }),
              ),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(label: 'Đăng ký', onPressed: _register),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: AppColors.text),
                    children: [
                      const TextSpan(text: 'Đã có tài khoản? '),
                      TextSpan(
                        text: 'Đăng nhập',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
