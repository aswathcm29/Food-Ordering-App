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
          print(parts);
          return {
            'name': parts[0],
            'imageUrl': parts[2], // Added imageUrl
            'price': double.parse(parts[1]),
            // Added price
          };
        }).toList();
      } else {
        cartItems = []; // Initialize to an empty list if no items are found
      }
    });
  }

  Future<void> _saveCartItems() async {
    List<String> items = cartItems
        .map((item) => '${item['name']}:${item['price']}:${item['imageUrl']}')
        .toList();
    await _prefs.setStringList('cart_items', items);
  }

  Future<void> _clearCart() async {
    await _prefs.remove('cart_items');
    setState(() {
      cartItems.clear();
    });
  }

  Future<void> _orderNow() async {
    // Implement order process logic here
    // For example, you can send the cart items to a server for processing
    print('Order placed! Cart items: $cartItems');

    // After processing the order, you may want to clear the cart
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
                itemCount: cartItems.length, // Ensure cartItems is not null
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
                      subtitle: Text(
                        'Price: \$${cartItems[index]['price'].toStringAsFixed(2)}',
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
