// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Stream<QuerySnapshot>? _ordersStream;

  @override
  void initState() {
    super.initState();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid');

    if (userId != null) {
      setState(() {
        _ordersStream = FirebaseFirestore.instance
            .collection('Order')
            .where('Order By', isEqualTo: userId)
            .snapshots();
      });
    } else {
      print('User ID not found');
      
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'pending':
        return Colors.red;
      case 'ondelivery':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: _ordersStream == null
          ? Center(child: Center(child: Text('No orders available')))
          : StreamBuilder<QuerySnapshot>(
              stream: _ordersStream!,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final orders = snapshot.data!.docs;

                if (orders.isEmpty) {
                  return Center(child: Text('No orders available'));
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    var order = orders[index];
                    var orderData = order.data() as Map<String, dynamic>;

                    // Customizing the design of each card
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(
                                'Order Date: ${orderData['date'] != null ? (orderData['date'] as Timestamp).toDate() : 'Unknown'}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Order Status: ${orderData['status'] ?? 'Unknown'}',
                                style: TextStyle(
                                  color: _getStatusColor(
                                      orderData['status'] ?? 'Unknown'),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                'Order Total: \$${orderData['total(after discount and deliverycost)'] ?? '0.00'}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(height: 1, color: Colors.grey),
                            SizedBox(height: 8.0),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Products:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Column(
                              children:
                                  (orderData['products'] as List<dynamic>? ??
                                          [])
                                      .map<Widget>((product) {
                                List<String> productDetails =
                                    product.split('#');
                                String name = productDetails[0];
                                int quantity =
                                    int.tryParse(productDetails[3]) ?? 1;
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('Quantity: $quantity'),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 8.0),
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
