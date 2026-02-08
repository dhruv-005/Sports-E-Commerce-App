import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("My Cart")),
      body: cart.items.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.products.length,
                    itemBuilder: (_, i) {
                      final p = cart.products[i];
                      final qty = cart.items[p.id]!;
                      return ListTile(
                        leading: Image.network(p.image),
                        title: Text(p.title),
                        subtitle: Text("₹ ${p.price} × $qty"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              cart.removeFromCart(p.id),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Total: ₹ ${cart.total}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text("Checkout"),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

