import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/wishlist_provider.dart';
import '../theme/app_style.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final isFavorite = wishlist.isFavorite(widget.product.id);

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 165;
        final imagePadding = isCompact ? 8.0 : 12.0;
        final textPadding = isCompact ? 8.0 : 10.0;

        return GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapCancel: () => setState(() => _pressed = false),
          onTapUp: (_) => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.97 : 1,
            duration: const Duration(milliseconds: 120),
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(20),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: const BoxDecoration(gradient: AppStyle.cardGradient),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Expanded(
                            child: Hero(
                              tag: 'product-image-${widget.product.id}',
                              child: Padding(
                                padding: EdgeInsets.all(imagePadding),
                                child: Image.network(
                                  widget.product.image,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              textPadding,
                              4,
                              textPadding,
                              7,
                            ),
                            child: Text(
                              widget.product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: isCompact ? 13 : 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              textPadding,
                              0,
                              textPadding,
                              10,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '₹ ${widget.product.price}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      color: AppStyle.primary,
                                      fontSize: isCompact ? 13 : 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isCompact ? 7 : 10,
                                    vertical: isCompact ? 5 : 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: AppStyle.accentGradient,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'View',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1F2937),
                                      fontSize: isCompact ? 11.5 : 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => wishlist.toggle(widget.product.id),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.22),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.redAccent : Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
