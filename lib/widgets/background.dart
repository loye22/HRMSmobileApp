import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(

        children: <Widget>[

          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
                "assets/homeScreenBg.jpg",
                width: size.width
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Animate(
              effects: [SlideEffect()],
              child: Image.asset(
                  "assets/top_main.png",
                  width: size.width
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Animate(
              effects: [FadeEffect(delay: Duration(milliseconds: 1000 ) , duration: Duration(milliseconds: 1000))],
              child: Container(
                width: 200,
                height: MediaQuery.of(context).size.height * 0.22,
                child: Image.asset(
                    "assets/bottom_Main.png",
                    width: size.width
                ),
              ),
            ),
          ),

          child
        ],
      ),
    );
  }
}