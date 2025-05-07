import 'book_model.dart';

class CartItem {
  final Book book;
  final int quantity;

  CartItem({required this.book, required this.quantity});

  CartItem copyWith({Book? book, int? quantity}) {
    return CartItem(
      book: book ?? this.book,
      quantity: quantity ?? this.quantity,
    );
  }
}
