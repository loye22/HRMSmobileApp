import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilehrmss/screens/profileScreen.dart';
import 'package:mobilehrmss/screens/requestReportsScreen.dart';
import 'package:mobilehrmss/screens/requsitsScreen.dart';
import 'package:mobilehrmss/screens/workExpensesScreen.dart';
import 'package:mobilehrmss/widgets/background2.dart';
import 'package:mobilehrmss/widgets/button2.dart';
import 'package:mobilehrmss/widgets/customNavigationBar.dart';

import '../models/AppColors.dart';
import '../widgets/background.dart';
import 'attenddanceReportsScreen.dart';
import 'attendenceScreen.dart';
enum _SelectedTab { home, favorite, search, person }
class homeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';

  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {
      print('app inactive, is lock screen: }');
    } else if (state == AppLifecycleState.resumed) {

      /*await screenLock(
        context: context,
        correctString: '1234',
      );*/
    }
  }




  @override
  Widget build(BuildContext context) {

    double buttonWidth = MediaQuery.of(context).size.width / 2.4 ;
    double buttonHeidth = MediaQuery.of(context).size.height / 8 ;// 70;
    var _selectedTab = _SelectedTab.home;
    void _handleIndexChanged(int i) {
      setState(() {
        _selectedTab = _SelectedTab.values[i];
      });
    }


    return Scaffold(
      body: Background(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(

              padding: EdgeInsets.only(top: 20),
              child: FutureBuilder(
                future: getEmployeeData(),
                builder: (ctx,snapShot){
                  if (snapShot.hasError){
                    return Center(child: Text('404Error'),);
                  }
                  if(snapShot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator(color: Colors.white,),);
                  }
                  else {
                    return  Animate(
                      effects: [ FadeEffect()],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height:MediaQuery.of(context).size.width * 0.04 ,),
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.13,
                            backgroundImage: NetworkImage(snapShot.data!['photo']),
                            backgroundColor: AppColors.staticColor,

                          ) ,
                          SizedBox(height: 20,),
                          Container(
                            width: MediaQuery.of(context).size.width  * 0.9 ,
                            height: MediaQuery.of(context).size.width  * 0.09,
                            child: Center(
                              child: Text('welcome, ${snapShot.data!['userName'].toString().split('_')[0]}' , style: GoogleFonts.montserratAlternates(
                                  fontSize: MediaQuery.of(context).size.width *0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),),
                            ),
                          )

                        ],
                      ),
                    );
                  }


                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.25),
              ),
            ),
            Positioned(
              top: 30,
                left: 20,
                child: Transform.rotate(
                    angle: 180 * 3.1415927 / 180, // Rotation angle in radians (180 degrees)
                    child: GestureDetector(
                        onTap: () async {
                          await FirebaseAuth
                              .instance
                              .signOut();

                        },
                        child: Container(child: Icon(Icons.logout , size: 35, color: Colors.white,),)))),
            Positioned(
              top: MediaQuery
                  .of(context)
                  .size
                  .width - 170,
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
                        Animate(
                          effects: [AppColors.leftEffect(Duration(milliseconds: 500))],
                          child: Container(
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
                        ),
                        Animate(
                          effects: [AppColors.rightEffect(Duration(milliseconds: 500))],
                          child: Container(
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
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Animate(
                          effects: [AppColors.leftEffect(Duration(milliseconds: 1000))],
                          child: Container(
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
                        ),
                        Animate(
                          effects: [AppColors.rightEffect(Duration(milliseconds: 1000))],
                          child: Container(
                            width: buttonWidth,
                            height: buttonHeidth,
                            child: Button(
                                icon: Icons.report_gmailerrorred,
                                onPress: () async {
                                  Navigator.of(context).pushNamed(attenddanceReportsScreen.routeName);
                                 // AppColors.showCustomSnackbar(context, 'message');

                                },
                                txt: 'Attenddance\nreports  ',
                                isSelected: true),
                          ),
                        ),

                      ],
                    ) ,
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Animate(
                          effects: [AppColors.leftEffect(Duration(milliseconds: 1500))],
                          child: Container(
                            width: buttonWidth,
                            height: buttonHeidth,
                            child: Button(
                                icon: Icons.currency_exchange,
                                onPress: () {
                                  Navigator.of(context).pushNamed(workExpensesScreen.routeName);
                                },
                                txt: 'Work\nexpenses',
                                isSelected: true),
                          ),
                        ),
                        Animate(
                          effects: [AppColors.rightEffect(Duration(milliseconds: 1500))],

                          child: Container(
                            width: buttonWidth,
                            height: buttonHeidth,
                            child: Button(
                                icon: Icons.report_rounded,
                                onPress: () {
                                  Navigator.of(context).pushNamed(requestReportsScreen.routeName);
                                },
                                txt: 'Request\nreports',
                                isSelected: true),
                          ),
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
            ),
          ],
        ),
      ),
    );
  }
  Future<Map<String, dynamic>?> getEmployeeData() async {
    // Replace 'your_collection_path' with the actual collection path in your Firebase Firestore
    String collectionPath = 'Employee';
    String employeeId = '';

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        employeeId = user.uid;
      } else {
        throw Exception('User is not currently signed in.');
      }
      // Get the employee document using the provided ID
      DocumentSnapshot<Map<String, dynamic>> employeeSnapshot =
      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(employeeId)
          .get();

      // Check if the employee document exists
      if (employeeSnapshot.exists) {
        // print(employeeSnapshot.data()!);
        return employeeSnapshot.data()!;
      } else {
        throw Exception(
            'Employee document with ID $employeeId does not exist.');
      }
    } catch (e) {
      throw Exception('Failed to retrieve employee data: $e');
    }
  }

}
