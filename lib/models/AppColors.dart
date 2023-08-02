import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color color1 = Color(0xFF4BA1D9); // Example color 1
  static const Color color2 = Color(0xFF1FBAAB);
  static Color colorWithOpacity =
      Colors.grey.shade200.withOpacity(0.25); // Example color 2
  static const BoxDecoration decoration = BoxDecoration(
    image: DecorationImage(
        image: AssetImage("assets/BayanatiBG.jpg"), fit: BoxFit.cover),
  );
  static TextStyle textStyle1 = GoogleFonts.montserratAlternates(
      fontSize: 20,
      color: Color.fromRGBO(0, 81, 45, 100),
      fontWeight: FontWeight.w500);

  static TextStyle textStyle2 = GoogleFonts.montserratAlternates(
      fontSize: 20,
      color: Color.fromRGBO(0, 81, 45, 100),
      fontWeight: FontWeight.bold);

  static BoxDecoration decoration2 = BoxDecoration(
    // borderRadius: BorderRadius.circular(30),
    color: Colors.grey.shade200.withOpacity(0.25),
  );
  static Color staticColor = Color.fromRGBO(106, 133, 104, 100);

  //static SlideEffect leftEffect = SlideEffect( duration: Duration(milliseconds: 500), delay: Duration(milliseconds: 400) , begin:Offset(-2.0, 0.0) , end: Offset(0.0, 0.0));
  // static SlideEffect rightEffect = SlideEffect( duration: Duration(milliseconds: 500), delay: Duration(milliseconds: 400) , begin:Offset(0.0, 2.0) , end: Offset(0.0, 0.0));

  static SlideEffect leftEffect(Duration d) {
    return SlideEffect(
        duration: Duration(milliseconds: 600),
        delay: d,
        begin: Offset(-4.0, 0.0),
        end: Offset(0.0, 0.0));
  }

  static SlideEffect rightEffect(Duration d) {
    return SlideEffect(
        duration: d,
        delay: Duration(milliseconds: 600),
        begin: Offset(4.0, 0.0),
        end: Offset(0.0, 0.0));
  }

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

  static TextStyle myTextStyleWithSizde(double s) {
    return GoogleFonts.montserratAlternates(
        fontSize: s,
        color: Color.fromRGBO(0, 81, 45, 100),
        fontWeight: FontWeight.w500);
  }

// Add more color constants as needed
}
