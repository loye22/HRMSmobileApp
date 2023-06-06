import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class redButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  redButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.red, // Set the button color to red
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}