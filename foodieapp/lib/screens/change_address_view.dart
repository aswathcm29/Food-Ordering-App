// import 'package:custom_map_markers/custom_map_markers.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:foodieapp/screens/color_extension.dart';
// import 'package:foodieapp/screens/round_textfield.dart';


// class ChangeAddressView extends StatefulWidget {
//   const ChangeAddressView({Key? key}) : super(key: key);

//   @override
//   State<ChangeAddressView> createState() => _ChangeAddressViewState();
// }

// class _ChangeAddressViewState extends State<ChangeAddressView> {
//   final locations = const [
//     LatLng(37.42796133580664, -122.085749655962),
//   ];

//   late List<MarkerData> _customMarkers;

//   static const CameraPosition _kLake = CameraPosition(
//     bearing: 192.8334901395799,
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.151926040649414,
//   );

//   @override
//   void initState() {
//     super.initState();
//     _customMarkers = [
//       MarkerData(
//         marker: Marker(
//           markerId: const MarkerId('id-1'),
//           position: locations[0],
//         ),
//         child: _customMarker('Everywhere\nis a Widgets', Colors.blue),
//       ),
//     ];
//   }

//   Widget _customMarker(String symbol, Color color) {
//     return SizedBox(
//       width: 100,
//       child: Column(
//         children: [
//           Image.asset(
//             'assets/images/map_pin.png',
//             width: 35,
//             fit: BoxFit.contain,
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: TColor.white,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Image.asset("assets/images/btn_back.png", width: 20, height: 20),
//         ),
//         centerTitle: false,
//         title: Text(
//           "Change Address",
//           style: TextStyle(
//             color: TColor.primaryText,
//             fontSize: 20,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Expanded(
//             child: CustomGoogleMapMarkerBuilder(
//               customMarkers: _customMarkers,
//               builder: (BuildContext context, Set<Marker>? markers) {
//                 if (markers == null) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 return GoogleMap(
//                   mapType: MapType.normal,
//                   initialCameraPosition: _kLake,
//                   compassEnabled: false,
//                   gestureRecognizers: Set()
//                     ..add(Factory<PanGestureRecognizer>(
//                       () => PanGestureRecognizer(),
//                     )),
//                   markers: markers,
//                   onMapCreated: (_) {}, // Use a dummy callback if controller is not needed
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//             child: RoundTextfield(
//               hintText: "Search Address",
//               left: Icon(Icons.search, color: TColor.primaryText),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25),
//             child: Row(
//               children: [
//                 Image.asset('assets/images/fav_icon.png', width: 35, height: 35),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     "Choose a saved place",
//                     style: TextStyle(
//                       color: TColor.primaryText,
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//                 Image.asset('assets/images/btn_next.png', width: 15, height: 15, color: TColor.primaryText),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

class ChangeAddressView extends StatefulWidget {
  @override
  _ChangeAddressViewState createState() => _ChangeAddressViewState();
}

class _ChangeAddressViewState extends State<ChangeAddressView> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  LatLng _center = LatLng(31.5497, 73.1369);
  String _errorMessage = '';

  void _searchLocation() async {
    try {
      List<Location> locations = await locationFromAddress(_searchController.text);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        setState(() {
          _center = LatLng(location.latitude, location.longitude);
          _mapController.move(_center, 12.0);
          _errorMessage = ''; // Clear any previous error message
        });
      } else {
        setState(() {
          _errorMessage = 'No location found';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error occurred while searching location: $e';
      });
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: _center,
                    zoom: 12.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _center,
                          width: 80.0,
                          height: 80.0,
                          builder: (ctx) => IconButton(
                            icon: Icon(Icons.location_on, color: Colors.red, size: 40),
                            onPressed: () {
                              showDialog(
                                context: ctx,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Foodie App'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Gmail: nisartalha99@gmail.com'),
                                        Text('Phone: +92 319 4792547'),
                                        SizedBox(height: 10),
                                        GestureDetector(
                                          onTap: () {
                                            // Implement the link opening functionality here
                                          },
                                          child: Text(
                                            'Visit my LinkedIn',
                                            style: TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Enter location",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _searchLocation,
                    child: Text("Search"),
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
