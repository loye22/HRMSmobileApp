import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  dynamic them = null;

  final VoidCallback onPress;

  final IconData icon;

  String? txt;

  bool isSelected;

  Button(
      {required this.icon,
      required this.onPress,
      required this.txt,
      required this.isSelected});

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),

            color:Color.fromRGBO(106, 133, 104, 100)),
        width: 200,
        //height: 30,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Row(
            children: [
              Icon(
                this.widget.icon,
                color: Colors.white,
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Text(
                this.widget.txt.toString(),
                style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.035),
              ))
            ],
          )),
        ),
      ),
      onTap: () {
        this.widget.onPress;
        //this.widget.them = Colors.grey.shade200.withOpacity(0.45) ;
        //setState(() {});

        this.widget.onPress();
      },
      onHover: (bool x) {
        //   print("on");
      },
      borderRadius: BorderRadius.circular(30),
    );
  }
}
