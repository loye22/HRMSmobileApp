import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilehrmss/screens/attenddanceReportsScreen.dart';
import 'package:mobilehrmss/screens/attendenceScreen.dart';
import 'package:mobilehrmss/screens/errorScreen.dart';
import 'package:mobilehrmss/screens/homeScreen.dart';
import 'package:mobilehrmss/screens/profileScreen.dart';
import 'package:mobilehrmss/screens/requestReportsScreen.dart';
import 'package:mobilehrmss/screens/requsitsScreen.dart';
import 'package:mobilehrmss/screens/splashScreen.dart';
import 'package:mobilehrmss/screens/loginPage.dart';
import 'package:mobilehrmss/screens/workExpensesScreen.dart';
import 'package:provider/provider.dart';
import 'models/AppColors.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot)  {
          if (snapshot.hasData) {
            return homeScreen();
          } else {
            return loginPage();
          }
        },
      ),
          routes: {
            homeScreen.routeName: (ctx) => homeScreen(),
            errorPage.routeName: (ctx) => errorPage(imagePath: ''),
            splashScreen.routeName: (ctx) => splashScreen(),
            loginPage.routeName: (ctx) => loginPage(),
            attendenceScreen.routeName: (ctx) => attendenceScreen(),
            profileScreen.routeName: (ctx) => profileScreen(),
            requsitsScreen.routeName: (ctx) => requsitsScreen(),
            requestReportsScreen.routeName: (ctx) => requestReportsScreen(),
            workExpensesScreen.routeName: (ctx) => workExpensesScreen(),
            attenddanceReportsScreen.routeName: (ctx) => attenddanceReportsScreen(),

    },
    );
  }
}
