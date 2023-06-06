

import 'package:flutter/material.dart';
import 'package:mobilehrmss/screens/splashScreen.dart';

import '../widgets/button.dart';

class errorPage extends StatelessWidget {
  static const routeName = '/ErrorPage';
  final String imagePath;
  errorPage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        image: DecorationImage(image: AssetImage(imagePath) , fit: BoxFit.cover ) ,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent ,
        body:Stack(
          alignment: Alignment.center,
            children: [
              Positioned(
                  bottom: 50,
                  child: Center(child: redButton(text: 'refresh',onPressed: (){
                    Navigator.of(context).pushReplacementNamed(splashScreen.routeName);
                  },)))
            ],

        ),
      ),
    );
  }
}
