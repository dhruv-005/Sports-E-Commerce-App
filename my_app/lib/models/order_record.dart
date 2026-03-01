class OrderItem {
  final int productId;
  final String title;
  final String image;
  final double price;
  final int quantity;

  const OrderItem({
    required this.productId,
    required this.title,
    required this.image,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: (json['productId'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      price: ((json['price'] ?? 0) as num).toDouble(),
      quantity: ((json['quantity'] ?? 1) as num).toInt(),
    );
  }
}

class OrderRecord {
  final String id;
  final DateTime placedAt;
  final double total;
  final String paymentMethod;
  final String status;
  final String shippingAddress;
  final List<OrderItem> items;

  const OrderRecord({
    required this.id,
    required this.placedAt,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.shippingAddress,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'placedAt': placedAt.toIso8601String(),
      'total': total,
      'paymentMethod': paymentMethod,
      'status': status,
      'shippingAddress': shippingAddress,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  factory OrderRecord.fromJson(Map<String, dynamic> json) {
    final itemsJson = (json['items'] as List?) ?? const [];
    return OrderRecord(
      id: (json['id'] ?? '').toString(),
      placedAt: DateTime.tryParse((json['placedAt'] ?? '').toString()) ??
          DateTime.now(),
      total: ((json['total'] ?? 0) as num).toDouble(),
      paymentMethod: (json['paymentMethod'] ?? 'COD').toString(),
      status: (json['status'] ?? 'Placed').toString(),
      shippingAddress: (json['shippingAddress'] ?? '').toString(),
      items: itemsJson.whereType<Map>().map((entry) {
        final mapped = entry.map((k, v) => MapEntry(k.toString(), v));
        return OrderItem.fromJson(mapped);
      }).toList(),
    );
  }
}
