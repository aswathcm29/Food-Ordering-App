// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodieapp/screens/loginscreen.dart';
import 'package:foodieapp/screens/userinfo.dart';
import 'package:motion_toast/motion_toast.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  bool _isPasswordVisible = false;

  void _showErrorToast(String message) {
    MotionToast.error(
      title: Text('Signup Failed'),
      description: Text(message),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
      width: 300,
      height: 80,
    ).show(context);
  }

  void _showSucessToast(String message) {
    MotionToast.success(
      title: Text('Signup Successful'),
      description: Text(message),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
      width: 300,
      height: 80,
    ).show(context);
  }

  void SignupHandler() async {
    // Get the entered data

    // String name = _nameController.text;

    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    // You can add your signup logic here

    // Print the entered data
    // print('Name: $name');

    if (password != confirmPassword) {
      print('Passwords do not match');
      _showErrorToast('Passwords do not match');
      return;
    } else {
      print('Email: $email');
      print('Password: $password');
      print('Confirm Password: $confirmPassword');
      try {
        final newUser = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        _showSucessToast("Signup Successful");

        if (newUser.user != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    userinfo(email: email, uid: newUser.user!.uid)),
          );
        } else {
          print('User not created');
        }
        // print(newUser);
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
  }

  @override
  void initState() {
    super.initState();
    // _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // TextField(
            //   // controller: _nameController,
            //   decoration: InputDecoration(
            //     labelText: 'Name',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
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
                      'assets/images/star.png',
                      height: 45,
                      width: 45,
                    ),
                  ],
                ),
              ),
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
                'Signup',
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
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('Existing User? Login'),
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
                    SignupHandler();
                  },
                  child: Text('Sign Up'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
