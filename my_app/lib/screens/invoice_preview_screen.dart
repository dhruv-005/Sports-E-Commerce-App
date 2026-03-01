import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../models/order_record.dart';
import '../services/invoice_pdf_service.dart';

class InvoicePreviewScreen extends StatelessWidget {
  final OrderRecord order;

  const InvoicePreviewScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invoice ${order.id}')),
      body: PdfPreview(
        canDebug: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        build: (_) => InvoicePdfService.buildInvoicePdf(order),
      ),
    );
  }
}
