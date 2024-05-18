// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodieapp/screens/loginscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'dart:io';
import 'dart:html' as html;

class userinfo extends StatefulWidget {
  final String email;
  final String uid;

  userinfo({
    Key? key,
    required this.email,
    required this.uid,
  }) : super(key: key);

  @override
  State<userinfo> createState() => _userinfoState();
}

class _userinfoState extends State<userinfo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _additionalAddressController =
      TextEditingController();

  XFile? _pickedFile;
  File? _imageFile;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    try {
      XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _pickedFile = pickedFile;
          if (!kIsWeb) {
            _imageFile = File(pickedFile.path);
          }
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<String> _uploadImage(XFile image) async {
    try {
      String fileName = '${widget.uid}.png';
      Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_images/$fileName');
      UploadTask uploadTask =
          storageReference.putData(await image.readAsBytes());
      await uploadTask.whenComplete(() => null);
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }

  Future<void> _saveToFirestore() async {
    String fullName = _fullNameController.text;
    String address = _addressController.text;
    String contact = _contactController.text;
    String username = _usernameController.text;
    String additionalAddress = _additionalAddressController.text;

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      String? imageUrl;
      if (_pickedFile != null) {
        imageUrl = await _uploadImage(_pickedFile!);
      }

      await firestore.collection('UserData').doc(widget.uid).set({
        'email': widget.email,
        'fullName': fullName,
        'address': address,
        'contact': contact,
        'username': username,
        'additionalAddress': additionalAddress,
        'profileImage': imageUrl,
      });

      print('Data added to Firestore');

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (error) {
      print('Error adding data to Firestore: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Input Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
                  'Personal Information',
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
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: _additionalAddressController,
                decoration: InputDecoration(labelText: 'Additional Address'),
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact'),
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
                ),
                onPressed: _pickImage,
                child: Text('Select Profile Image'),
              ),
              _pickedFile != null
                  ? kIsWeb
                      ? Image.network(
                          _pickedFile!.path,
                          height: 200,
                        )
                      : Image.file(
                          _imageFile!,
                          height: 200,
                        )
                  : Container(),
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
                    onPressed: _saveToFirestore,
                    child: Text('Save Data'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
