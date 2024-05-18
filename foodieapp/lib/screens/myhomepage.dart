import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodieapp/screens/addtocart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodieapp/screens/loginscreen.dart';
import 'package:foodieapp/widgets/cardwidget.dart';
import 'package:foodieapp/widgets/framebutton.dart';

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
    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
    if (_selectedIndex == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddToCart()),
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
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(1000, 120, 0, 0),
                            items: [
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.shopping_cart),
                                  title: Text('View Cart'),
                                  onTap: () {
                                    // Navigate to cart screen
                                    Navigator.pop(context); // Close the menu
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.logout),
                                  title: Text('Logout'),
                                  onTap: () {
                                    _logout();
                                    Navigator.pop(context); // Close the menu
                                  },
                                ),
                              ),
                            ],
                          );
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
                    // Handle icon tap
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
                child: FrameWithButtons(),
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Profile',
          // ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
