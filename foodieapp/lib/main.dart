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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF939B),
              Color(0xFFEF2A39),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 120,
              top: 282,
              child: Text(
                'Foodgo',
                style: TextStyle(
                  fontFamily: 'Lobster',
                  fontSize: 60,
                  fontWeight: FontWeight.w400,
                  height: 1, 
                  color: Colors.white, 
                ),
              ),
            ),
            Positioned(
              width: 246,
              height: 288,
              top: 530,
              left: -42,
              child: Image.asset(
                'assets/images/burger1.png', 
                fit: BoxFit.cover, 
              ),
            ),

            Positioned(
              width: 202,
              height: 202,
              top: 600,
              left: 134,
              child: Image.asset(
                'assets/images/burger2.png', 
                fit: BoxFit.cover, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}



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
      home: HomePage(),
      
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

*/