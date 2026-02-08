import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String api =
      "https://fakestoreapi.com/products";

  static Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(api));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}

