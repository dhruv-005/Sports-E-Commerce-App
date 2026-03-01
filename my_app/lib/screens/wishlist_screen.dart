import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/wishlist_provider.dart';
import '../services/api_service.dart';
import '../widgets/product_card.dart';
import '../widgets/promo_banner.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/sports_logo.dart';
import 'home_screen.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final responsive = ResponsiveLayout.of(context);

    return Scaffold(
      appBar: AppBar(title: const SportsLogo(size: 28, showText: false)),
      body: FutureBuilder<List<Product>>(
        future: ApiService.fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load wishlist'));
          }

          final all = snapshot.data ?? <Product>[];
          final favorites = all.where((p) => wishlist.productIds.contains(p.id)).toList();

          if (favorites.isEmpty) {
            return const Center(child: Text('Your wishlist is empty'));
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth > responsive.maxContentWidth
                  ? responsive.maxContentWidth
                  : constraints.maxWidth;
              final columns = ResponsiveLayout.productColumnsForWidth(width);
              final ratio = ResponsiveLayout.productAspectRatioForWidth(width);

              return Center(
                child: SizedBox(
                  width: width,
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            responsive.pagePadding,
                            10,
                            responsive.pagePadding,
                            10,
                          ),
                          child: SizedBox(
                            height: 112,
                            child: PromoBanner(
                              title: 'Wishlist Deals Waiting',
                              subtitle: 'Track your saved items and catch price drops.',
                              cta: 'Keep Watching',
                              icon: Icons.favorite,
                              gradient: LinearGradient(
                                colors: [Color(0xFF7E22CE), Color(0xFFA21CAF)],
                              ),
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HomeScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(
                          responsive.pagePadding,
                          2,
                          responsive.pagePadding,
                          14,
                        ),
                        sliver: SliverGrid(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            childAspectRatio: ratio,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (_, i) => ProductCard(
                              product: favorites[i],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailScreen(
                                    product: favorites[i],
                                  ),
                                ),
                              ),
                            ),
                            childCount: favorites.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
