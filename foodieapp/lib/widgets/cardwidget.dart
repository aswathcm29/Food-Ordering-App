import 'package:flutter/material.dart';
import 'package:foodieapp/screens/productsinfo.dart';

class CardWidget extends StatefulWidget {
  final String imagePath;
  final String title;
  final double rating;
  final String subTitle;
  final String price;
  final Function onFavoriteSelected;
  final Function onFavoriteRemoved;
  final List<Map<String, dynamic>> favourites;

  const CardWidget({
    required this.imagePath,
    required this.title,
    required this.rating,
    required this.subTitle,
    required this.price,
    required this.onFavoriteSelected,
    required this.onFavoriteRemoved,
    required this.favourites,
  });

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Check if the current item is in the favorites list
    isFavorite = widget.favourites.any((item) =>
        item['imagePath'] == widget.imagePath &&
        item['title'] == widget.title &&
        item['rating'] == widget.rating &&
        item['subTitle'] == widget.subTitle &&
        item['price'] == widget.price);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductInfoPage(
              imagePath: widget.imagePath,
              title: widget.title,
              rating: widget.rating,
              subTitle: widget.subTitle,
              price: widget.price,
            ),
          ),
        );
      },
      child: Container(
        width: 170,
        height: 260,
        padding: EdgeInsets.only(right: 14, bottom: 10),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 100,
              margin: EdgeInsets.only(top: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(widget.imagePath),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3C2F2F),
                    ),
                  ),
                  SizedBox(height: 1),
                  Text(
                    widget.subTitle,
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
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10, bottom: 0),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0xFFFF9633),
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.rating.toString(),
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
                IconButton(
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite
                        : Icons.favorite_outline_outlined,
                    color: isFavorite ? Colors.red : Color(0xFF3C2F2F),
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                      if (isFavorite) {
                        widget.onFavoriteSelected(
                          widget.imagePath,
                          widget.title,
                          widget.rating,
                          widget.subTitle,
                          widget.price,
                        );
                      } else {
                        widget.onFavoriteRemoved(
                          widget.imagePath,
                          widget.title,
                          widget.rating,
                          widget.subTitle,
                          widget.price,
                        );
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
