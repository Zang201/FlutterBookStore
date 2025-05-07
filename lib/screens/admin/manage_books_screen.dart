import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageBooksScreen extends StatefulWidget {
  const ManageBooksScreen({Key? key}) : super(key: key);

  @override
  _ManageBooksScreenState createState() => _ManageBooksScreenState();
}

class _ManageBooksScreenState extends State<ManageBooksScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thêm sách vào Firestore
  Future<void> _addBook() async {
    final title = _titleController.text;
    final author = _authorController.text;
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final description = _descriptionController.text;
    final categoryId = _categoryController.text;
    final imageUrl = _imageController.text;

    if (title.isEmpty || author.isEmpty || price == 0.0) {
      return; // Không làm gì nếu thiếu thông tin bắt buộc
    }

    try {
      await _firestore.collection('books').add({
        'title': title,
        'author': author,
        'price': price,
        'description': description,
        'categoryId': categoryId,
        'image': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Reset các trường nhập liệu sau khi thêm
      _titleController.clear();
      _authorController.clear();
      _priceController.clear();
      _descriptionController.clear();
      _categoryController.clear();
      _imageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sách đã được thêm thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lỗi khi thêm sách')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quản lý sách')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Tên sách'),
            ),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Tác giả'),
            ),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Giá'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Mô tả'),
            ),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: 'Danh mục'),
            ),
            TextField(
              controller: _imageController,
              decoration: const InputDecoration(labelText: 'URL hình ảnh'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _addBook, child: const Text('Thêm sách')),
          ],
        ),
      ),
    );
  }
}
