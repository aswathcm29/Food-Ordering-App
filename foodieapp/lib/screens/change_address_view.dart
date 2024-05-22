import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final String _apiKey =
      'AIzaSyBRm_gVzAusC1Gj84PcYSnZkiV4qPRhzLE'; // Add your Google API key

  @override
  void initState() {
    super.initState();
    _determinePosition();
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

  // Future<void> _showSaveAddressDialog(BuildContext context) async {
  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Save Address'),
  //         content: TextField(
  //           controller: _addressController,
  //           decoration: InputDecoration(
  //             hintText: 'Enter address',
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               // Save the address
  //               String address = _addressController.text;
  //               // Implement saving logic here
  //               // For demonstration, print the address
  //               print('Saved Address: $address');
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Save'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _onMapTapped(LatLng position) {
    setState(() {
      _center = position;
    });
    _updateAddress(position);
  }

  // Future<List<String>> _fetchSuggestions(String query) async {
  //   try {
  //     print('Fetching suggestions for query: $query');

  //     String url =
  //         'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$_apiKey';
  //     final response = await http.get(Uri.parse(url), headers: {
  //       'Content-Type': 'application/json',
  //       "Access-Control-Allow-Origin": "*",
  //       "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
  //     });
  //     print(response);
  //     if (response.statusCode == 200) {
  //       final suggestions = json.decode(response.body)['predictions'];
  //       return List<String>.from(suggestions.map((p) => p['description']));
  //     } else {
  //       throw Exception('Failed to load suggestions');
  //     }
  //   } catch (e) {
  //     print(e);
  //     return [];
  //   }
  // }

  // Future<void> _searchLocation(String selectedPlace) async {
  //   print("Hi");
  //   String url =
  //       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$selectedPlace&key=$_apiKey';
  //   final response = await http.get(Uri.parse(url), headers: {
  //     'Content-Type': 'application/json',
  //     "Access-Control-Allow-Origin": "*",
  //     "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
  //   });
  //   print(response);
  //   if (response.statusCode == 200) {
  //     final details = json.decode(response.body)['result'];
  //     final lat = details['geometry']['location']['lat'];
  //     final lng = details['geometry']['location']['lng'];
  //     LatLng newCenter = LatLng(lat, lng);
  //     setState(() {
  //       _center = newCenter;
  //       _errorMessage = '';
  //       _address = details['formatted_address'];
  //     });
  //     _mapController?.animateCamera(CameraUpdate.newLatLngZoom(newCenter, 12));
  //   } else {
  //     setState(() {
  //       _errorMessage = 'No location found';
  //     });
  //   }
  // }

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
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Autocomplete<String>(
            //     optionsBuilder: (TextEditingValue textEditingValue) async {
            //       if (textEditingValue.text.isEmpty) {
            //         return const Iterable<String>.empty();
            //       }
            //       try {
            //         final suggestions =
            //             await _fetchSuggestions(textEditingValue.text);
            //         return suggestions;
            //       } catch (e) {
            //         // Handle error
            //         return const Iterable<String>.empty();
            //       }
            //     },
            //     onSelected: (String selectedPlace) {
            //       _searchLocation(selectedPlace);
            //     },
            //     fieldViewBuilder: (BuildContext context,
            //         TextEditingController textEditingController,
            //         FocusNode focusNode,
            //         VoidCallback onFieldSubmitted) {
            //       return TextField(
            //         controller: textEditingController,
            //         focusNode: focusNode,
            //         decoration: InputDecoration(
            //           hintText: 'Enter location or coordinates',
            //           border: OutlineInputBorder(),
            //         ),
            //         onChanged: (value) {
            //           // You can perform additional actions when the text changes
            //         },
            //         onSubmitted: (value) {
            //           onFieldSubmitted();
            //         },
            //       );
            //     },
            //     optionsViewBuilder: (BuildContext context,
            //         AutocompleteOnSelected<String> onSelected,
            //         Iterable<String> options) {
            //       return Align(
            //         alignment: Alignment.topLeft,
            //         child: Material(
            //           elevation: 4.0,
            //           child: SizedBox(
            //             height: 200.0,
            //             child: ListView(
            //               children: options
            //                   .map((String option) => ListTile(
            //                         title: Text(option),
            //                         onTap: () {
            //                           onSelected(option);
            //                         },
            //                       ))
            //                   .toList(),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_address),
            ),
          ],
        ),
      ),
    );
  }
}
