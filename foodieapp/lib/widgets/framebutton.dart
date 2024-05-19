import 'package:flutter/material.dart';
import 'package:foodieapp/widgets/custombutton.dart';

class FrameWithButtons extends StatelessWidget {
  final Function(String) onCategorySelected; // Callback for category selection

  const FrameWithButtons({required this.onCategorySelected});

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
           
            onTap: () {
              onCategorySelected('All'); // Call callback with 'All'
            },
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Burger',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
            
            onTap: () {
              onCategorySelected('Burger'); // Call callback with 'Burger'
            },
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Pizza',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
             
            onTap: () {
              onCategorySelected('Pizza'); // Call callback with 'Pizza'
            },
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Fries',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
             
            onTap: () {
              onCategorySelected('Fries'); // Call callback with 'Fries'
            },
          ),
          CustomButton(
            text: 'Shawarma',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
             
            onTap: () {
              onCategorySelected('Shawarma'); // Call callback with 'Shawarma'
            },
          ),
          CustomButton(
            text: 'Pasta',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
             
            onTap: () {
              onCategorySelected('Pasta'); // Call callback with 'Pasta'
            },
          ),
          CustomButton(
            text: 'Sandwich',
            color: Color(0xFFF3F4F6),
            textColor: Color(0xFF6A6A6A),
            
            onTap: () {
              onCategorySelected('Sandwich'); // Call callback with 'Sandwich'
            },
          ),
        ],
      ),
    );
  }
}
