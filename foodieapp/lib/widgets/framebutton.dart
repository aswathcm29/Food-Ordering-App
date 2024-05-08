import 'package:flutter/material.dart';
import 'package:foodieapp/widgets/custombutton.dart';

class FrameWithButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
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
