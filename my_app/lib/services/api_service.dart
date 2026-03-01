import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String api = 'https://fakestoreapi.com/products';

  static Future<List<Product>> fetchProducts() async {
    final localProducts = _sportsCatalog;
    try {
      final response = await http.get(Uri.parse(api));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        final remoteProducts = data.map((e) => Product.fromJson(e)).toList();
        return [...remoteProducts, ...localProducts];
      }
    } catch (_) {
      // Fall back to local catalog below.
    }

    return localProducts;
  }

  static final List<Product> _sportsCatalog = <Product>[
    Product(
      id: 1001,
      title: 'Pro Match Football',
      price: 1299,
      description: 'Durable size-5 football with high grip PU surface.',
      image: 'https://picsum.photos/seed/football-1001/600/600',
      category: 'football',
    ),
    Product(
      id: 1002,
      title: 'Cricket Bat - Kashmir Willow',
      price: 2499,
      description: 'Balanced bat ideal for leather-ball practice sessions.',
      image: 'https://picsum.photos/seed/cricket-bat-1002/600/600',
      category: 'cricket',
    ),
    Product(
      id: 1003,
      title: 'Cricket Ball Pack (6)',
      price: 799,
      description: 'Training-grade seam balls with consistent bounce.',
      image: 'https://picsum.photos/seed/cricket-ball-1003/600/600',
      category: 'cricket',
    ),
    Product(
      id: 1004,
      title: 'Premium Badminton Racket',
      price: 1799,
      description: 'Lightweight graphite frame with ergonomic grip.',
      image: 'https://picsum.photos/seed/badminton-1004/600/600',
      category: 'badminton',
    ),
    Product(
      id: 1005,
      title: 'Badminton Shuttlecocks (12)',
      price: 499,
      description: 'Nylon shuttle set designed for indoor and outdoor play.',
      image: 'https://picsum.photos/seed/shuttle-1005/600/600',
      category: 'badminton',
    ),
    Product(
      id: 1006,
      title: 'Basketball Indoor/Outdoor',
      price: 1399,
      description: 'Deep channel design for superior control and spin.',
      image: 'https://picsum.photos/seed/basketball-1006/600/600',
      category: 'basketball',
    ),
    Product(
      id: 1007,
      title: 'Volleyball Tournament Ball',
      price: 1199,
      description: 'Soft-touch synthetic cover and stable trajectory.',
      image: 'https://picsum.photos/seed/volleyball-1007/600/600',
      category: 'volleyball',
    ),
    Product(
      id: 1008,
      title: 'Tennis Racket Performance',
      price: 2699,
      description: 'Mid-plus head size with vibration-dampening handle.',
      image: 'https://picsum.photos/seed/tennis-racket-1008/600/600',
      category: 'tennis',
    ),
    Product(
      id: 1009,
      title: 'Tennis Balls (Can of 3)',
      price: 349,
      description: 'Pressurized felt balls built for all-court surfaces.',
      image: 'https://picsum.photos/seed/tennis-ball-1009/600/600',
      category: 'tennis',
    ),
    Product(
      id: 1010,
      title: 'Gym Resistance Band Set',
      price: 999,
      description: '5-level loop bands for strength and mobility routines.',
      image: 'https://picsum.photos/seed/resistance-1010/600/600',
      category: 'fitness',
    ),
    Product(
      id: 1011,
      title: 'Skipping Rope Speed Pro',
      price: 599,
      description: 'Adjustable steel cable rope for cardio workouts.',
      image: 'https://picsum.photos/seed/skipping-1011/600/600',
      category: 'fitness',
    ),
    Product(
      id: 1012,
      title: 'Yoga Mat Anti-Slip 6mm',
      price: 899,
      description: 'Sweat-resistant textured mat with carrying strap.',
      image: 'https://picsum.photos/seed/yoga-1012/600/600',
      category: 'fitness',
    ),
  ];
}
