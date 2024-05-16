import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToCart extends StatefulWidget {
  const AddToCart({Key? key}) : super(key: key);

  @override
  _AddToCartState createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  List<Map<String, dynamic>> cartItems = [];
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _saveCartItems(); // Save cart items when the widget is disposed
    super.dispose();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    setState(() {
      List<String>? items = _prefs.getStringList('cart_items');
      if (items != null) {
        cartItems = items.map((item) {
          var parts = item.split(':');
          return {
            'name': parts[0],
            'imageUrl': parts[2], // Added imageUrl
            'price': double.parse(parts[1]),
            'quantity': 1, // Initial quantity is 1
          };
        }).toList();
      } else {
        cartItems = []; // Initialize to an empty list if no items are found
      }
    });
  }

  Future<void> _saveCartItems() async {
    List<String> items = cartItems
        .map((item) =>
            '${item['name']}:${item['price']}:${item['imageUrl']}:${item['quantity']}')
        .toList();
    await _prefs.setStringList('cart_items', items);
  }

  Future<void> _clearCart() async {
    await _prefs.remove('cart_items');
    setState(() {
      cartItems.clear();
    });
  }

  double _calculateTotalPrice() {
    double totalPrice = 0;
    for (var item in cartItems) {
      totalPrice += item['price'] * item['quantity'];
    }
    return totalPrice;
  }

  Future<void> _orderNow() async {
    final checkAuth = _prefs.getString("auth");
    if (checkAuth == "true") {
      print('Order placed! Cart items: $cartItems');
    } else {
      print("Login First");
      return;
    }
    await _clearCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Cart Items',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Image.network(
                        cartItems[index]['imageUrl'],
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(cartItems[index]['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price: \$${cartItems[index]['price'].toStringAsFixed(2)}',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF19C08E),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF99004F).withOpacity(0.5),
                                      offset: Offset(0, 7),
                                      blurRadius: 13,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                width: 40,
                                height: 40,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      cartItems[index]['quantity']--;
                                      _saveCartItems();
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      "-",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                                //  FloatingActionButton(
                                //   shape: const CircleBorder(),
                                //   onPressed: () {
                                //     setState(() {
                                //       cartItems[index]['quantity']--;
                                //       _saveCartItems();
                                //     });
                                //   },
                                //   child: Center(
                                //     child: Icon(
                                //       Icons.minimize,
                                //       size: 20,
                                //     ),
                                //   ),
                                // ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('${cartItems[index]['quantity']}'),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF19C08E),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFF99004F).withOpacity(0.5),
                                      offset: Offset(0, 7),
                                      blurRadius: 13,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                width: 40,
                                height: 40,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      cartItems[index]['quantity']++;
                                      _saveCartItems();
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      "+",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                                //  FloatingActionButton(
                                //   shape: const CircleBorder(),
                                //   onPressed: () {
                                //     setState(() {
                                //       cartItems[index]['quantity']--;
                                //       _saveCartItems();
                                //     });
                                //   },
                                //   child: Center(
                                //     child: Icon(
                                //       Icons.minimize,
                                //       size: 20,
                                //     ),
                                //   ),
                                // ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.remove_shopping_cart),
                        onPressed: () {
                          setState(() {
                            cartItems.removeAt(index);
                            _saveCartItems();
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total Price: \$${_calculateTotalPrice().toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _clearCart();
                  },
                  child: Text('Clear Cart'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _orderNow();
                  },
                  child: Text('Order Now'),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
