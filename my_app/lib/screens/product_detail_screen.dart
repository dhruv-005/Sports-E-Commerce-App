import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../theme/app_style.dart';
import '../widgets/promo_banner.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/sports_logo.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final wishlist = Provider.of<WishlistProvider>(context);
    final colorScheme = Theme.of(context).colorScheme;
    final responsive = ResponsiveLayout.of(context);
    final isFavorite = wishlist.isFavorite(widget.product.id);

    return Scaffold(
      appBar: AppBar(
        title: const SportsLogo(size: 28, showText: false),
        actions: [
          IconButton(
            onPressed: () => wishlist.toggle(widget.product.id),
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final contentWidth = constraints.maxWidth > responsive.maxContentWidth
                  ? responsive.maxContentWidth
                  : constraints.maxWidth;
              final wideLayout = contentWidth >= 900;

              return Center(
                child: SizedBox(
                  width: contentWidth,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(responsive.pagePadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        wideLayout
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _imagePanel(height: 340)),
                                  const SizedBox(width: 18),
                                  Expanded(child: _infoPanel(context, cart, colorScheme)),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _imagePanel(height: responsive.isCompact ? 200 : 260),
                                  const SizedBox(height: 16),
                                  _infoPanel(context, cart, colorScheme),
                                ],
                              ),
                        const SizedBox(height: 14),
                        SizedBox(
                          height: 112,
                          child: PromoBanner(
                            title: 'Express Delivery Eligible',
                            subtitle: 'Order now for same-day dispatch in major cities.',
                            cta: 'Delivery Options',
                            icon: Icons.bolt_outlined,
                            gradient: LinearGradient(
                              colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                            ),
                            onTap: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (sheetContext) => SafeArea(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Delivery Options',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: Icon(Icons.flash_on_outlined),
                                          title: Text('Express (same day)'),
                                        ),
                                        ListTile(
                                          contentPadding: EdgeInsets.zero,
                                          leading: Icon(Icons.local_shipping_outlined),
                                          title: Text('Standard (2-4 days)'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _imagePanel({required double height}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppStyle.cardGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Hero(
        tag: 'product-image-${widget.product.id}',
        child: Image.network(
          widget.product.image,
          height: height,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _infoPanel(
    BuildContext context,
    CartProvider cart,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '₹ ${widget.product.price}',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 14),
        Text(widget.product.description),
        const SizedBox(height: 22),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 6,
          children: [
            Text(
              'Quantity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              onPressed: _quantity > 1 ? () => setState(() => _quantity--) : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              '$_quantity',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              onPressed: () => setState(() => _quantity++),
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.94, end: 1),
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutBack,
            builder: (context, value, child) => Transform.scale(
              scale: value,
              child: child,
            ),
            child: FilledButton.icon(
              icon: const Icon(Icons.shopping_cart),
              label: Text('Add $_quantity to Cart'),
              onPressed: () {
                cart.addToCart(widget.product, quantity: _quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added $_quantity item(s) to cart',
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
