import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  void addToCart(Book book) {
    if (_items.containsKey(book.id)) {
      _items.update(
        book.id,
        (existing) => existing.copyWith(quantity: existing.quantity + 1),
      );
    } else {
      _items[book.id] = CartItem(book: book, quantity: 1);
    }
    notifyListeners();
  }

  void removeFromCart(String bookId) {
    _items.remove(bookId);
    notifyListeners();
  }

  double get totalPrice => _items.values.fold(
    0,
    (sum, item) => sum + item.book.price * item.quantity,
  );

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);
}
