import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/api_service.dart';
import '../theme/app_style.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/sports_logo.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';
import 'product_detail_screen.dart';
import 'settings_screen.dart';
import 'wishlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  static const String _allCategory = 'All';
  static const String _sortRelevance = 'Relevance';
  static const String _sortLowToHigh = 'Price: Low to High';
  static const String _sortHighToLow = 'Price: High to Low';
  static const String _sortName = 'Name: A-Z';

  final List<_PromoData> _promoItems = const [
    _PromoData(
      title: 'Flash Deal: Performance Shoes',
      subtitle: 'Up to 35% off until midnight on selected brands.',
      cta: 'Shop Deals',
      icon: Icons.local_offer_outlined,
      gradient: LinearGradient(
        colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
      ),
    ),
    _PromoData(
      title: 'Free Delivery Weekend',
      subtitle: 'No shipping fee on orders above ₹999 this weekend.',
      cta: 'Unlock Free Shipping',
      icon: Icons.local_shipping_outlined,
      gradient: LinearGradient(
        colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
      ),
    ),
    _PromoData(
      title: 'Loyalty Bonus Active',
      subtitle: 'Earn 2x points on cricket and football equipment.',
      cta: 'View Rewards',
      icon: Icons.workspace_premium_outlined,
      gradient: LinearGradient(
        colors: [Color(0xFFBE123C), Color(0xFFE11D48)],
      ),
    ),
  ];

  late final AnimationController _headerController;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late Future<List<Product>> _productsFuture;
  String _selectedCategory = _allCategory;
  String _selectedSort = _sortRelevance;
  String _searchQuery = '';

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  void _openOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OrdersScreen()),
    );
  }

  void _openWishlist() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WishlistScreen()),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void _handleBannerTap(int index) {
    switch (index) {
      case 0:
        setState(() {
          _selectedSort = _sortLowToHigh;
          _selectedCategory = _allCategory;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Deal view applied: lowest prices first.')),
        );
        break;
      case 1:
        _openCart();
        break;
      case 2:
        _openOrders();
        break;
    }
  }

  void _handleQuickMenu(_QuickMenuAction action) {
    switch (action) {
      case _QuickMenuAction.wishlist:
        _openWishlist();
        break;
      case _QuickMenuAction.orders:
        _openOrders();
        break;
      case _QuickMenuAction.settings:
        _openSettings();
        break;
      case _QuickMenuAction.cart:
        _openCart();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _headerFade = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeIn,
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    ));
    _productsFuture = ApiService.fetchProducts();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;
    final wishlistCount = context.watch<WishlistProvider>().productIds.length;
    final responsive = ResponsiveLayout.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const SportsLogo(size: 30, showText: false),
        actions: [
          IconButton(
            icon: _iconWithCount(
              icon: Icons.favorite_border,
              count: wishlistCount,
            ),
            onPressed: _openWishlist,
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined),
            onPressed: _openOrders,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: _openSettings,
          ),
          IconButton(
            icon: _iconWithCount(
              icon: Icons.shopping_cart,
              count: cartCount,
            ),
            onPressed: _openCart,
          ),
          PopupMenuButton<_QuickMenuAction>(
            icon: const Icon(Icons.menu),
            onSelected: _handleQuickMenu,
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: _QuickMenuAction.wishlist,
                child: Text('Wishlist'),
              ),
              PopupMenuItem(
                value: _QuickMenuAction.orders,
                child: Text('Orders'),
              ),
              PopupMenuItem(
                value: _QuickMenuAction.settings,
                child: Text('Settings'),
              ),
              PopupMenuItem(
                value: _QuickMenuAction.cart,
                child: Text('Cart'),
              ),
            ],
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bodyWidth = constraints.maxWidth > responsive.maxContentWidth
              ? responsive.maxContentWidth
              : constraints.maxWidth;

          return Center(
            child: SizedBox(
              width: bodyWidth,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      responsive.pagePadding,
                      4,
                      responsive.pagePadding,
                      10,
                    ),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: AppStyle.appGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FadeTransition(
                      opacity: _headerFade,
                      child: SlideTransition(
                        position: _headerSlide,
                        child: const Row(
                          children: [
                            Icon(Icons.local_fire_department,
                                color: Colors.white, size: 28),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Trending Sports Gear',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: responsive.isCompact ? 116 : 126,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.pagePadding,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: _promoItems.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, index) {
                        final promo = _promoItems[index];
                        return SizedBox(
                          width: responsive.isCompact ? 265 : 318,
                          child: PromoBanner(
                            title: promo.title,
                            subtitle: promo.subtitle,
                            cta: promo.cta,
                            icon: promo.icon,
                            gradient: promo.gradient,
                            showLabel: false,
                            onTap: () => _handleBannerTap(index),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      responsive.pagePadding,
                      0,
                      responsive.pagePadding,
                      8,
                    ),
                    child: TextField(
                      onChanged: (value) =>
                          setState(() => _searchQuery = value.trim()),
                      decoration: const InputDecoration(
                        hintText: 'Search products...',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      responsive.pagePadding,
                      0,
                      responsive.pagePadding,
                      8,
                    ),
                    child: responsive.isPhone
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              DropdownButtonFormField<String>(
                                key: ValueKey(_selectedSort),
                                initialValue: _selectedSort,
                                decoration: const InputDecoration(
                                  labelText: 'Sort by',
                                  prefixIcon: Icon(Icons.sort),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: _sortRelevance,
                                    child: Text(_sortRelevance),
                                  ),
                                  DropdownMenuItem(
                                    value: _sortLowToHigh,
                                    child: Text(_sortLowToHigh),
                                  ),
                                  DropdownMenuItem(
                                    value: _sortHighToLow,
                                    child: Text(_sortHighToLow),
                                  ),
                                  DropdownMenuItem(
                                    value: _sortName,
                                    child: Text(_sortName),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value == null) return;
                                  setState(() => _selectedSort = value);
                                },
                              ),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  tooltip: 'Refresh products',
                                  onPressed: () {
                                    setState(() {
                                      _productsFuture = ApiService.fetchProducts();
                                    });
                                  },
                                  icon: const Icon(Icons.refresh),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  key: ValueKey(_selectedSort),
                                  initialValue: _selectedSort,
                                  decoration: const InputDecoration(
                                    labelText: 'Sort by',
                                    prefixIcon: Icon(Icons.sort),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: _sortRelevance,
                                      child: Text(_sortRelevance),
                                    ),
                                    DropdownMenuItem(
                                      value: _sortLowToHigh,
                                      child: Text(_sortLowToHigh),
                                    ),
                                    DropdownMenuItem(
                                      value: _sortHighToLow,
                                      child: Text(_sortHighToLow),
                                    ),
                                    DropdownMenuItem(
                                      value: _sortName,
                                      child: Text(_sortName),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() => _selectedSort = value);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                tooltip: 'Refresh products',
                                onPressed: () {
                                  setState(() {
                                    _productsFuture = ApiService.fetchProducts();
                                  });
                                },
                                icon: const Icon(Icons.refresh),
                              ),
                            ],
                          ),
                  ),
                  Expanded(
                    child: FutureBuilder<List<Product>>(
                      future: _productsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Failed to load products'),
                          );
                        }

                        final products = snapshot.data ?? [];
                        final categories = <String>{
                          for (final product in products)
                            _formatCategory(product.category),
                        }.toList()
                          ..sort();
                        final categoryOptions = <String>[_allCategory, ...categories];
                        final selected = _selectedCategory;
                        final visibleProducts = _filterAndSortProducts(
                          products: products,
                          selectedCategory: selected,
                          searchQuery: _searchQuery,
                          sortBy: _selectedSort,
                        );

                        return Column(
                          children: [
                            SizedBox(
                              height: 52,
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(
                                  horizontal: responsive.pagePadding,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (_, index) {
                                  final category = categoryOptions[index];
                                  final isSelected = category == selected;
                                  return ChoiceChip(
                                    label: Text(category),
                                    selected: isSelected,
                                    onSelected: (_) {
                                      setState(() => _selectedCategory = category);
                                    },
                                  );
                                },
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 8),
                                itemCount: categoryOptions.length,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              child: visibleProducts.isEmpty
                                  ? const Center(
                                      child: Text('No products in this category'),
                                    )
                                  : LayoutBuilder(
                                      builder: (context, constraints) {
                                        final gridWidth = constraints.maxWidth;
                                        final columns = ResponsiveLayout
                                            .productColumnsForWidth(gridWidth);
                                        final spacing = responsive.isPhone ? 12.0 : 14.0;
                                        return GridView.builder(
                                          padding: EdgeInsets.fromLTRB(
                                            responsive.pagePadding,
                                            2,
                                            responsive.pagePadding,
                                            14,
                                          ),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: columns,
                                            childAspectRatio: ResponsiveLayout
                                                .productAspectRatioForWidth(
                                              gridWidth,
                                            ),
                                            crossAxisSpacing: spacing,
                                            mainAxisSpacing: spacing,
                                          ),
                                          itemCount: visibleProducts.length,
                                          itemBuilder: (_, i) {
                                            return TweenAnimationBuilder<double>(
                                              duration:
                                                  Duration(milliseconds: 300 + (i * 70)),
                                              tween: Tween(begin: 0, end: 1),
                                              curve: Curves.easeOutCubic,
                                              builder: (context, value, child) {
                                                return Opacity(
                                                  opacity: value,
                                                  child: Transform.translate(
                                                    offset: Offset(0, (1 - value) * 24),
                                                    child: child,
                                                  ),
                                                );
                                              },
                                              child: ProductCard(
                                                product: visibleProducts[i],
                                                onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ProductDetailScreen(
                                                      product: visibleProducts[i],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 0) return;
          if (index == 1) {
            _openWishlist();
            return;
          }
          if (index == 2) {
            _openOrders();
            return;
          }
          if (index == 3) {
            _openCart();
            return;
          }
          _openSettings();
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront_outlined), label: 'Shop'),
          NavigationDestination(icon: Icon(Icons.favorite_outline), label: 'Wishlist'),
          NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'Orders'),
          NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          NavigationDestination(icon: Icon(Icons.tune_outlined), label: 'Settings'),
        ],
      ),
    );
  }

  String _formatCategory(String raw) {
    final category = raw.trim();
    if (category.isEmpty) return 'General';
    return category
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) return word;
          return '${word[0].toUpperCase()}${word.substring(1)}';
        })
        .join(' ');
  }

  Widget _iconWithCount({
    required IconData icon,
    required int count,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            right: -8,
            top: -7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: const BoxDecoration(
                color: AppStyle.accent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }

  List<Product> _filterAndSortProducts({
    required List<Product> products,
    required String selectedCategory,
    required String searchQuery,
    required String sortBy,
  }) {
    final query = searchQuery.toLowerCase();
    final filtered = products.where((product) {
      final categoryOk = selectedCategory == _allCategory ||
          _formatCategory(product.category) == selectedCategory;
      final searchOk = query.isEmpty ||
          product.title.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
      return categoryOk && searchOk;
    }).toList();

    switch (sortBy) {
      case _sortLowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case _sortHighToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case _sortName:
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case _sortRelevance:
        break;
    }

    return filtered;
  }
}

enum _QuickMenuAction { wishlist, orders, settings, cart }

class _PromoData {
  const _PromoData({
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.icon,
    required this.gradient,
  });

  final String title;
  final String subtitle;
  final String cta;
  final IconData icon;
  final Gradient gradient;
}
