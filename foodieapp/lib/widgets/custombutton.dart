import 'package:flutter/material.dart';

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
