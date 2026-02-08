import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, int> _items = {};
  final Map<int, Product> _products = {};

  Map<int, int> get items => _items;

  void addToCart(Product product) {
    _products[product.id] = product;
    _items[product.id] = (_items[product.id] ?? 0) + 1;
    notifyListeners();
  }

  void removeFromCart(int id) {
    _items.remove(id);
    _products.remove(id);
    notifyListeners();
  }

  double get total {
    double sum = 0;
    _items.forEach((id, qty) {
      sum += _products[id]!.price * qty;
    });
    return sum;
  }

  List<Product> get products =>
      _items.keys.map((id) => _products[id]!).toList();
}

