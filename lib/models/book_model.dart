import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String category;
  final String description;
  final String image;
  final double price;
  final DateTime createdAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.image,
    required this.price,
    required this.createdAt,
  });

  // Hàm chuyển đổi từ Map sang Book
  factory Book.fromMap(Map<String, dynamic> data, String id) {
    return Book(
      id: id,
      title: data['title'] ?? 'Không có tiêu đề', // Giá trị mặc định nếu null
      author: data['author'] ?? 'Không rõ tác giả', // Giá trị mặc định nếu null
      category:
          data['category'] ?? 'Không rõ thể loại', // Giá trị mặc định nếu null
      description:
          data['description'] ?? 'Không có mô tả', // Giá trị mặc định nếu null
      image: data['image'] ?? '', // Giá trị mặc định nếu null
      price: (data['price'] is num) ? (data['price'] as num).toDouble() : 0.0,
      createdAt:
          data['createdAt'] != null && data['createdAt'] is Timestamp
              ? (data['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }

  // Hàm chuyển đổi từ Book sang Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'category': category,
      'description': description,
      'image': image,
      'price': price,
      'createdAt': createdAt,
    };
  }
}

Future<void> fetchBookData(String bookId) async {
  try {
    DocumentSnapshot bookDoc =
        await FirebaseFirestore.instance.collection('books').doc(bookId).get();

    if (bookDoc.exists) {
      Map<String, dynamic> bookData = bookDoc.data() as Map<String, dynamic>;
      Book book = Book.fromMap(bookData, bookId);
      print('Title: ${book.title}');
    } else {
      print('! Document không tồn tại');
    }
  } catch (e) {
    print('Lỗi lấy sách: $e');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Firestore Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () => fetchBookData('book123'),
            child: Text('Fetch Book Data'),
          ),
        ),
      ),
    );
  }
}
