import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  final List<Map<String, dynamic>> favourites;
  final Function(Map<String, dynamic>) onFavoriteRemoved;

  const FavouritePage({
    required this.favourites,
    required this.onFavoriteRemoved,
  });

  @override
  _FavouritePageState createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourites'),
      ),
      body: ListView.builder(
        itemCount: widget.favourites.length,
        itemBuilder: (context, index) {
          final item = widget.favourites[index];
          return ListTile(
            leading: Image.network(item['imagePath']),
            title: Text(item['title']),
            subtitle: Text('${item['subTitle']} - ${item['price']}'),
            trailing: IconButton(
              icon: Icon(Icons.favorite, color: Colors.red),
              onPressed: () {
                setState(() {
                  widget.onFavoriteRemoved(item);
                });
              },
            ),
          );
        },
      ),
    );
  }
}
