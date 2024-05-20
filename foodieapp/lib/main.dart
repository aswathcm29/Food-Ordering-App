import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:foodieapp/screens/myhomepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    timeDilation = 3.0;

    Future.delayed(Duration(milliseconds: 2000), () {
      timeDilation = 1.0;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0066, 0.9674],
            colors: [
              Color(0xFF19C08E),
              Color(0xFF19C08E),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: 30,
              top: 120,
              child: Text(
                'Foodie',
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
              width: 350,
              height: 355.13,
              top: 111,
              left: 149,
              child: Image.asset(
                'assets/images/cheeseburger.png',
                fit: BoxFit.cover,
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
