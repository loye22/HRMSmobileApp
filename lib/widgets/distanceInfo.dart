import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class distanceInfo extends StatefulWidget {
  final double distance;

  const distanceInfo({
    Key? key,
    required this.distance,
  }) : super(key: key);

  @override
  State<distanceInfo> createState() => _distanceInfoState();
}

class _distanceInfoState extends State<distanceInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 70,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child:widget.distance <= 100 ?
      Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30) , color: Colors.greenAccent,),
        child: Row(
          children: [
            SizedBox(width: 50,),
            Icon(Icons.check_circle_outline , color: Colors.white,),
            SizedBox(width: 50,),
            Text('you are in side the office \n ${widget.distance}' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 18),),
          ],
        ),
      )
      :  Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30) , color: Colors.red,),
        child: Row(
          children: [
            SizedBox(width: 30,),
            Icon(Icons.cancel_outlined , color: Colors.white,),
            SizedBox(width: 50,),
            Expanded(child: Text('you are out side the office please click refresh  \n ${widget.distance}' , style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold , fontSize: 18),)),
          ],
        ),
      ),
    );
  }
}
