import 'package:flutter/material.dart';

class AppColors {
  static const Color color1 = Color(0xFF4BA1D9); // Example color 1
  static const Color color2 = Color(0xFF1FBAAB);
  static Color colorWithOpacity =
      Colors.grey.shade200.withOpacity(0.25); // Example color 2
  static const BoxDecoration decoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        color1, // Start color
        color2, // End color
      ],
    ),
  );
  static BoxDecoration decoration2 = BoxDecoration(
   // borderRadius: BorderRadius.circular(30),
    color: Colors.grey.shade200.withOpacity(0.25),
  );

// Add more color constants as needed
}
