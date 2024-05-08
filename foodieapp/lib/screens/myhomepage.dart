import 'package:flutter/material.dart';
import 'package:foodieapp/screens/productsinfo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();

  // Sample data for demonstration
  final List<Map<String, dynamic>> cardData = [
    {
      'imagePath': 'assets/images/cheeseburger.png',
      'title': 'Cheeseburger',
      'subTitle': "Wendy's Burger",
      'rating': 4.9,
      'price': '\$300'
    },
    {
      'imagePath': 'assets/images/hamburger.png',
      'title': 'Hamburger',
      'subTitle': "Veggie's Burger",
      'rating': 4.9,
      'price': '\$200'

    },
    {
      'imagePath': 'assets/images/hamburger2.png',
      'title': 'Hamburger',
      'subTitle': "Veggie's Burger",
      'rating': 3.9,
      'price': '\$400'

    },
    {
      'imagePath': 'assets/images/hamburger3.png',
      'title': 'Hamburger',
      'subTitle': "Veggie's Burger",
      'rating': 4.9,
      'price': '\$60'

    },
    {
      'imagePath': 'assets/images/pizza_1.jpg',
      'title': 'Cheese Pizza',
      'subTitle': "Cheese's Pizza",
      'rating': 3.9,
      'price': '\$380'

    },
    {
      'imagePath': 'assets/images/pizza_2.jpg',
      'title': 'Chicken Pizza',
      'subTitle': "Chicken's Pizza",
      'rating': 4.9,
      'price': '\$200'

    },
    {
      'imagePath': 'assets/images/pizza3.jpg',
      'title': 'Vegetable Pizza',
      'subTitle': "Veggie's Pizza",
      'rating': 4.9,
      'price': '\$270'

    },
    {
      'imagePath': 'assets/images/pizza_4.jpg',
      'title': 'Fajita Pizza',
      'subTitle': "Cheese Fajita's Pizza",
      'rating': 4.9,
      'price': '\$400'

    },
    // Add more data as needed
  ];

  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = cardData;
  }

  void filterData(String query) {
    setState(() {
      filteredData = cardData
          .where((item) => item['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 50,
              left: 19,
              child: Text(
                'Foodgo',
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
              left: 19,
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
    );
  }
}

class FrameWithButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 279,
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CustomButton(
            text: 'All',
            color: Color(0xFF19C08E),
            textColor: Color(0xFFF5F5F5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Burger',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Pizza',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Classic',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final List<BoxShadow>? boxShadow;

  const CustomButton({
    required this.text,
    required this.color,
    required this.textColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
        boxShadow: boxShadow,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final double rating;
  final String subTitle;
  final String price;
  const CardWidget({
    required this.imagePath,
    required this.title,
    required this.rating,
    required this.subTitle,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductInfoPage(
              imagePath: imagePath,
              title: title,
              rating: rating,
              subTitle: subTitle,
              price:price
            ),
          ),
        );
      },
      child: Container(
        width: 170,
        //height: 220,
        margin: EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.21),
              blurRadius: 17,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 100,
              margin: EdgeInsets.only(left: 32, top: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3C2F2F),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ), // Maintain a small space between title and subtitle
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6A6A6A),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, top: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Color(0xFFFF9633),
                      ),
                      SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3C2F2F),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 16, top: 6),
                  child: Icon(
                    Icons.favorite_outline_outlined,
                    size: 24,
                    color: Color(0xFF3C2F2F),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




/*
import 'package:flutter/material.dart';
import 'package:foodieapp/screens/productsinfo.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _searchController = TextEditingController();
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;

  // Sample data for demonstration
  final List<Map<String, dynamic>> cardData = [
    {
      'imagePath': 'assets/images/cheeseburger.png',
      'title': 'Cheeseburger',
      'subTitle': "Wendy's Burger",
      'rating': 4.9,
      'price': '\$300'
    },
    {
      'imagePath': 'assets/images/hamburger.png',
      'title': 'Hamburger',
      'subTitle': "Veggie's Burger",
      'rating': 4.9,
      'price': '\$200'
    },
    {
      'imagePath': 'assets/images/hamburger2.png',
      'title': 'Hamburger',
      'subTitle': "Veggie's Burger",
      'rating': 3.9,
      'price': '\$400'
    },
    {
      'imagePath': 'assets/images/hamburger3.png',
      'title': 'Hamburger',
      'subTitle': "Veggie's Burger",
      'rating': 4.9,
      'price': '\$60'
    },
    {
      'imagePath': 'assets/images/pizza_1.jpg',
      'title': 'Cheese Pizza',
      'subTitle': "Cheese's Pizza",
      'rating': 3.9,
      'price': '\$380'
    },
    {
      'imagePath': 'assets/images/pizza_2.jpg',
      'title': 'Chicken Pizza',
      'subTitle': "Chicken's Pizza",
      'rating': 4.9,
      'price': '\$200'
    },
    {
      'imagePath': 'assets/images/pizza3.jpg',
      'title': 'Vegetable Pizza',
      'subTitle': "Veggie's Pizza",
      'rating': 4.9,
      'price': '\$270'
    },
    {
      'imagePath': 'assets/images/pizza_4.jpg',
      'title': 'Fajita Pizza',
      'subTitle': "Cheese Fajita's Pizza",
      'rating': 4.9,
      'price': '\$400'
    },
    // Add more data as needed
  ];

  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    filteredData = cardData;
  }

  void filterData(String query) {
    setState(() {
      filteredData = cardData
          .where((item) => item['title'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
void initializeSpeechToText() async {
  bool isAvailable = await _speech.initialize(
    onError: (error) => print("Error initializing speech recognizer: $error"),
  );
  if (isAvailable) {
    print("Speech recognizer initialized successfully");
  } else {
    print("Speech recognizer initialization failed");
  }
}
  void startListening() {
    _speech.listen(
      onResult: (result) {
        setState(() {
          _searchController.text = result.recognizedWords;
          filterData(result.recognizedWords);
        });
      },
    );
    setState(() {
      _isListening = true;
    });
  }

  void stopListening() {
    _speech.stop();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 50,
              left: 19,
              child: Text(
                'Foodgo',
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
                    IconButton(
                      onPressed: () {
                        if (!_isListening) {
                          startListening();
                        } else {
                          stopListening();
                        }
                      },
                      icon: Icon(
                        _isListening ? Icons.mic : Icons.mic_none,
                        color: Color(0xFF3C2F2F),
                        size: 30,
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
              left: 19,
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
    );
  }
}

class FrameWithButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 279,
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          CustomButton(
            text: 'All',
            color: Color(0xFF19C08E),
            textColor: Color(0xFFF5F5F5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Burger',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Pizza',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Classic',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final List<BoxShadow>? boxShadow;

  const CustomButton({
    required this.text,
    required this.color,
    required this.textColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: color,
        boxShadow: boxShadow,
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final double rating;
  final String subTitle;
  final String price;
  const CardWidget({
    required this.imagePath,
    required this.title,
    required this.rating,
    required this.subTitle,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductInfoPage(
              imagePath: imagePath,
              title: title,
              rating: rating,
              subTitle: subTitle,
              price: price,
            ),
          ),
        );
      },
      child: Container(
        width: 170,
        //height: 220,
        margin: EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.21),
              blurRadius: 17,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 100,
              margin: EdgeInsets.only(left: 32, top: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3C2F2F),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ), // Maintain a small space between title and subtitle
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF6A6A6A),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, top: 6),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Color(0xFFFF9633),
                      ),
                      SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF3C2F2F),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 16, top: 6),
                  child: Icon(
                    Icons.favorite_outline_outlined,
                    size: 24,
                    color: Color(0xFF3C2F2F),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/