import 'package:flutter/material.dart';
import 'package:foodieapp/screens/productsinfo.dart';

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
                price: price),
          ),
        );
      },
      child: Container(
        width: 170,
        // height: 220,

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
                  image: NetworkImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
