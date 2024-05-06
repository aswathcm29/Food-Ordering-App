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
            top: 460,
            left: 19,
            child: Container(
              width: 168,
              height: 67,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                ),
                color: Colors.green,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF19C08E).withOpacity(0.2),
                    spreadRadius: 0,
                    blurRadius: 13,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 19),
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
                  SizedBox(height: 6),
                  Slider(
                    value: 0.5,
                    onChanged: (newValue) {},
                    min: 0,
                    max: 1,
                    activeColor: Color(0xFF19C08E),
                    inactiveColor: Colors.grey[300],
                  ),
                  SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 19),
                    child: Text(
                      'Hot',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1CC019),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
