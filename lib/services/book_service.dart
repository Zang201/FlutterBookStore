import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class BookService {
  final CollectionReference _booksCollection = FirebaseFirestore.instance
      .collection('books');

  Future<List<Book>> getBooksFromFirestore() async {
    try {
      final snapshot = await _booksCollection.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Book.fromMap(data, doc.id); // Truyền doc.id vào Book.fromMap
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy dữ liệu từ Firestore: $e');
      return [];
    }
  }
}
