import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/order_record.dart';

class InvoicePdfService {
  static Future<Uint8List> buildInvoicePdf(OrderRecord order) async {
    final pdf = pw.Document();
    final subtotal = order.items.fold<double>(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Text(
            'Sports Accessories Store',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text('Order Invoice'),
          pw.SizedBox(height: 16),
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey400),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Order ID: ${order.id}'),
                pw.Text('Placed At: ${_formatDateTime(order.placedAt)}'),
                pw.Text('Payment: ${order.paymentMethod}'),
                pw.Text('Status: ${order.status}'),
                pw.Text(
                  'Shipping: ${order.shippingAddress.isEmpty ? 'Address not set' : order.shippingAddress}',
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headers: const [
              'Item',
              'Qty',
              'Unit Price',
              'Total',
            ],
            data: order.items
                .map(
                  (item) => [
                    item.title,
                    '${item.quantity}',
                    _money(item.price),
                    _money(item.price * item.quantity),
                  ],
                )
                .toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 6,
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(4),
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
            },
          ),
          pw.SizedBox(height: 20),
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Container(
              width: 220,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey400),
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  _totalRow('Subtotal', subtotal),
                  pw.SizedBox(height: 6),
                  _totalRow('Total', order.total, isStrong: true),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Thank you for your purchase.',
            style: const pw.TextStyle(color: PdfColors.grey700),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static Future<File> saveInvoicePdf(OrderRecord order) async {
    final dir = await getApplicationDocumentsDirectory();
    final safeId = order.id.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');
    final path = '${dir.path}/invoice_$safeId.pdf';

    final bytes = await buildInvoicePdf(order);
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  static pw.Widget _totalRow(String label, double amount, {bool isStrong = false}) {
    final style = pw.TextStyle(
      fontSize: isStrong ? 13 : 11,
      fontWeight: isStrong ? pw.FontWeight.bold : pw.FontWeight.normal,
    );

    return pw.Row(
      children: [
        pw.Expanded(child: pw.Text(label, style: style)),
        pw.Text(_money(amount), style: style),
      ],
    );
  }

  static String _money(double value) => 'INR ${value.toStringAsFixed(2)}';

  static String _formatDateTime(DateTime dateTime) {
    final d = dateTime.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}';
  }
}
