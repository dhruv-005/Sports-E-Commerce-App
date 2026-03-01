import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_record.dart';
import '../providers/order_provider.dart';
import '../services/invoice_pdf_service.dart';
import '../widgets/promo_banner.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/sports_logo.dart';
import 'invoice_preview_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final Set<String> _savingInvoices = <String>{};

  Future<void> _downloadInvoice(OrderRecord order) async {
    setState(() => _savingInvoices.add(order.id));

    try {
      final file = await InvoicePdfService.saveInvoicePdf(order);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invoice downloaded: ${file.path}')),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to download invoice PDF.')),
      );
    } finally {
      if (mounted) {
        setState(() => _savingInvoices.remove(order.id));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>().orders;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final responsive = ResponsiveLayout.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const SportsLogo(size: 28, showText: false),
      ),
      body: orders.isEmpty
          ? Center(
              child: Text(
                'No orders yet',
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
                    child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(
                        responsive.pagePadding,
                        10,
                        responsive.pagePadding,
                        14,
                      ),
                      itemCount: orders.length + 1,
                      itemBuilder: (_, i) {
                        if (i == 0) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              height: 108,
                              child: PromoBanner(
                                title: 'Order Protection On',
                                subtitle: 'Every order includes invoice and delivery tracking.',
                                cta: 'Track Orders',
                                icon: Icons.verified_outlined,
                                gradient: LinearGradient(
                                  colors: [Color(0xFF0F766E), Color(0xFF16A34A)],
                                ),
                                onTap: () {
                                  final latest = orders.first;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Latest order ${latest.id} is ${latest.status}.',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }

                        final order = orders[i - 1];
                        final isSaving = _savingInvoices.contains(order.id);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        order.id,
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                    Chip(
                                      label: Text(order.status),
                                      backgroundColor:
                                          colorScheme.primary.withValues(alpha: 0.12),
                                      labelStyle: TextStyle(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Placed: ${order.placedAt.toLocal()}',
                                  style: theme.textTheme.bodySmall,
                                ),
                                Text(
                                  'Payment: ${order.paymentMethod}',
                                  style: theme.textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                ...order.items.map(
                                  (item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text(
                                      '${item.title}  x${item.quantity}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                const Divider(height: 18),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        order.shippingAddress.isEmpty
                                            ? 'Address not set'
                                            : order.shippingAddress,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      '₹ ${order.total.toStringAsFixed(2)}',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                LayoutBuilder(
                                  builder: (context, rowConstraints) {
                                    final compact = rowConstraints.maxWidth < 470;

                                    return compact
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              OutlinedButton.icon(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          InvoicePreviewScreen(
                                                        order: order,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.preview_outlined,
                                                ),
                                                label: const Text('Preview Bill'),
                                              ),
                                              const SizedBox(height: 8),
                                              FilledButton.icon(
                                                onPressed: isSaving
                                                    ? null
                                                    : () => _downloadInvoice(order),
                                                icon: isSaving
                                                    ? const SizedBox(
                                                        width: 14,
                                                        height: 14,
                                                        child:
                                                            CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                      )
                                                    : const Icon(
                                                        Icons.download_outlined,
                                                      ),
                                                label: Text(
                                                  isSaving
                                                      ? 'Downloading...'
                                                      : 'Download PDF',
                                                ),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Expanded(
                                                child: OutlinedButton.icon(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            InvoicePreviewScreen(
                                                          order: order,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.preview_outlined,
                                                  ),
                                                  label: const Text('Preview Bill'),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: FilledButton.icon(
                                                  onPressed: isSaving
                                                      ? null
                                                      : () => _downloadInvoice(order),
                                                  icon: isSaving
                                                      ? const SizedBox(
                                                          width: 14,
                                                          height: 14,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                        )
                                                      : const Icon(
                                                          Icons.download_outlined,
                                                        ),
                                                  label: Text(
                                                    isSaving
                                                        ? 'Downloading...'
                                                        : 'Download PDF',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
