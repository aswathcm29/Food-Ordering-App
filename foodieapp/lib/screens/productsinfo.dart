import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductInfoPage(),
    );
  }
}

class ProductInfoPage extends StatefulWidget {
  @override
  _ProductInfoPageState createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 37,
            left: 20,
            child: Container(
              width: 370,
              height: 370,
              child: Image.asset(
                'assets/images/hamburger.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 400,
            left: 19,
            child: Text(
              'Hamburger Veggie Burger',
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
            top: 30,
            right: 20,
            child: IconButton(
              icon: Icon(
                Icons.search,
                size: 30,
                color: Color(0xFF3C2F2F),
              ),
              onPressed: () {
                // Implement search functionality here
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
              '4.8',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF808080),
              ),
            ),
          ),
          Positioned(
            top: 438,
            left: 84,
            child: Text(
              '14 mins',
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
              width: 370,
              child: Text(
                'Enjoy our delicious Hamburger Veggie Burger, made with a savory blend of fresh vegetables and herbs, topped with crisp lettuce, juicy tomatoes, and tangy pickles, all served on a soft, toasted bun.',
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
            top: 610,
            left: 0,
            child: Slider(
              value: 0,
              onChanged: (newValue) {},
              min: 0,
              max: 1,
              activeColor: Color(0xFF19C08E),
              inactiveColor: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
