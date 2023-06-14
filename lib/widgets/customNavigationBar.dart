import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class customNavigationBar extends StatefulWidget {
  final int currentIndex;
  final BuildContext ctx ;



  customNavigationBar({required this.currentIndex, required this.ctx});

  @override
  State<customNavigationBar> createState() => _customNavigationBarState();
}

class _customNavigationBarState extends State<customNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return DotNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: (i){
        try {
          if(widget.currentIndex == 1 )
            return;
          Navigator.of(widget.ctx).pop();
        }
        catch(e){

        }
      },
      items: [
        DotNavigationBarItem(
          icon: Icon(Icons.arrow_back_ios_rounded),
          selectedColor: Colors.purple,
        ),
        DotNavigationBarItem(
          icon: Icon(Icons.home),
          selectedColor: Colors.purple,
        ),

        DotNavigationBarItem(
          icon: Icon(Icons.notifications_none_sharp),
          selectedColor: Colors.teal,
        ),
      ],
    );
  }
}