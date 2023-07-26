import 'package:flutter/material.dart';

class AppColors {
  static const Color color1 = Color(0xFF4BA1D9); // Example color 1
  static const Color color2 = Color(0xFF1FBAAB);
  static Color colorWithOpacity =
      Colors.grey.shade200.withOpacity(0.25); // Example color 2
  static const BoxDecoration decoration =  BoxDecoration(
    image: DecorationImage(
        image: AssetImage("assets/tstiBackGround.jpg"), fit: BoxFit.cover),
  );



  static BoxDecoration decoration2 = BoxDecoration(
   // borderRadius: BorderRadius.circular(30),
    color: Colors.grey.shade200.withOpacity(0.25),
  );
  static void showCustomSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            // Perform some action when the user taps on the action button
          },
        ),
      ),
    );
  }














// Add more color constants as needed
}


