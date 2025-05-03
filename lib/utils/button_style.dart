import 'package:flutter/material.dart';

class ButtonStyles {
  // Text style for buttons
  static const buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
  );

  // Method to create consistent elevated button styling
  static ButtonStyle elevatedButtonStyle(
      Color color, {
        double horizontalPadding = 16,
      }) {
    return ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 8,
      ),
      textStyle: buttonTextStyle, // Added text style reference
    );
  }
}