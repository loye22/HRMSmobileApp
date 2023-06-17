import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/AppColors.dart';

class attenddanceReportsScreen extends StatefulWidget {
  static const routeName = '/attenddanceReportsScreen';

  const attenddanceReportsScreen({Key? key}) : super(key: key);

  @override
  State<attenddanceReportsScreen> createState() =>
      _attenddanceReportsScreenState();
}

class _attenddanceReportsScreenState extends State<attenddanceReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: [
        Container(
          decoration: AppColors.decoration,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withOpacity(0.25),
          ),
        ),
        Positioned( bottom: 10,
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              height: MediaQuery.of(context).size.height - 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.55),
                borderRadius: BorderRadius.circular(30),
              ),))
      ]),
    );
  }
}
