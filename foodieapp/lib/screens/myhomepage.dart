import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodieapp/screens/favouritepage.dart';
//import 'package:foodieapp/screens/favouritepage.dart';
import 'package:foodieapp/screens/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodieapp/screens/addtocart.dart';
import 'package:foodieapp/screens/orderdetails.dart';
//import 'package:foodieapp/screens/loginscreen.dart';
import 'package:foodieapp/widgets/cardwidget.dart';
import 'package:foodieapp/widgets/framebutton.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _favourites = [];
  bool _isListening = false;
  bool _isFavourite = false;

  // final List<Map<String, dynamic>> cardData2 = [
  //   {
  //     'imagePath': 'assets/images/sandwich.png',
  //     'title': 'Club Sandwich',
  //     'subTitle': "Classic Club",
  //     'rating': 4.8,
  //     'price': '150',
  //     'availableQuantity': 20,
  //     'description':
  //         'A delicious club sandwich stacked with turkey, bacon, and fresh veggies.'
  //   },
  //   {
  //     'imagePath': 'assets/images/pasta.png',
  //     'title': 'Spaghetti Carbonara Pasta',
  //     'subTitle': "Italian Pasta",
  //     'rating': 4.7,
  //     'price': '250',
  //     'availableQuantity': 18,
  //     'description':
  //         'A classic Italian pasta dish with creamy sauce, pancetta, and parmesan.'
  //   },
  //   {
  //     'imagePath': 'assets/images/fries.png',
  //     'title': 'French Fries',
  //     'subTitle': "Crispy Fries",
  //     'rating': 4.5,
  //     'price': '100',
  //     'availableQuantity': 40,
  //     'description':
  //         'Golden and crispy French fries, perfect as a side dish or snack.'
  //   },
  //   {
  //     'imagePath': 'assets/images/pasta3.png',
  //     'title': 'Fettuccine Alfredo Pasta',
  //     'subTitle': "Creamy Pasta",
  //     'rating': 4.8,
  //     'price': '280',
  //     'availableQuantity': 15,
  //     'description':
  //         'Rich and creamy fettuccine Alfredo with Parmesan cheese and butter.'
  //   },
  //   {
  //     'imagePath': 'assets/images/fries.png',
  //     'title': 'French Fries',
  //     'subTitle': "Crispy Fries",
  //     'rating': 4.5,
  //     'price': '100',
  //     'availableQuantity': 40,
  //     'description':
  //         'Golden and crispy French fries, perfect as a side dish or snack.'
  //   },
  //   {
  //     'imagePath': 'assets/images/fries2.png',
  //     'title': 'Sweet Potato Fries',
  //     'subTitle': "Sweet and Savory",
  //     'rating': 4.7,
  //     'price': '120',
  //     'availableQuantity': 30,
  //     'description':
  //         'Crispy sweet potato fries with a hint of cinnamon and sea salt.'
  //   },
  //   {
  //     'imagePath': 'assets/images/fries3.png',
  //     'title': 'Curly Fries',
  //     'subTitle': "Twisty Treats",
  //     'rating': 4.6,
  //     'price': '110',
  //     'availableQuantity': 35,
  //     'description': 'Fun and curly fries with a perfect blend of spices.'
  //   },
  //   {
  //     'imagePath': 'assets/images/shawarma.png',
  //     'title': 'Chicken Shawarma',
  //     'subTitle': "Middle Eastern Delight",
  //     'rating': 4.6,
  //     'price': '180',
  //     'availableQuantity': 22,
  //     'description':
  //         'A flavorful chicken shawarma wrapped in soft pita bread with fresh toppings.'
  //   },
  //   {
  //     'imagePath': 'assets/images/shawarma2.png',
  //     'title': 'Beef Shawarma',
  //     'subTitle': "Tender Beef",
  //     'rating': 4.7,
  //     'price': '200',
  //     'availableQuantity': 20,
  //     'description':
  //         'Juicy beef shawarma with a mix of vegetables and delicious sauce.'
  //   },
  //   {
  //     'imagePath': 'assets/images/shawarma3.png',
  //     'title': 'Falafel Shawarma',
  //     'subTitle': "Vegetarian Delight",
  //     'rating': 4.5,
  //     'price': '150',
  //     'availableQuantity': 25,
  //     'description':
  //         'Crispy falafel balls wrapped with fresh vegetables and tahini sauce.'
  //   },
  // ];
  // Future<void> sendDataToFirestore(List<Map<String, dynamic>> data) async {
  //   // Get a reference to the Firestore collection
  //   CollectionReference foodDataCollection =
  //       FirebaseFirestore.instance.collection('foodData');

  //   // Iterate through the data and add each item to the collection
  //   for (var item in data) {
  //     await foodDataCollection.add(item);
  //   }
  //   print('Data sent to Firestore successfully!');
  // }

  void _onItemTapped(int index) async {
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
    if (_selectedIndex == 3) {
      final updatedFavourites = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavouritePage(
            onFavoritesUpdated: _onFavoritesUpdated,
          ),
        ),
      );

      if (updatedFavourites != null) {
        setState(() {
          _favourites = updatedFavourites;
        });
      }
    }
  }

  void _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favouriteList = prefs.getStringList('favItems') ?? [];
    setState(() {
      _favourites = favouriteList
          .map((item) => jsonDecode(item))
          .toList()
          .cast<Map<String, dynamic>>();
    });
  }

  void _onFavoritesUpdated(List<Map<String, dynamic>> updatedFavourites) {
    setState(() {
      _favourites = updatedFavourites;
      _saveFavourites();
    });
  }

  void _saveFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favouriteList = _favourites.map((item) => jsonEncode(item)).toList();
    prefs.setStringList('favItems', favouriteList);
  }

  void _addToFavourites(Map<String, dynamic> item) {
    setState(() {
      _favourites.add({
        'imagePath': item['imagePath'],
        'title': item['title'],
        'rating': item['rating'],
        'subTitle': item['subTitle'],
        'price': item['price'],
      });
    });
  }

  // void _addToFavourites(String imagePath, String title, double rating,
  //     String subTitle, String price) {
  //   setState(() {
  //     _favourites.add({
  //       'imagePath': imagePath,
  //       'title': title,
  //       'rating': rating,
  //       'subTitle': subTitle,
  //       'price': price,
  //     });
  //   });
  // }

  final TextEditingController _searchController = TextEditingController();
  bool _isLoggedIn = false;
  String? _profileImageUrl;

  List<Map<String, dynamic>> cardData = [];
  List<Map<String, dynamic>> filteredData = [];
  final SpeechToText _speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    initSpeech();
    _loadUserProfile();
    _fetchProductDataFromFirestore();
    _loadFavourites();
    // sendDataToFirestore(cardData2);
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
              item['title'].toLowerCase().contains(query.toLowerCase()) ||
              item['subTitle'].toLowerCase().contains(query.toLowerCase()) ||
              item['description'].toLowerCase().contains(query.toLowerCase()))
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

    // Reload the page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  void _onCategorySelected(String category) {
    setState(() {
      if (category.toLowerCase() == 'all') {
        filteredData = cardData;
      } else {
        filteredData = cardData
            .where((item) =>
                item['title'].toLowerCase().contains(category.toLowerCase()) ||
                item['subTitle']
                    .toLowerCase()
                    .contains(category.toLowerCase()) ||
                item['description']
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
            title:
                Text('Sort by Title', style: TextStyle(color: Colors.black87)),
            onTap: () {
              Navigator.pop(context); // Close the menu
              sortByTitle();
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.money, color: Color(0xFF19C08E)),
            title:
                Text('Sort by Price', style: TextStyle(color: Colors.black87)),
            onTap: () {
              Navigator.pop(context); // Close the menu
              sortByPrice();
            },
          ),
        ),
      ],
      color: Colors.white, // Background color of the popup menu
      elevation: 8, 
    );
  }

  void _removeFromFavourites(Map<String, dynamic> item) {
    setState(() {
      _favourites.removeWhere((fav) =>
          fav['imagePath'] == item['imagePath'] &&
          fav['title'] == item['title'] &&
          fav['rating'] == item['rating'] &&
          fav['subTitle'] == item['subTitle'] &&
          fav['price'] == item['price']);
    });
  }

  // void _removeFromFavourites(Map<String, dynamic> item) {
  //   setState(() {
  //     // _favourites.remove(item);
  //     _favourites.remove(item);
  //     print(_favourites);
  //   });
  // }

  Future<void> _showUserMenu(BuildContext context) async {
    String? result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 0, 100),
      items: [
        PopupMenuItem<String>(
          value: 'cart',
          child: ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Cart'),
          ),
        ),
        PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
          ),
        ),
      ],
    );

    if (result == 'cart') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddToCart()),
      );
    } else if (result == 'logout') {
      _logout(); // Implement your logout functionality
    }
  }

  void initSpeech() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {});
    } else {
      print('Speech recognition not available');
    }
  }

  void _startListening() async {
    try {
      bool available = await _speechToText.initialize();
      if (available && !_speechToText.isListening) {
        await _speechToText.listen(
          onResult: _onSpeechResult,
          listenFor: Duration(seconds: 10),
        );

        setState(() {
          _isListening = true; // Update state to indicate listening
        });

        // Schedule a task to stop listening after 10 seconds
        Future.delayed(Duration(seconds: 10), () {
          if (_isListening) {
            _stopListening(); // Call stop listening method after 10 seconds
          }
        });
      } else if (_speechToText.isListening) {
        print('Speech recognition is already active.');
      } else {
        print('Speech recognition not available');
      }
    } catch (e) {
      print('Error starting speech recognition: $e');
    }
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      String _spokenWords = result.recognizedWords.toLowerCase();
      print(_spokenWords);

      if (_spokenWords.contains('pizza')) {
        filterData("pizza");
      } else if (_spokenWords.contains('burger')) {
        filterData("burger");
      } else if (_spokenWords.contains('price')) {
        filterData("fries");
      } else if (_spokenWords.contains('shawarma')) {
        filterData("shawarma");
      } else if (_spokenWords.contains('pasta')) {
        filterData("pasta");
      } else if (_spokenWords.contains('sandwich')) {
        filterData("sandwich");
      } else if (_spokenWords.contains('all')) {
        filterData("all");
      } else {
        setState(() {
          filteredData == [];
          print("Item Not found");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  _isLoggedIn
                      ? InkWell(
                          onTap: () {
                            _showUserMenu(context);
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
                        )
                ],
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
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
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
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
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    if (_isListening) {
                                      _stopListening();
                                    } else {
                                      _startListening();
                                    }
                                  },
                                  child: Icon(
                                    _isListening ? Icons.mic : Icons.mic_off,
                                    color:
                                        _isListening ? Colors.red : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
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
                ],
              ),
              SizedBox(height: 20),
              FrameWithButtons(
                onCategorySelected: _onCategorySelected,
              ),
              SizedBox(height: 20),
              Column(
                children: filteredData.isEmpty
                    ? [
                        SizedBox(height: 50),
                        Center(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/no_items_found.gif',
                                height: 400,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'No items found',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
                    : List.generate((filteredData.length / 2).ceil(), (index) {
                        final firstIndex = index * 2;
                        final secondIndex = firstIndex + 1;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            children: [
                              SizedBox(width: 4),
                              Expanded(
                                child: CardWidget(
                                  imagePath: filteredData[firstIndex]
                                      ['imagePath'],
                                  title: filteredData[firstIndex]['title'],
                                  subTitle: filteredData[firstIndex]
                                      ['subTitle'],
                                  rating: filteredData[firstIndex]['rating'],
                                  price: filteredData[firstIndex]['price'],
                                  description: filteredData[firstIndex]
                                      ['description'],
                                  onFavoriteSelected: _addToFavourites,
                                  onFavoriteRemoved: _removeFromFavourites,
                                  favourites: [],
                                ),
                              ),
                              SizedBox(width: 4),
                              if (secondIndex < filteredData.length)
                                Expanded(
                                  child: CardWidget(
                                    imagePath: filteredData[secondIndex]
                                        ['imagePath'],
                                    title: filteredData[secondIndex]['title'],
                                    subTitle: filteredData[secondIndex]
                                        ['subTitle'],
                                    rating: filteredData[secondIndex]['rating'],
                                    price: filteredData[secondIndex]['price'],
                                    description: filteredData[secondIndex]
                                        ['description'],
                                    onFavoriteSelected: _addToFavourites,
                                    onFavoriteRemoved: _removeFromFavourites,
                                    favourites: [],
                                  ),
                                ),
                              if (secondIndex >= filteredData.length)
                                Expanded(
                                    child:
                                        Container()), // Placeholder for layout alignment
                            ],
                          ),
                        );
                      }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xFF19C08E)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: Color(0xFF19C08E)),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_card, color: Color(0xFF19C08E)),
            label: 'Order Details',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Color(0xFF19C08E)),
            label: 'Favourites',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 113, 9, 9),
        onTap: _onItemTapped,
      ),
    );
  }
}
