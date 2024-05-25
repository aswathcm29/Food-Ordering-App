import 'package:flutter/material.dart';
import 'package:foodieapp/screens/addtocart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductInfoPage extends StatefulWidget {
  final String imagePath;
  final String title;
  final double rating;
  final String subTitle;
  final String price;

  const ProductInfoPage({
    required this.imagePath,
    required this.title,
    required this.rating,
    required this.subTitle,
    required this.price,
  });

  @override
  _ProductInfoPageState createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  double _sliderValue = 0.5;
  int count = 1;

  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    if (count > 1) {
      setState(() {
        count--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 70,
            left: 19,
            child: Container(
              width: 320,
              height: 320,
              child: Image.network(
                widget.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 400,
            left: 19,
            child: Text(
              widget.title,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3C2F2F),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: Color(0xFF3C2F2F),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 440,
            left: 19,
            child: Icon(
              Icons.star,
              color: Color(0xFFFF9633),
              size: 16.08,
            ),
          ),
          Positioned(
            top: 448,
            left: 68,
            child: Container(
              width: 10,
              height: 0,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 2.0, color: Color(0xFFA9A9A9)),
                ),
              ),
            ),
          ),
          Positioned(
            top: 438,
            left: 40,
            child: Text(
              widget.rating.toString(),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF808080),
              ),
            ),
          ),
          Positioned(
            top: 470,
            left: 19,
            child: Container(
              width: 340,
              child: Text(
                'Enjoy our delicious ${widget.title}, made with a savory blend of fresh vegetables and herbs, topped with crisp lettuce, juicy tomatoes.',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF6A6A6A),
                ),
              ),
            ),
          ),
          Positioned(
            top: 600,
            left: 19,
            child: Container(
              width: 40,
              height: 19,
              child: Text(
                'Spicy',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3C2F2F),
                ),
              ),
            ),
          ),
          Positioned(
            top: 615,
            left: 0,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 12.0,
                ),
                overlayShape: RoundSliderOverlayShape(
                  overlayRadius: 20.0,
                ),
              ),
              child: Slider(
                value: _sliderValue,
                onChanged: (newValue) {
                  setState(() {
                    _sliderValue = newValue;
                  });
                },
                min: 0,
                max: 1,
                activeColor: Color(0xFF19C08E),
                inactiveColor: Colors.grey[300],
              ),
            ),
          ),
          Positioned(
            top: 650,
            left: 19,
            child: Container(
              width: 40,
              height: 19,
              child: Text(
                'Mild',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1CC019),
                ),
              ),
            ),
          ),
          Positioned(
            top: 650,
            left: 150,
            child: Container(
              width: 40,
              height: 19,
              child: Text(
                'Hot',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF19C08E),
                ),
              ),
            ),
          ),
          Positioned(
            top: 600,
            left: 240,
            child: Container(
              width: 60,
              height: 19,
              child: Text(
                'Quantity',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3C2F2F),
                ),
              ),
            ),
          ),
          Positioned(
            top: 625,
            left: 240,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: count > 1 ? Color(0xFF19C08E) : Colors.red,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF99004F).withOpacity(0.5),
                    offset: Offset(0, 7),
                    blurRadius: 13,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: InkWell(
                onTap: count > 1 ? decrement : null,
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
            ),
          ),
          Positioned(
            top: 625,
            left: 310,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFF19C08E),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF99004F).withOpacity(0.5),
                    offset: Offset(0, 7),
                    blurRadius: 13,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: InkWell(
                onTap: increment,
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
            ),
          ),
          Positioned(
            top: 625,
            left: 275,
            child: Container(
              width: 40,
              height: 40,
              child: Center(
                child: Text(
                  "$count",
                  style: TextStyle(
                    color: Color(0xFF3C2F2F),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 690,
            left: 19,
            child: Container(
              width: 104,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF19C08E),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(0.4),
                    offset: Offset(0, 9),
                    blurRadius: 30,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  widget.price,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 690,
            left: 170,
            child: Container(
              width: 180,
              height: 60,
              decoration: BoxDecoration(
                color: Color(0xFF3C2F2F),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF000000).withOpacity(0.4),
                    offset: Offset(0, 9),
                    blurRadius: 30,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: TextButton(
                  onPressed: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    List<String>? cartItems = prefs.getStringList('cart_items') ?? [];
                    String itemInfo = '${widget.title}#${widget.price}#${widget.imagePath}#$count';

                    int existingIndex = cartItems.indexWhere((item) => item.split('#')[0] == widget.title);

                    if (existingIndex != -1) {
                      List<String> existingItemParts = cartItems[existingIndex].split('#');
                      int existingCount = int.parse(existingItemParts[3]);
                      existingItemParts[3] = (existingCount + count).toString();
                      cartItems[existingIndex] = existingItemParts.join('#');
                    } else {
                      cartItems.add(itemInfo);
                    }

                    await prefs.setStringList('cart_items', cartItems);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddToCart()),
                    );
                  },
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 238, 204, 204),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
