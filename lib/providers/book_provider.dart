import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BookProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Book> _books = [];
  List<Book> get books => _books;

  // Hàm thêm sách vào Firestore
  Future<bool> addBook({
    required String title,
    required String author,
    required double price,
    required String description,
    required String category,
    required String imageUrl,
  }) async {
    try {
      // Tạo document mới cho sách
      final bookRef = _firestore.collection('books').doc();
      await bookRef.set({
        'title': title,
        'author': author,
        'price': price,
        'description': description,
        'category': category,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Không cần phải refresh sách ngay, chỉ cần thông báo thành công
      return true;
    } catch (e) {
      print('Lỗi thêm sách: $e');
      return false;
    }
  }

  // Hàm lấy danh sách sách từ Firestore và chuyển đổi thành đối tượng Book
  Future<void> fetchBooks() async {
    try {
      final querySnapshot =
          await _firestore.collection('books').orderBy('createdAt').get();
      _books =
          querySnapshot.docs.map((doc) {
            final data = doc.data();
            return Book(
              id: doc.id,
              title: data['title'],
              author: data['author'],
              price: (data['price'] as num).toDouble(),
              description: data['description'],
              category: data['category'],
              image: data['image'],
              createdAt: (data['createdAt'] as Timestamp).toDate(),
            );
          }).toList();
      notifyListeners(); // Thông báo có sự thay đổi trong danh sách sách
    } catch (e) {
      print('Lỗi lấy sách: $e');
    }
  }
}
