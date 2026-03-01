import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_record.dart';
import '../models/product.dart';

class OrderProvider extends ChangeNotifier {
  static const String _ordersKey = 'orders_history';

  final List<OrderRecord> _orders = <OrderRecord>[];
  bool _isLoaded = false;

  List<OrderRecord> get orders => List.unmodifiable(_orders);
  bool get isLoaded => _isLoaded;

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_ordersKey);
    _orders.clear();
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        for (final entry in decoded) {
          if (entry is Map) {
            _orders.add(
              OrderRecord.fromJson(
                entry.map((k, v) => MapEntry(k.toString(), v)),
              ),
            );
          }
        }
      }
    }
    _orders.sort((a, b) => b.placedAt.compareTo(a.placedAt));
    _isLoaded = true;
    notifyListeners();
  }

  Future<OrderRecord> placeOrder({
    required Map<int, int> quantities,
    required List<Product> products,
    required double total,
    required String paymentMethod,
    required String shippingAddress,
  }) async {
    final now = DateTime.now();
    final order = OrderRecord(
      id: 'ODR-${now.millisecondsSinceEpoch}',
      placedAt: now,
      total: total,
      paymentMethod: paymentMethod,
      status: 'Placed',
      shippingAddress: shippingAddress,
      items: products
          .map(
            (p) => OrderItem(
              productId: p.id,
              title: p.title,
              image: p.image,
              price: p.price,
              quantity: quantities[p.id] ?? 1,
            ),
          )
          .toList(),
    );

    _orders.insert(0, order);
    await _save();
    notifyListeners();
    return order;
  }

  Future<void> clearOrders() async {
    _orders.clear();
    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_orders.map((e) => e.toJson()).toList());
    await prefs.setString(_ordersKey, encoded);
  }
}
