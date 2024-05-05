
/*
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 50,
              left: 19,
              child: Text(
                'Foodgo',
                style: TextStyle(
                  fontFamily: 'Lobster',
                  fontSize: 45,
                  fontWeight: FontWeight.w400,
                  height: 60.61 / 45,
                  color: Color(0xFF3C2F2F),
                ),
              ),
            ),
            Positioned(
              top: 110,
              left: 19,
              child: Text(
                'Order your favourite food!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 27 / 18,
                  color: Color(0xFF6A6A6A),
                ),
              ),
            ),
            Positioned(
              top: 163,
              left: 19,
              child: Container(
                width: 279,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 19,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Icon(
                        Icons.search,
                        size: 34,
                        color: Color(0xFF3C2F2F),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 21.09 / 18,
                            color: Color(0xFF3C2F2F),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 163,
              right: 16,
              child: InkWell(
                onTap: () {
                  // Handle icon tap
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFEF2A39),
                  ),
                  child: Icon(
                    Icons.tune_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 240,
              left: 19,
              child: FrameWithButtons(),
            ),
            Positioned(
              top: 320,
              left: 19,
              child: Row(
                children: [
                  CardWidget(
                    imagePath: 'assets/images/cheeseburger.png',
                    title: 'Cheeseburger',
                    subTitle: "Wendy's Burger",
                    rating: 4.9,
                  ),
                  SizedBox(width: 14),
                  CardWidget(
                    imagePath: 'assets/images/hamburger.png',
                    title: 'Hamburger',
                    subTitle: "Veggie's Burger",
                    rating: 4.9,
                  ),
                ],
              ),
            ),
            Positioned(
              top: 355 + 200,
              left: 19,
              child: Row(
                children: [
                  CardWidget(
                    imagePath: 'assets/images/cheeseburger.png',
                    title: 'Cheeseburger',
                    subTitle: "Wendy's Burger",
                    rating: 4.9,
                  ),
                  SizedBox(width: 14),
                  CardWidget(
                    imagePath: 'assets/images/hamburger.png',
                    title: 'Hamburger',
                    subTitle: "Veggie's Burger",
                    rating: 4.9,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FrameWithButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 279,
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CustomButton(
            text: 'All',
            color: Color(0xFFEF2A39),
            textColor: Color(0xFFF5F5F5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Combos',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Sliders',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Classic',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final List<BoxShadow>? boxShadow;

  const CustomButton({
    required this.text,
    required this.color,
    required this.textColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
        boxShadow: boxShadow,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle;
  final double rating;

  const CardWidget({
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      height: 210,
      margin: EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.21),
            blurRadius: 17,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 120,
            height: 100,
            margin: EdgeInsets.only(left: 32, top: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3C2F2F),
                  ),
                ),
                SizedBox(
                    height:
                        2), // Maintain a small space between title and subtitle
                Text(
                  subTitle,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF6A6A6A),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, top: 2),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: Color(0xFFFF9633),
                    ),
                    SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3C2F2F),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 16, top: 2),
                child: Icon(
                  Icons.favorite_outline_outlined,
                  size: 24,
                  color: Color(0xFF3C2F2F),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

*/