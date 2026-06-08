import 'package:flutter/material.dart';
import 'product_data.dart';

// A class to hold the product and how many the user wants
class CartItem {
  final ProductItem product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

// The central "brain" for the cart
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Add item to cart (or increase quantity if already in cart)
  void addToCart(ProductItem product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += 1;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners(); 
  }

  // Remove item completely
  void removeFromCart(ProductItem product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  // Calculate total price
  double get totalPrice {
    return _items.fold(0, (total, currentItem) => total + (currentItem.product.price * currentItem.quantity));
  }

  // Empty the cart after successful payment
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}