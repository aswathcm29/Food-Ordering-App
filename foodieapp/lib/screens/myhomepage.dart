import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/screens/addtocart.dart';
import 'package:foodieapp/screens/orderdetails.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodieapp/screens/loginscreen.dart';
import 'package:foodieapp/widgets/cardwidget.dart';
import 'package:foodieapp/widgets/framebutton.dart';
import 'package:motion_toast/motion_toast.dart'; // Add this import

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddToCart()),
      );
    }
    if (_selectedIndex == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderDetails()),
      );
    }
  }



  final TextEditingController _searchController = TextEditingController();
  bool _isLoggedIn = false;
  String? _profileImageUrl;

  List<Map<String, dynamic>> cardData = [];
  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _fetchProductDataFromFirestore();
  }

  Future<void> _fetchProductDataFromFirestore() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('foodData').get();
      List<Map<String, dynamic>> tempCardData = [];

      for (var doc in querySnapshot.docs) {
        tempCardData.add(doc.data() as Map<String, dynamic>);
      }
      setState(() {
        cardData = tempCardData;
        filteredData = tempCardData;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    if (uid != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('UserData')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        setState(() {
          _isLoggedIn = true;
          _profileImageUrl = userDoc['profileImage'];
        });
      } else {
        setState(() {
          _isLoggedIn = false;
        });
      }
    }
  }

  void filterData(String query) {
    setState(() {
      filteredData = cardData
          .where((item) =>
              item['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    setState(() {
      _isLoggedIn = false;
      _profileImageUrl = null;
    });

    // Show logout success notification
    MotionToast.success(
      title: Text('Logout Successful'),
      description: Text('You have logged out successfully'),
      animationType: AnimationType.fromTop,
      position: MotionToastPosition.top,
      width: 300,
      height: 80,
    ).show(context);
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (category.toLowerCase() == 'all') {
        filteredData = cardData;
      } else {
        filteredData = cardData
            .where((item) =>
                item['title']
                    .toString()
                    .toLowerCase()
                    .contains(category.toLowerCase()))
            .toList();
      }
    });
  }

  void sortByTitle() {
    setState(() {
      filteredData.sort((a, b) => a['title'].compareTo(b['title']));
    });
  }

  void sortByPrice() {
    setState(() {
      filteredData.sort((a, b) => a['price'].compareTo(b['price']));
    });
  }

  
void _showSortMenu(BuildContext context) {
  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(1000, 220, 30, 0),
    items: [
      PopupMenuItem(
        child: ListTile(
          leading: Icon(Icons.sort_by_alpha, color: Color(0xFF19C08E)),
          title: Text('Sort by Title', style: TextStyle(color: Colors.black87)),
          onTap: () {
            Navigator.pop(context); // Close the menu
            sortByTitle();
          },
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: Icon(Icons.attach_money, color: Color(0xFF19C08E)),
          title: Text('Sort by Price', style: TextStyle(color: Colors.black87)),
          onTap: () {
            Navigator.pop(context); // Close the menu
            sortByPrice();
          },
        ),
      ),
    ],
    color: Colors.white, // Background color of the popup menu
    elevation: 8, // Shadow elevation of the popup menu
  );
}

Widget _buildPopupMenu(BuildContext context) {
  return GestureDetector(
    onTap: () {
      _showSortMenu(context);
    },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0), // Rounded border on top right
        ),
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.grey[300]!), // Border from top right
          right: BorderSide(width: 1.0, color: Colors.grey[300]!), // Border from top right
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Icon(
          Icons.tune_rounded,
          color: Color(0xFF19C08E),
        ),
      ),
    ),
  );
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          width: double.infinity,
          height: min(7000, 5000),
          decoration: BoxDecoration(border: Border.all(color: Colors.green)),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 19,
                child: Text(
                  'Foodie',
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
                top: 60,
                right: 19,
                child: _isLoggedIn
                    ? InkWell(
                        onTap: () {
                          _showSortMenu(context);
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(_profileImageUrl!),
                          radius: 30,
                        ),
                      )
                    : InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Icon(
                          Icons.login_rounded,
                          size: 40,
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
                          controller: _searchController,
                          onChanged: (value) {
                            filterData(value);
                          },
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
                    _showSortMenu(context);
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFF19C08E),
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
                left: 25,
                child: FrameWithButtons(
                  onCategorySelected: _onCategorySelected,
                ),
              ),
              Positioned(
                top: 320,
                left: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(filteredData.length ~/ 2, (index) {
                    final firstIndex = index * 2;
                    final secondIndex = firstIndex + 1;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          SizedBox(width: 4),
                          CardWidget(
                            imagePath: filteredData[firstIndex]['imagePath'],
                            title: filteredData[firstIndex]['title'],
                            subTitle: filteredData[firstIndex]['subTitle'],
                            rating: filteredData[firstIndex]['rating'],
                            price: filteredData[firstIndex]['price'],
                          ),
                          SizedBox(width: 4),
                          if (secondIndex < filteredData.length)
                            CardWidget(
                              imagePath: filteredData[secondIndex]['imagePath'],
                              title: filteredData[secondIndex]['title'],
                              subTitle: filteredData[secondIndex]['subTitle'],
                              rating: filteredData[secondIndex]['rating'],
                              price: filteredData[secondIndex]['price'],
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_card),
            label: 'Order Details',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: _onItemTapped,
      ),
    );
  }
}




// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:foodieapp/screens/addtocart.dart';
// import 'package:foodieapp/screens/orderdetails.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:foodieapp/screens/loginscreen.dart';
// import 'package:foodieapp/widgets/cardwidget.dart';
// import 'package:foodieapp/widgets/framebutton.dart';
// import 'package:motion_toast/motion_toast.dart';
// import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:speech_to_text/speech_to_text.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 0;
  
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//     if (_selectedIndex == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => AddToCart()),
//       );
//     }
//     if (_selectedIndex == 2) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => OrderDetails()),
//       );
//     }
//   }
//   final TextEditingController _searchController = TextEditingController();
//   bool _isLoggedIn = false;
//   String? _profileImageUrl;
//   List<Map<String, dynamic>> cardData = [];
//   List<Map<String, dynamic>> filteredData = [];
//   final SpeechToText _speechToText = SpeechToText();

//   @override
//   void initState() {
//     super.initState();
//     _loadUserProfile();
//     _fetchProductDataFromFirestore();
//     initSpeech(); // Initialize speech-to-text
//   }

//   Future<void> _fetchProductDataFromFirestore() async {
//     try {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('foodData').get();
//       List<Map<String, dynamic>> tempCardData = [];

//       for (var doc in querySnapshot.docs) {
//         tempCardData.add(doc.data() as Map<String, dynamic>);
//       }
//       setState(() {
//         cardData = tempCardData;
//         filteredData = tempCardData;
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> _loadUserProfile() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? uid = prefs.getString('uid');

//     if (uid != null) {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('UserData')
//           .doc(uid)
//           .get();

//       if (userDoc.exists) {
//         setState(() {
//           _isLoggedIn = true;
//           _profileImageUrl = userDoc['profileImage'];
//         });
//       } else {
//         setState(() {
//           _isLoggedIn = false;
//         });
//       }
//     }
//   }

//   void filterData(String query) {
//     setState(() {
//       filteredData = cardData.where((item) {
//         String title = item['title'].toString().toLowerCase();
//         return title.contains(query.toLowerCase());
//       }).toList();

//       // Set the search field with the matched title
//       if (filteredData.isNotEmpty) {
//         _searchController.text = filteredData.first['title'];
//       }
//     });
//   }

//   void _logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('uid');
//     setState(() {
//       _isLoggedIn = false;
//       _profileImageUrl = null;
//     });

//     // Show logout success notification
//     MotionToast.success(
//       title: Text('Logout Successful'),
//       description: Text('You have logged out successfully'),
//       animationType: AnimationType.fromTop,
//       position: MotionToastPosition.top,
//       width: 300,
//       height: 80,
//     ).show(context);
//   }

//   void _onCategorySelected(String category) {
//     setState(() {
//       if (category.toLowerCase() == 'all') {
//         filteredData = cardData;
//       } else {
//         filteredData = cardData
//             .where((item) =>
//                 item['title']
//                     .toString()
//                     .toLowerCase()
//                     .contains(category.toLowerCase()))
//             .toList();
//       }
//     });
//   }

//   void sortByTitle() {
//     setState(() {
//       filteredData.sort((a, b) => a['title'].compareTo(b['title']));
//     });
//   }

//   void sortByPrice() {
//     setState(() {
//       filteredData.sort((a, b) => a['price'].compareTo(b['price']));
//     });
//   }

//   void _showSortMenu(BuildContext context) {
//     showMenu(
//       context: context,
//       position: RelativeRect.fromLTRB(1000, 220, 30, 0),
//       items: [
//         PopupMenuItem(
//           child: ListTile(
//             leading: Icon(Icons.sort_by_alpha, color: Color(0xFF19C08E)),
//             title: Text('Sort by Title',
//                 style: TextStyle(color: Colors.black87)),
//             onTap: () {
//               Navigator.pop(context); // Close the menu
//               sortByTitle();
//             },
//           ),
//         ),
//         PopupMenuItem(
//           child: ListTile(
//             leading: Icon(Icons.attach_money, color: Color(0xFF19C08E)),
//             title: Text('Sort by Price',
//                 style: TextStyle(color: Colors.black87)),
//             onTap: () {
//               Navigator.pop(context); // Close the menu
//               sortByPrice();
//             },
//           ),
//         ),
//       ],
//       color: Colors.white, // Background color of the popup menu
//       elevation: 8, // Shadow elevation of the popup menu
//     );
//   }

//   Widget _buildPopupMenu(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         _showSortMenu(context);
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(
//             topRight: Radius.circular(10.0), // Rounded border on top right
//           ),
//           border: Border(
//             top: BorderSide(width: 1.0, color: Colors.grey[300]!),
//             right: BorderSide(width: 1.0, color: Colors.grey[300]!),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
//           child: Icon(
//             Icons.tune_rounded,
//             color: Color(0xFF19C08E),
//           ),
//         ),
//       ),
//     );
//   }

//   void initSpeech() async {
//     setState(() {});
//   }

//  void _startListening() async {
//   try {
//     bool available = await _speechToText.initialize();
//     if (available && !_speechToText.isListening) {
//       await _speechToText.listen(
//         onResult: _onSpeechResult,
//         listenFor: Duration(seconds: 10), // Adjust duration as needed
//       );
//     } else if (_speechToText.isListening) {
//       print('Speech recognition is already active.');
//     } else {
//       print('Speech recognition not available');
//     }
//   } catch (e) {
//     print('Error starting speech recognition: $e');
//   }
//   setState(() {});
// }


//   void _stopListening() async {
//     await _speechToText.stop();
//     setState(() {});
//   }

//   void _onSpeechResult(SpeechRecognitionResult result) {
//     setState(() {
//       String _spokenWords = result.recognizedWords.toLowerCase(); 
      
//       filterData(_spokenWords); 
      
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Container(
//           width: double.infinity,
//           height: min(7000, 5000),
//           decoration: BoxDecoration(border: Border.all(color: Colors.green)),
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 50,
//                 left: 19,
//                 child: Text(
//                   'Foodie',
//                   style: TextStyle(
//                     fontFamily: 'Lobster',
//                     fontSize: 45,
//                     fontWeight: FontWeight.w400,
//                     height: 60.61 / 45,
//                     color: Color(0xFF3C2F2F),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 60,
//                 right: 19,
//                 child: _isLoggedIn
//                     ? InkWell(
//                         onTap: () {
//                           _showSortMenu(context);
//                         },
//                         child: CircleAvatar(
//                           backgroundImage: NetworkImage(_profileImageUrl!),
//                           radius: 30,
//                         ),
//                       )
//                     : InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => LoginScreen()),
//                           );
//                         },
//                         child: Icon(
//                           Icons.login_rounded,
//                           size: 40,
//                         ),
//                       ),
//               ),
//               Positioned(
//                 top: 110,
//                 left: 19,
//                 child: Text(
//                   'Order your favourite food!',
//                   style: TextStyle(
//                     fontFamily: 'Poppins',
//                     fontSize: 18,
//                     fontWeight: FontWeight.w500,
//                     height: 27 / 18,
//                     color: Color(0xFF6A6A6A),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 163,
//                 left: 19,
//                 child: Container(
//                   width: 279,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Color(0x26000000),
//                         blurRadius: 19,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(left: 15),
//                         child: Icon(
//                           Icons.search,
//                           size: 34,
//                           color: Color(0xFF3C2F2F),
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: TextField(
//                           controller: _searchController,
//                           onChanged: (value) {
//                             filterData(value);
//                           },
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: 'Search',
//                             hintStyle: TextStyle(
//                               fontFamily: 'Roboto',
//                               fontSize: 20,
//                               fontWeight: FontWeight.w500,
//                               height: 21.09 / 18,
//                               color: Color(0xFF3C2F2F),
//                             ),
//                             suffixIcon: GestureDetector(
//                               onTap: _startListening,
//                               child: Icon(
//                                 Icons.mic,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 163,
//                 right: 16,
//                 child: InkWell(
//                   onTap: () {
//                     _showSortMenu(context);
//                   },
//                   child: Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: Color(0xFF19C08E),
//                     ),
//                     child: Icon(
//                       Icons.tune_rounded,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 top: 240,
//                 left: 25,
//                 child: FrameWithButtons(
//                   onCategorySelected: _onCategorySelected,
//                 ),
//               ),
//               Positioned(
//                 top: 320,
//                 left: 12,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children:
//                       List.generate(filteredData.length ~/ 2, (index) {
//                     final firstIndex = index * 2;
//                     final secondIndex = firstIndex + 1;
//                     return Padding(
//                       padding: const EdgeInsets.only(bottom: 14),
//                       child: Row(
//                         children: [
//                           SizedBox(width: 4),
//                           CardWidget(
//                             imagePath:
//                                 filteredData[firstIndex]['imagePath'],
//                             title: filteredData[firstIndex]['title'],
//                             subTitle:
//                                 filteredData[firstIndex]['subTitle'],
//                             rating: filteredData[firstIndex]['rating'],
//                             price: filteredData[firstIndex]['price'],
//                           ),
//                           SizedBox(width: 4),
//                           if (secondIndex < filteredData.length)
//                             CardWidget(
//                               imagePath:
//                                   filteredData[secondIndex]['imagePath'],
//                               title: filteredData[secondIndex]['title'],
//                               subTitle:
//                                   filteredData[secondIndex]['subTitle'],
//                               rating: filteredData[secondIndex]['rating'],
//                               price: filteredData[secondIndex]['price'],
//                             ),
//                         ],
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.shopping_cart),
//             label: 'Cart',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_card),
//             label: 'Order Details',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.green[800],
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }
