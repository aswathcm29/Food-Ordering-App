import 'package:flutter/material.dart';
import 'package:foodieapp/widgets/custombutton.dart';

class FrameWithButtons extends StatefulWidget {
  final Function(String) onCategorySelected; // Callback for category selection

  const FrameWithButtons({required this.onCategorySelected});

  @override
  _FrameWithButtonsState createState() => _FrameWithButtonsState();
}

class _FrameWithButtonsState extends State<FrameWithButtons> {
  String selectedCategory = 'All'; // Default selected category
  final ScrollController _scrollController = ScrollController(); // Add this line

  void _scrollToSelectedButton(double position) {
    _scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      child: ListView(
        controller: _scrollController, // Add this line
        scrollDirection: Axis.horizontal,
        children: [
          CustomButton(
            text: 'All',
            color: selectedCategory == 'All' ? Color(0xFF19C08E) : Color(0xFFF3F4F6),
            textColor: selectedCategory == 'All' ? Color(0xFFF5F5F5) : Color(0xFF6A6A6A),
            onTap: () {
              setState(() {
                selectedCategory = 'All';
              });
              widget.onCategorySelected('All'); // Call callback with 'All'
              _scrollToSelectedButton(0); // Scroll to the position of the 'All' button
            },
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Burger',
            color: selectedCategory == 'Burger' ? Color(0xFF19C08E) : Color(0xFFF3F4F6),
            textColor: selectedCategory == 'Burger' ? Color(0xFFF5F5F5) : Color(0xFF6A6A6A),
            onTap: () {
              setState(() {
                selectedCategory = 'Burger';
              });
              widget.onCategorySelected('Burger'); // Call callback with 'Burger'
              _scrollToSelectedButton(30); // Adjust position to scroll
            },
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Pizza',
            color: selectedCategory == 'Pizza' ? Color(0xFF19C08E) : Color(0xFFF3F4F6),
            textColor: selectedCategory == 'Pizza' ? Color(0xFFF5F5F5) : Color(0xFF6A6A6A),
            onTap: () {
              setState(() {
                selectedCategory = 'Pizza';
              });
              widget.onCategorySelected('Pizza'); // Call callback with 'Pizza'
              _scrollToSelectedButton(128); // Adjust position to scroll
            },
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Fries',
            color: selectedCategory == 'Fries' ? Color(0xFF19C08E) : Color(0xFFF3F4F6),
            textColor: selectedCategory == 'Fries' ? Color(0xFFF5F5F5) : Color(0xFF6A6A6A),
            onTap: () {
              setState(() {
                selectedCategory = 'Fries';
              });
              widget.onCategorySelected('Fries'); // Call callback with 'Fries'
              _scrollToSelectedButton(280); // Adjust position to scroll
            },
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Shawarma',
            color: selectedCategory == 'Shawarma' ? Color(0xFF19C08E) : Color(0xFFF3F4F6),
            textColor: selectedCategory == 'Shawarma' ? Color(0xFFF5F5F5) : Color(0xFF6A6A6A),
            onTap: () {
              setState(() {
                selectedCategory = 'Shawarma';
              });
              widget.onCategorySelected('Shawarma'); // Call callback with 'Shawarma'
              _scrollToSelectedButton(350); // Adjust position to scroll
            },
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Pasta',
            color: selectedCategory == 'Pasta' ? Color(0xFF19C08E) : Color(0xFFF3F4F6),
            textColor: selectedCategory == 'Pasta' ? Color(0xFFF5F5F5) : Color(0xFF6A6A6A),
            onTap: () {
              setState(() {
                selectedCategory = 'Pasta';
              });
              widget.onCategorySelected('Pasta'); // Call callback with 'Pasta'
              _scrollToSelectedButton(450); // Adjust position to scroll
            },
          ),
          SizedBox(width: 14),
          CustomButton(
            text: 'Sandwich',
            color: selectedCategory == 'Sandwich' ? Color(0xFF19C08E) : Color(0xFFF3F4F6),
            textColor: selectedCategory == 'Sandwich' ? Color(0xFFF5F5F5) : Color(0xFF6A6A6A),
            onTap: () {
              setState(() {
                selectedCategory = 'Sandwich';
              });
              widget.onCategorySelected('Sandwich'); // Call callback with 'Pasta'
              _scrollToSelectedButton(500); // Adjust position to scroll
            },
          ),
        ],
      ),
    );
  }
}
