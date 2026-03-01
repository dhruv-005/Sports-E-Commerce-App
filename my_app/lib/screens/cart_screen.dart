import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_settings_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../theme/app_style.dart';
import '../widgets/promo_banner.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/sports_logo.dart';
import 'home_screen.dart';
import 'orders_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _checkout(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final settings = context.read<AppSettingsProvider>();
    final orders = context.read<OrderProvider>();

    if (cart.items.isEmpty) return;

    final paymentMethod = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text(
                'Select Payment Method',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.payments_outlined),
              title: const Text('UPI'),
              onTap: () => Navigator.pop(sheetContext, 'UPI'),
            ),
            ListTile(
              leading: const Icon(Icons.credit_card_outlined),
              title: const Text('Card'),
              onTap: () => Navigator.pop(sheetContext, 'Card'),
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping_outlined),
              title: const Text('Cash on Delivery'),
              onTap: () => Navigator.pop(sheetContext, 'Cash on Delivery'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );

    if (paymentMethod == null) return;

    if (settings.address.trim().isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add delivery address in Settings first.'),
        ),
      );
      return;
    }

    await orders.placeOrder(
      quantities: cart.items,
      products: cart.products,
      total: cart.total,
      paymentMethod: paymentMethod,
      shippingAddress: settings.address,
    );
    await cart.clearCart();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully.')),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OrdersScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = ResponsiveLayout.of(context);

    return Scaffold(
      appBar: AppBar(title: const SportsLogo(size: 28, showText: false)),
      body: cart.items.isEmpty
          ? Center(
              child: Text(
                'Cart is empty',
                style: theme.textTheme.titleMedium,
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final contentWidth = constraints.maxWidth > responsive.maxContentWidth
                    ? responsive.maxContentWidth
                    : constraints.maxWidth;

                return Center(
                  child: SizedBox(
                    width: contentWidth,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            responsive.pagePadding,
                            10,
                            responsive.pagePadding,
                            8,
                          ),
                          child: SizedBox(
                            height: 108,
                            child: PromoBanner(
                              title: 'Cart Bonus Active',
                              subtitle: 'Add one more item to unlock 10% combo discount.',
                              cta: 'Add More',
                              icon: Icons.sell_outlined,
                              gradient: LinearGradient(
                                colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
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
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.fromLTRB(
                              responsive.pagePadding,
                              2,
                              responsive.pagePadding,
                              2,
                            ),
                            itemCount: cart.products.length,
                            itemBuilder: (_, i) {
                              final p = cart.products[i];
                              final qty = cart.items[p.id]!;

                              return Card(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: LayoutBuilder(
                                    builder: (context, itemConstraints) {
                                      final compact = itemConstraints.maxWidth < 430;

                                      return compact
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 56,
                                                      height: 56,
                                                      child: Image.network(
                                                        p.image,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            p.title,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow.ellipsis,
                                                          ),
                                                          const SizedBox(height: 4),
                                                          Text(
                                                            '₹ ${p.price} x $qty = ₹ ${(p.price * qty).toStringAsFixed(2)}',
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.remove_circle_outline,
                                                      ),
                                                      onPressed: () =>
                                                          cart.decrement(p.id),
                                                    ),
                                                    Text('$qty'),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.add_circle_outline,
                                                      ),
                                                      onPressed: () =>
                                                          cart.increment(p.id),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.delete_outline,
                                                      ),
                                                      onPressed: () =>
                                                          cart.removeFromCart(p.id),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                SizedBox(
                                                  width: 58,
                                                  height: 58,
                                                  child: Image.network(
                                                    p.image,
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        p.title,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        '₹ ${p.price} x $qty = ₹ ${(p.price * qty).toStringAsFixed(2)}',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.remove_circle_outline,
                                                      ),
                                                      onPressed: () =>
                                                          cart.decrement(p.id),
                                                    ),
                                                    Text('$qty'),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.add_circle_outline,
                                                      ),
                                                      onPressed: () =>
                                                          cart.increment(p.id),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.delete_outline,
                                                      ),
                                                      onPressed: () =>
                                                          cart.removeFromCart(p.id),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            responsive.pagePadding,
                            10,
                            responsive.pagePadding,
                            14,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              gradient: AppStyle.cardGradient,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: colorScheme.primary.withValues(alpha: 0.18),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Total (${cart.itemCount} items)',
                                      style: theme.textTheme.titleMedium,
                                    ),
                                    const Spacer(),
                                    Text(
                                      '₹ ${cart.total.toStringAsFixed(2)}',
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  width: double.infinity,
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween(begin: 0.95, end: 1),
                                    duration: const Duration(milliseconds: 380),
                                    curve: Curves.easeOutBack,
                                    builder: (context, value, child) =>
                                        Transform.scale(scale: value, child: child),
                                    child: FilledButton.icon(
                                      onPressed: () => _checkout(context),
                                      icon: const Icon(Icons.sports_score_outlined),
                                      label: const Text('Checkout'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
