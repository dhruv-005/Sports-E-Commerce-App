import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistProvider extends ChangeNotifier {
  static const String _wishlistKey = 'wishlist_product_ids';

  final Set<int> _productIds = <int>{};
  bool _isLoaded = false;

  Set<int> get productIds => _productIds;
  bool get isLoaded => _isLoaded;

  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_wishlistKey);
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        _productIds
          ..clear()
          ..addAll(
            decoded
                .map((e) => e is num ? e.toInt() : int.tryParse('$e'))
                .whereType<int>(),
          );
      }
    }
    _isLoaded = true;
    notifyListeners();
  }

  bool isFavorite(int productId) => _productIds.contains(productId);

  Future<void> toggle(int productId) async {
    if (_productIds.contains(productId)) {
      _productIds.remove(productId);
    } else {
      _productIds.add(productId);
    }
    await _save();
    notifyListeners();
  }

  Future<void> clear() async {
    _productIds.clear();
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_wishlistKey, jsonEncode(_productIds.toList()));
  }
}
