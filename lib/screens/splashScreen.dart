import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobilehrmss/models/Dialog.dart';
import 'package:mobilehrmss/screens/errorScreen.dart';
import 'package:mobilehrmss/widgets/background.dart';

import '../models/AppColors.dart';
import '../widgets/background2.dart';
import 'homeScreen.dart';

class splashScreen extends StatefulWidget {
  static const routeName = '/splashScreen';

  const splashScreen({Key? key}) : super(key: key);

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  Future<bool> checkConecction() async {
    bool result = await InternetConnectionChecker().hasConnection;
    print(result.toString() + " <<<<<<<<<<<<<<<<<<<<<<<<<<");
    // true if you are online
    // false
    result
        ? Navigator.of(context).pushReplacementNamed(homeScreen.routeName)
        : Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  errorPage(imagePath: 'assets/noConnection.png'),
            ),
          );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkConecction(),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Background2(child: Center(child: CircularProgressIndicator(color: Colors.orange,),))
            /*Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: AppColors.decoration,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(30),
                          color: Colors.grey.shade200.withOpacity(0.25),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'HRMS',
                                  style: GoogleFonts.poppins(
                                      color: Colors.white, fontSize: 50),
                                ),
                                Container(
                                    height: 100,
                                    child: Image.asset('assets/b.png'))
                              ],
                            ), /*Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.colorWithOpacity
                    ),

                  ),*/
                          ),
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  )*/
                : Text(''),
      ),
    );
  }
}
