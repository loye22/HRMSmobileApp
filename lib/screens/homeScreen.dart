import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobilehrmss/screens/profileScreen.dart';
import 'package:mobilehrmss/screens/requestReportsScreen.dart';
import 'package:mobilehrmss/screens/requsitsScreen.dart';
import 'package:mobilehrmss/screens/workExpensesScreen.dart';
import 'package:mobilehrmss/widgets/background2.dart';
import 'package:mobilehrmss/widgets/button2.dart';
import 'package:mobilehrmss/widgets/customNavigationBar.dart';

import '../models/AppColors.dart';
import 'attenddanceReportsScreen.dart';
import 'attendenceScreen.dart';
enum _SelectedTab { home, favorite, search, person }
class homeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';

  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  double buttonWidth = 170;
  double buttonHeidth = 70;


  @override
  Widget build(BuildContext context) {
    var _selectedTab = _SelectedTab.home;

    void _handleIndexChanged(int i) {
      setState(() {
        _selectedTab = _SelectedTab.values[i];
      });
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: AppColors.decoration,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200.withOpacity(0.25),
            ),
          ),
          Positioned(
            top: MediaQuery
                .of(context)
                .size
                .width - 300,
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 50,

              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: buttonWidth,
                        height: buttonHeidth,
                        child: Button(
                            icon: Icons.check_circle,
                            onPress: () {
                              Navigator.of(context).pushNamed(
                                  attendenceScreen.routeName);
                            },
                            txt: 'Attendance ',
                            isSelected: true),
                      ),
                      Container(
                        width: buttonWidth,
                        height: buttonHeidth,
                        child: Button(
                            icon: Icons.person_outline,
                            onPress: () {
                              print('object');
                              Navigator.of(context).pushNamed(profileScreen.routeName);
                            },
                            txt: 'Profile',
                            isSelected: true),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: buttonWidth,
                        height: buttonHeidth,
                        child: Button(
                            icon: Icons.sync_alt,
                            onPress: () {
                              Navigator.of(context).pushNamed(requsitsScreen.routeName);
                            },
                            txt: 'Request  ',
                            isSelected: true),
                      ),
                      Container(
                        width: buttonWidth,
                        height: buttonHeidth,
                        child: Button(
                            icon: Icons.report_gmailerrorred,
                            onPress: () {
                              Navigator.of(context).pushNamed(attenddanceReportsScreen.routeName);
                            },
                            txt: 'Attenddance reports  ',
                            isSelected: true),
                      ),

                    ],
                  ) ,
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: buttonWidth,
                        height: buttonHeidth,
                        child: Button(
                            icon: Icons.currency_exchange,
                            onPress: () {
                              Navigator.of(context).pushNamed(workExpensesScreen.routeName);
                            },
                            txt: 'Work expenses',
                            isSelected: true),
                      ),
                      Container(
                        width: buttonWidth,
                        height: buttonHeidth,
                        child: Button(
                            icon: Icons.report_rounded,
                            onPress: () {
                              Navigator.of(context).pushNamed(requestReportsScreen.routeName);
                            },
                            txt: 'Request reports',
                            isSelected: true),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [


                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
