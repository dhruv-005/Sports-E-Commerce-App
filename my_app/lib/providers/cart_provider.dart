import 'package:flutter/material.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, int> _items = {};
  final Map<int, Product> _products = {};

  Map<int, int> get items => Map.unmodifiable(_items);

  void addToCart(Product product, {int quantity = 1}) {
    if (quantity <= 0) return;
    _products[product.id] = product;
    _items[product.id] = (_items[product.id] ?? 0) + quantity;
    notifyListeners();
  }

  void increment(int id) {
    final current = _items[id];
    if (current == null) return;
    _items[id] = current + 1;
    notifyListeners();
  }

  void decrement(int id) {
    final current = _items[id];
    if (current == null) return;
    if (current <= 1) {
      removeFromCart(id);
      return;
    }
    _items[id] = current - 1;
    notifyListeners();
  }

  void updateQuantity(int id, int quantity) {
    if (!_items.containsKey(id)) return;
    if (quantity <= 0) {
      removeFromCart(id);
      return;
    }
    _items[id] = quantity;
    notifyListeners();
  }

  void removeFromCart(int id) {
    _items.remove(id);
    _products.remove(id);
    notifyListeners();
  }

  Future<void> clearCart() async {
    _items.clear();
    _products.clear();
    notifyListeners();
  }

  double get total {
    double sum = 0;
    _items.forEach((id, qty) {
      sum += _products[id]!.price * qty;
    });
    return sum;
  }

  int get itemCount => _items.values.fold(0, (sum, qty) => sum + qty);

  List<Product> get products =>
      _items.keys.map((id) => _products[id]!).toList();
}
