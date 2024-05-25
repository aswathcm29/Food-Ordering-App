import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:foodieapp/screens/loginscreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? _imageUrl;
  @override
  void initState() {
    super.initState();
    // _loadImageFromPrefs();
  }

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

  void _showErrorToast(String message) {
    MotionToast.error(
      title: Text('Profile Information Added Failed!'),
      description: Text(message),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
      width: 300,
      height: 80,
    ).show(context);
  }

  void _showSucessToast(String message) {
    MotionToast.success(
      title: Text('Profile Information Added Successfully!'),
      description: Text(message),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
      width: 300,
      height: 80,
    ).show(context);
  }

  // Future<void> _loadImageFromPrefs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? imageUrl = prefs.getString('userphoto');
  //   if (imageUrl != null) {
  //     setState(() {
  //       _imageUrl = imageUrl;
  //     });
  //   }
  // }

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
    if (_formKey.currentState!.validate()) {
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
        // if (_imageUrl != null) {
        //   imageUrl = _imageUrl;
        // }

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
        _showSucessToast('Added Successfully!');

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } catch (error) {
        print('Error adding data to Firestore: $error');
        _showErrorToast('Added Failed!');
      }
    }
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return 'Full name should not contain numbers';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your Address';
    }
    return null;
  }

  String? _validateContact(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your contact number';
    }
    if (!RegExp(r'^0\d{10}$').hasMatch(value)) {
      return 'Contact must be 11 digits and start with 0';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Valid Username';
    }
    if (RegExp(r'[0-9]').hasMatch(value)) {
      return 'Username should not contain numbers';
    }

    return null;
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
                        'assets/images/Star.png',
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
                validator: _validateFullName,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: _validateAddress,
              ),
              TextFormField(
                controller: _additionalAddressController,
                decoration: InputDecoration(labelText: 'Additional Address'),
                validator: _validateAddress,
              ),
              TextFormField(
                controller: _contactController,
                decoration: InputDecoration(labelText: 'Contact'),
                validator: _validateContact,
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: _validateUsername,
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

              // if (_imageUrl != null) ...[
              //   _imageUrl!.isNotEmpty
              //       ? kIsWeb
              //           ? Image.network(
              //               _imageUrl!,
              //               height: 200,
              //             )
              //           : Image.network(
              //               _imageUrl!,
              //               height: 200,
              //             )
              //       : Container(),
              // ],

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
