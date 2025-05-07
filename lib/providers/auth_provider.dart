import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _role;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  User? get user => _user;
  String? get role => _role;

  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((user) async {
      _user = user;
      if (_user != null) {
        await _loadUserRole();
      } else {
        _role = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserRole() async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(_user!.uid).get();
      if (doc.exists) {
        _role = doc['role'] ?? 'user';
      } else {
        _role = 'user';
      }
    } catch (e) {
      print('Lỗi lấy quyền người dùng: $e');
      _role = 'user';
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = result.user;
      await _loadUserRole();
      return _user;
    } catch (e) {
      print('Đăng nhập thất bại: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = result.user;
      if (_user == null) {
        throw Exception('Không thể tạo người dùng');
      }

      final role = email == 'admin1@gmail.com' ? 'admin' : 'user';

      await _firestore.collection('users').doc(_user!.uid).set({
        'email': email,
        'displayName': _user!.email!.split('@')[0],
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _loadUserRole();
      return _user;
    } catch (e) {
      print('Đăng ký thất bại: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Gửi email khôi phục thất bại: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
      _user = null;
      _role = null;
    } catch (e) {
      print('Lỗi đăng xuất: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> checkLoginStatus() async {
    _user = _auth.currentUser;
    if (_user != null) {
      await _loadUserRole();
    }
    notifyListeners();
  }

  Future<bool> isEmailRegistered(String email) async {
    try {
      final methods = await _auth.fetchSignInMethodsForEmail(email);
      return methods.isNotEmpty;
    } catch (e) {
      print('Lỗi kiểm tra email: $e');
      return false;
    }
  }

  Future<User?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      _user = result.user;

      final userDoc =
          await _firestore.collection('users').doc(_user!.uid).get();
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(_user!.uid).set({
          'email': _user!.email,
          'displayName': _user!.displayName,
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      await _loadUserRole();
      notifyListeners();
      return _user;
    } catch (e) {
      print("Lỗi đăng nhập Google: $e");
      return null;
    }
  }

  Future<User?> loginWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final credential = FacebookAuthProvider.credential(
          result.accessToken!.token,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        _user = userCredential.user;

        final userDoc =
            await _firestore.collection('users').doc(_user!.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(_user!.uid).set({
            'email': _user!.email,
            'displayName': _user!.displayName,
            'role': 'user',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        await _loadUserRole();
        notifyListeners();
        return _user;
      } else {
        print("Lỗi đăng nhập Facebook: ${result.status}");
        return null;
      }
    } catch (e) {
      print("Lỗi đăng nhập Facebook: $e");
      return null;
    }
  }

  Future<bool> requireLogin() async {
    try {
      _isLoading = true;
      notifyListeners();

      await checkLoginStatus();
      if (_user == null) {
        return false;
      }
      return true;
    } catch (e) {
      print('Lỗi kiểm tra trạng thái đăng nhập: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
