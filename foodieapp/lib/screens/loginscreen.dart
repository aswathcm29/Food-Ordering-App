// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/screens/userinfo.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:foodieapp/screens/myhomepage.dart';
import 'package:foodieapp/screens/signupscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:motion_toast/motion_toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isPasswordVisible = false;

  Future<void> _storeUid(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setString('thirdpartyauth', 'false');
    await prefs.setString('userphoto', '');
  }

  void _showErrorToast(String message) {
    MotionToast.error(
      title: Text('Login Failed'),
      description: Text(message),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
      width: 300,
      height: 80,
    ).show(context);
  }

  void LoginHandler() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    print('Email: $email');
    print('Password: $password');

    try {
      final loginUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (loginUser.user != null) {
        print('User logged in');
        print(loginUser);

        // Store UID
        await _storeUid(loginUser.user!.uid);

        // Show login success notification with email
        MotionToast.success(
          title: Text('Login Successful'),
          description: Text('Logged in as $email'),
          animationType: AnimationType.fromTop,
          position: MotionToastPosition.top,
          width: 300,
          height: 80,
        ).show(context);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
      } else {
        print('User not logged in');
      }
    } on FirebaseAuthException catch (e) {
      // print(e.code);
      _showErrorToast(e.code);
      // if (e.code == 'user-not-found') {
      //   _showErrorToast('No user found for that email.');
      // } else if (e.code == 'wrong-password') {
      //   _showErrorToast('Wrong password provided.');
      // } else if (e.code == 'invalid-email') {
      //   _showErrorToast('The email address is not valid.');
      // } else {
      //   _showErrorToast('An error occurred. Please try again.');
      // }
      print(e);
    }
  }

  // Future<void> _signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) {
  //       // The user canceled the sign-in
  //       return;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final UserCredential userCredential =
  //         await FirebaseAuth.instance.signInWithCredential(credential);

  //     if (userCredential.user != null) {
  //       // Store UID
  //       await _storeUid(userCredential.user!.uid);

  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => MyHomePage()));
  //     }
  //   } catch (e) {
  //     print(e);
  //     _showErrorToast('Google sign-in failed. Please try again.');
  //   }
  // }
  Future<void> _signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final prefs = await SharedPreferences.getInstance();

      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        // Store UID
        await _storeUid(userCredential.user!.uid);

        // Print user information
        print('User logged in with Google:');
        print('UID: ${userCredential.user!.uid}');
        print('Name: ${userCredential.user!.displayName}');
        print('Email: ${userCredential.user!.email}');
        print('Photo URL: ${userCredential.user!.photoURL}');
        // await prefs.setString('uid', userCredential.user!.uid);
        await prefs.setString('thirdpartyauth', 'true');
        await prefs.setString('userphoto', '${userCredential.user!.photoURL}');

        // Check if user exists in Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('UserData')
            .doc(userCredential.user!.uid)
            .get();
        print(userDoc);

        if (userDoc.exists) {
          // Navigate to homepage if user exists
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyHomePage()));
        } else {
          // Navigate to user info page if user does not exist
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => userinfo(
                    email: userCredential.user!.email!,
                    uid: userCredential.user!.uid)),
          );
        }
      }
    } catch (e) {
      print('Error signing in with Google: $e');
      _showErrorToast('Google sign-in failed. Please try again.');
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/Star.png',
                          height: 45,
                          width: 45,
                        ),
                      ],
                    )),
              ),
              SizedBox(height: 20),
              Text(
                'Foodie',
                style: TextStyle(
                  fontFamily: 'Lobster',
                  fontSize: 45,
                  fontWeight: FontWeight.w400,
                  height: 60.61 / 45,
                  color: Color(0xFF3C2F2F),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Text(
                  'Login',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "poppins",
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    height: 60.61 / 45,
                    color: Color(0xFF3C2F2F),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 40),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text('New User? Sign Up'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    onPressed: () {
                      LoginHandler();
                    },
                    child: Text('Login'),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("OR"),
              SizedBox(height: 20),
              SignInButton(
                Buttons.google,
                onPressed: _signInWithGoogle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
