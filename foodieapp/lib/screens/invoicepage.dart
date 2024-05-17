
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



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

  // InvoiceInfo class with a method to generate invoice number dynamically
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
    address: 'Mountain View, California, United States',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice'),
      ),
      body: SingleChildScrollView(
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
            Text('Invoice Number: ${invoiceInfo.getInvoiceNumber()}'), // Dynamically fetch invoice number
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
            DataTable(
              columns: [
                DataColumn(label: Text('Description')),
                DataColumn(label: Text('Quantity')),
                DataColumn(label: Text('Unit Price')),
                DataColumn(label: Text('Total')),
              ],
              rows: items.map((item) => DataRow(
                cells: [
                  DataCell(Text(item.description)),
                  DataCell(Text(item.quantity.toString())),
                  DataCell(Text(Utils.formatPrice(item.unitPrice))),
                  DataCell(Text(Utils.formatPrice(item.unitPrice * item.quantity * (1 + item.vat)))),
                ],
              )).toList(),
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
                  'Contact Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.contact_mail, color: Colors.red),
              ],
            ),
            SizedBox(height: 10),
            Text('Company/Organization: ${supplier.name}'),
            Text('Address: ${supplier.address}'),
            Text('Email: ${supplier.paymentInfo}'),
            SizedBox(height: 10),
            Text(
              'Customer: ${customer.name}',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Text('Customer Address: ${customer.address}'),
          ],
        ),
      ),
    );
  }

  Widget buildDownloadButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        // Implement download functionality here
        // Example: Generate and download PDF or any other format
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloading receipt...')),
        );
      },
      icon: Icon(Icons.download_rounded),
      label: Text('Download Receipt'),
    );
  }
}

class Customer {
  final String name;
  final String address;

  Customer({
    required this.name,
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
    //return '${DateTime.now().year}-9999'; 
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