import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Utils {
  static String formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static String formatDate(DateTime date) => DateFormat.yMd().format(date);
}

class InvoicePage extends StatelessWidget {
  final List<InvoiceItem> items = [
    InvoiceItem(
      description: 'Coffee',
      date: DateTime.now(),
      quantity: 3,
      vat: 0.19,
      unitPrice: 5.99,
    ),
    // Add more items as needed...
  ];

  final InvoiceInfo invoiceInfo = InvoiceInfo(
    description: 'First Order Invoice',
    date: DateTime.now(),
    dueDate: DateTime.now().add(Duration(days: 7)),
  );

  final Supplier supplier = Supplier(
    name: 'Foodie-Food Order',
    address: '',
    paymentInfo: 'Cash On Delivery',
  );

  final Customer customer = Customer(
    name: 'Google',
    email: 'contact@google.com',
    address: 'Mountain View, California, United States',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(
                color: Colors.grey[400]!,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'Foodie',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 40,
                      fontWeight: FontWeight.w400,
                      height: 1,
                      color: Color(0xFF6A6A6A),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                buildInfoCard(),
                SizedBox(height: 10),
                buildItemsTable(),
                SizedBox(height: 10),
                buildTotal(),
                SizedBox(height: 10),
                buildContactInfo(),
                SizedBox(height: 10),
                buildDownloadButton(context),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Invoice Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.description, color: Colors.blue),
              ],
            ),
            SizedBox(height: 10),
            Text('Invoice Number: ${invoiceInfo.getInvoiceNumber()}'),
            Text('Invoice Date: ${Utils.formatDate(invoiceInfo.date)}'),
            Text('Due Date: ${Utils.formatDate(invoiceInfo.dueDate)}'),
            SizedBox(height: 10),
            Text(
              'Description: ${invoiceInfo.description}',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemsTable() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Items',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.shopping_cart, color: Colors.green),
              ],
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Unit Price')),
                  DataColumn(label: Text('Total')),
                ],
                rows: items
                    .map((item) => DataRow(
                          cells: [
                            DataCell(Text(item.description)),
                            DataCell(Text(item.quantity.toString())),
                            DataCell(Text(Utils.formatPrice(item.unitPrice))),
                            DataCell(Text(Utils.formatPrice(item.unitPrice *
                                item.quantity *
                                (1 + item.vat)))),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTotal() {
    double netTotal = 0;
    double vatTotal = 0;

    items.forEach((item) {
      netTotal += item.unitPrice * item.quantity;
      vatTotal += item.unitPrice * item.quantity * item.vat;
    });

    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.monetization_on, color: Colors.orange),
              ],
            ),
            SizedBox(height: 10),
            Text('Net Total: ${Utils.formatPrice(netTotal)}'),
            Divider(),
            Text(
              'Total Amount Due: ${Utils.formatPrice(netTotal + vatTotal)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContactInfo() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customer Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.contact_mail, color: Colors.red),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.person, color: Colors.blue),
                SizedBox(width: 10),
                Text('Customer Name: ${customer.name}'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.email, color: Colors.blue),
                SizedBox(width: 10),
                Text('Customer Email: ${customer.email}'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Customer Address: ${customer.address}',
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDownloadButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        final pdf = await generatePdf();
        await Printing.sharePdf(bytes: pdf, filename: 'invoice.pdf');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading receipt...')),
        );
      },
      icon: Icon(Icons.download_rounded),
      label: Text('Download Receipt'),
    );
  }

  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();

    final netTotal = items.fold(
        0.0, (double sum, item) => sum + item.unitPrice * item.quantity);
    final vatTotal = items.fold(0.0,
        (double sum, item) => sum + item.unitPrice * item.quantity * item.vat);

    // Load font
    final fontData = await rootBundle.load('assets/fonts/roboto/Roboto-Regular.ttf');
    final ttf = pw.Font.ttf(fontData.buffer.asByteData());
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'Foodie',
              style: pw.TextStyle(
                font: ttf,
                fontSize: 40,
                color: PdfColors.blue,
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Invoice Information',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text('Invoice Number: ${invoiceInfo.getInvoiceNumber()}'),
            pw.Text('Invoice Date: ${Utils.formatDate(invoiceInfo.date)}'),
            pw.Text('Due Date: ${Utils.formatDate(invoiceInfo.dueDate)}'),
            pw.SizedBox(height: 10),
            pw.Text(
              'Description: ${invoiceInfo.description}',
              style: pw.TextStyle(fontStyle: pw.FontStyle.italic),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Items',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Table.fromTextArray(
              headers: ['Description', 'Quantity', 'Unit Price', 'Total'],
              data: items.map((item) {
                final total = item.unitPrice * item.quantity * (1 + item.vat);
                return [
                  item.description,
                  item.quantity.toString(),
                  Utils.formatPrice(item.unitPrice),
                  Utils.formatPrice(total),
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Total Amount',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text('Net Total: ${Utils.formatPrice(netTotal)}'),
            pw.Divider(),
            pw.Text(
              'Total Amount Due: ${Utils.formatPrice(netTotal + vatTotal)}',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),
            pw.Text(
              'Customer Information',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text('Customer Name: ${customer.name}'),
            pw.Text('Customer Email: ${customer.email}'),
            pw.Text('Customer Address: ${customer.address}', softWrap: true),
          ],
        ),
      ),
    );

    return pdf.save();
  }
}

class Customer {
  final String name;
  final String email;
  final String address;

  Customer({
    required this.name,
    required this.email,
    required this.address,
  });
}

class InvoiceInfo {
  final String description;
  final DateTime date;
  final DateTime dueDate;

  InvoiceInfo({
    required this.description,
    required this.date,
    required this.dueDate,
  });

  String getInvoiceNumber() {
    return 'INV-${DateTime.now().millisecondsSinceEpoch}';
  }
}

class InvoiceItem {
  final String description;
  final DateTime date;
  final int quantity;
  final double vat;
  final double unitPrice;

  InvoiceItem({
    required this.description,
    required this.date,
    required this.quantity,
    required this.vat,
    required this.unitPrice,
  });
}

class Supplier {
  final String name;
  final String address;
  final String paymentInfo;

  Supplier({
    required this.name,
    required this.address,
    required this.paymentInfo,
  });
}
