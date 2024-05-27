import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavouritePage extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onFavoritesUpdated;

  const FavouritePage({
    required this.onFavoritesUpdated,
  });

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<Map<String, dynamic>> _currentFavourites = [];

  @override
  void initState() {
    super.initState();
    _loadFavourites();
  }

  void _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favouriteList = prefs.getStringList('favItems') ?? [];
    setState(() {
      _currentFavourites = favouriteList
          .map((item) => jsonDecode(item))
          .toList()
          .cast<Map<String, dynamic>>();
    });
  }

  void _removeFavourite(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentFavourites.remove(item);
    });
    final favouriteList =
        _currentFavourites.map((fav) => jsonEncode(fav)).toList();
    await prefs.setStringList('favItems', favouriteList);
    widget.onFavoritesUpdated(_currentFavourites);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _currentFavourites);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _currentFavourites.length,
        itemBuilder: (context, index) {
          final item = _currentFavourites[index];
          return ListTile(
            leading: Image.network(item['imagePath']),
            title: Text(item['title']),
            subtitle: Text('${item['subTitle']} - ${item['price']}'),
            trailing: IconButton(
              icon: Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                _removeFavourite(item);
              },
            ),
          );
        },
      ),
    );
  }
}
