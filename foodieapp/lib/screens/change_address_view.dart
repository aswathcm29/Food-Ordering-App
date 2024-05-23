// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:foodieapp/screens/checkoutview.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kGoogleApiKey =
    "AIzaSyBRm_gVzAusC1Gj84PcYSnZkiV4qPRhzLE"; // Replace with your API key

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeAddressView(),
    );
  }
}

class ChangeAddressView extends StatefulWidget {
  @override
  _ChangeAddressViewState createState() => _ChangeAddressViewState();
}

class _ChangeAddressViewState extends State<ChangeAddressView> {
  final TextEditingController _searchController = TextEditingController();
  GoogleMapController? _mapController;
  LatLng _center = LatLng(31.5497, 73.1369);
  String _errorMessage = '';
  String _address = 'Search for a location or tap on the map';
  final String _apiKey = kGoogleApiKey;
  String? _uid;

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _loadUid();
    
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permissions are denied';
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permissions are permanently denied.';
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _center = LatLng(position.latitude, position.longitude);
      _mapController?.animateCamera(CameraUpdate.newLatLngZoom(_center, 12));
      _updateAddress(_center);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to determine position: $e';
      });
    }
  }

  Future<void> _loadUid() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _uid = prefs.getString('uid');
    });
    print(_uid);
  }

  Future<void> _updateAddress(LatLng position) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          String address = data['results'][0]['formatted_address'];
          setState(() {
            _address = address;
          });
          print('Address: $address');
        } else {
          setState(() {
            _errorMessage = 'No address found';
          });
        }
      } else {
        setState(() {
          _errorMessage =
              'Error occurred while fetching address: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error occurred while fetching address: $e';
      });
    }
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _center = position;
    });
    _updateAddress(position);
  }

  void _showSaveAddressDialog(BuildContext context) {
    TextEditingController addressController = TextEditingController();
    addressController.text = _address;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Address'),
          content: TextField(
            controller: addressController,
            decoration: InputDecoration(
              hintText: 'Enter address',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Replace with actual user ID
                setState(() {
                  _address = addressController.text;
                  _saveAddress(_uid!, _address);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text("Address saved: ${addressController.text}")),
                );
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveAddress(String uid, String address) async {
    try {
      await FirebaseFirestore.instance.collection('UserData').doc(uid).set({
        'address': address,
      }, SetOptions(merge: true));

      print('Address saved successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Address saved successfully"),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to order page after a short delay
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context, address);
      });
    } catch (e) {
      print('Failed to save address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change Address"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text(
              "Change Address",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                  _determinePosition();
                },
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 12.0,
                ),
                onTap: _onMapTapped,
                markers: {
                  Marker(
                    markerId: MarkerId("liveLocation"),
                    position: _center,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueRed),
                  ),
                },
              ),
            ),
            if (_errorMessage.isNotEmpty) ...[
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 10),
            ],
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_address),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _showSaveAddressDialog(context),
                child: Text("Save Address"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
